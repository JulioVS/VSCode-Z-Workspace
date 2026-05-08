from flask import Flask, render_template, request
import requests
import json

app = Flask(__name__)

def list_catalog_Items():
    getItemsURL = "http://204.90.115.200:50780/catalogManager/items?startItemID="
    header = {"Authorization" : "Basic Tmljb2xhc0Jvc3M6bmljb2xhcw=="}

    response = requests.get(getItemsURL + "0", headers = header)
    responseJSON = response.json()
    responseObject2 = responseJSON["DFH0XCMNOperationResponse"]["ca_inquire_request"]["ca_cat_item"]

    for items in responseObject2:
        if (items['ca_item_ref'] < 100 ) :
            items['ca_item_ref'] = "00" + str(items['ca_item_ref'])
        else :
            items['ca_item_ref'] = "0" + str(items['ca_item_ref'])

    return responseObject2

@app.route('/')
def index():
    return render_template ('index.html', catalog=list_catalog_Items())

@app.route('/detailedInfo')
def detailedInfo():
    ID = request.args.get('itemID')
    print(ID)

    url2 = "http://204.90.115.200:50780/catalogManager/items/" + ID
    header = {"Authorization" : "Basic Tmljb2xhc0Jvc3M6bmljb2xhcw=="}

    response = requests.get(url2, headers = header)
    responseJSON = response.json()
    detailedInfoDict = responseJSON["DFH0XCMNOperationResponse"]["ca_inquire_single"]["ca_single_item"]
    print(detailedInfoDict)

    return render_template('indexdetail.html', catalog=[detailedInfoDict])

app.run(
    host="204.90.115.200",
    port=0,
    debug=False
)
