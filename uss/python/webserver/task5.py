from flask import Flask, render_template, request
from zoautil_py import datasets
import requests
import json


app = Flask(__name__)


def callIoT(devid):
    IoTurl = "http://192.86.32.12:1880/status/"
    response = requests.get(IoTurl + str(devid))

    return response.json()


# define the home route, and the function to run
@app.route("/")
def index():
    # call the callIoT API and return a JSON object
    IoTObject = callIoT(2732) ## YOUR device Id

    # convert IoTObject to a Python List and strip the "d" key
    IoTList = IoTObject['d']

    # define the URL to call
    getItemsURL = "http://204.90.115.200:50780/catalogManager/items?startItemID="

    # set the authorization information
    header = {"Authorization" : "Basic Tmljb2xhc0Jvc3M6bmljb2xhcw=="}
    
    # call the request with the URL and authorization
    response = requests.get(
        getItemsURL + "0", ## note the 0 - this marks where the API should start
        headers = header
    )

    responseJSON = response.json()
    responseList = responseJSON["DFH0XCMNOperationResponse"]["ca_inquire_request"]["ca_cat_item"]
    # print(responseList)

    # return the information you got back from zCEE and CICS as JSON
    # return response.json()
    # return render_template('index.html', catalog=responseList)

    return render_template('indexTask4.html', catalog=responseList, iotData=IoTList)


@app.route('/detailedInfo')
def detailedInfo():
    # Get the value of the query parameter itemID from the URL
    ca_item_ref = request.args.get('itemID')

    # set the url including the query parameter
    url2 = "http://204.90.115.200:50780/catalogManager/items/" + ca_item_ref

    # set the header
    header = {"Authorization" : "Basic Tmljb2xhc0Jvc3M6bmljb2xhcw=="}

    # get the response for the detailed information of the item selected
    response = requests.get(url2, headers = header)

    # turn the response into a Dictionary
    responseJSON = response.json()

    # get proper information - walk through "DFH0XCMNOperationResponse", "ca_inquire_single" and "ca_single_item" keys
    detailedInfoDict = responseJSON["DFH0XCMNOperationResponse"]["ca_inquire_single"]["ca_single_item"]

    # find item color from zOS dataset
    dsContent = datasets.read("ZXP.HACKDAYS.COLOUR.MAP(CODETHON)")
    lines = dsContent.splitlines()
    target = int(detailedInfoDict["ca_sngl_item_ref"])
    for line in lines:
        if int(line[0:4]) == target:
            hexColor = line[20:26]

    return render_template ('details.html', item=detailedInfoDict, hexColor=hexColor)


@app.route('/list_members')
def list_Members():
    # use ZOAU dataset.lists_member() to list the datasets
    dsMembers = datasets.list_members("ZXP.HACKDAYS.COLOUR.MAP", value="line")

    # print them on the terminal screen
    print (dsMembers)

    # to satisfy the route's return
    return ("no data")


@app.route('/content')
def get_DataSet_Content():
    # use ZOAU dataset.read() call to list the content of a dataset
    dsContent = datasets.read("ZXP.HACKDAYS.COLOUR.MAP(CODETHON)")
    # print(dsContent)

    lines = dsContent.splitlines()
    colors = []

    for line in lines:
        color = {
            "id": line[0:4],
            "color": line[5:19],
	        "hex": line[20:26],
            "chsv": line[27:30]
        }
        colors.append(color)

    # to satisfy the route's return
    # return ("no data")
    return render_template ('content.html', content=colors)


@app.route('/Order', methods=['POST'])
def placeOrder():
    # get the POSTed information into local variables
    ca_userid = request.form['userID']
    ca_charge_dept = request.form['dept']
    ca_quantity_req = request.form['qty']
    ca_item_ref_number = request.form['itemRef']
    color = request.form['hex_color']

    # set the url for the Order API
    url = "http://204.90.115.200:50780/catalogManager/orders"


    # include the authorization header
    header = {"Authorization" : "Basic Tmljb2xhc0Jvc3M6bmljb2xhcw=="}

    # create an object to send along the POST request
    order = {
        "DFH0XCMNOperation": {
            "ca_order_request": {
                "ca_item_ref_number": 180,
                "ca_quantity_req": 1,
                "ca_userid": "Bob",
                "ca_charge_dept": "HR"
            }
        }
    }

    # call the POST request and store the result in response
    response = requests.post(url, headers=header, json=order)

    # create a JSON Object from the response
    responseJSON = response.json()
    print(responseJSON)

    # create the url to send to IoT
    iotURL = "http://192.86.32.12:1880/hackdata/2732"

    # create a JSON object with 4 keys.
    #   first key is the "status" holding the returned responseMessage from CICS
    #   second key "color" to be represented on the leader board
    #   third key is the leader name
    #   fourth key is device number
    publishIOT = {
        'status' : responseJSON["DFH0XCMNOperationResponse"]["ca_response_message"],
        'color'  : color,
        'leader' : "Julio Errecart",   # Global Var that holds the leader info from the IoT call
        'dev'    : "2732"              # Global Var that holds the dev info from the IoT call
    }

    response3 = requests.post(iotURL, json=publishIOT)

    return render_template(
        'order-placed.html',
        orderedInfo=responseJSON["DFH0XCMNOperationResponse"]
    )


if __name__ == "__main__":
    app.run(
        host="204.90.115.200",
        port=0
    )
    