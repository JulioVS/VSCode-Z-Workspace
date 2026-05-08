from flask import Flask, render_template, request

import requests
import json
import paho.mqtt.client as mqtt

from zoautil_py import datasets

app = Flask(__name__)

# MQTT Broker details
BROKER = "test.mosquitto.org"
PORT = 1883
TOPIC = "IBMZ"

def iot(message):
    client = mqtt.Client()
    client.connect(BROKER, PORT, 60)
    client.publish(TOPIC, message)
    client.disconnect()

def get_DataSet_Content():
    dsContent = datasets.read("ZXP.HACKDAYS.COLOUR.MAP(CODETHON)")
    color_map = {}

    for line in dsContent.splitlines():
        parts = line.split(',')

        if len(parts) >= 4:
            item_ref = parts[3].strip().zfill(3)
            color_name = parts[1].strip()
            hex_code = parts[2].strip()

            color_map[item_ref] = {
                "name": color_name,
                "hex": hex_code
            }

    return color_map

def list_catalog_Items():
    getItemsURL = "http://204.90.115.200:50780/catalogManager/items?startItemID="
    header = {"Authorization": "Basic Tmljb2xhc0Jvc3M6bmljb2xhcw=="}

    response = requests.get(getItemsURL + "0", headers=header)
    responseJSON = response.json()
    responseObject2 = responseJSON["DFH0XCMNOperationResponse"]["ca_inquire_request"]["ca_cat_item"]

    for items in responseObject2:
        items['ca_item_ref'] = str(items['ca_item_ref']).zfill(3)

    return responseObject2

@app.route('/')
def index():
    return render_template('index.html', catalog=list_catalog_Items())

@app.route('/detailedInfo')
def detailedInfo():
    color_map = get_DataSet_Content()
    ID = request.args.get('itemID')

    url2 = f"http://204.90.115.200:50780/catalogManager/items/{ID}"
    header = {"Authorization": "Basic Tmljb2xhc0Jvc3M6bmljb2xhcw=="}

    response = requests.get(url2, headers=header)
    responseJSON = response.json()
    detailedInfoDict = responseJSON["DFH0XCMNOperationResponse"]["ca_inquire_single"]["ca_single_item"]

    item_ref_raw = detailedInfoDict.get('ca_sngl_item_ref')
    item_ref = str(item_ref_raw).zfill(3) if item_ref_raw is not None else "000"

    color_info = color_map.get(item_ref, {"name": "Unknown", "hex": "#000000"})
    detailedInfoDict['color'] = color_info["name"]
    detailedInfoDict['hex'] = color_info["hex"]

    iot(color_info["hex"])

    return render_template('indexdetail.html', catalog=[detailedInfoDict])

# Run the Flask app
app.run(
    host="204.90.115.200",
    port=0,
    debug=False
)
