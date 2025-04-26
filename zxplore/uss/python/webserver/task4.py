from flask import Flask, render_template, request
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

    return render_template ('details.html', item=detailedInfoDict)


if __name__ == "__main__":
    app.run(
        host="204.90.115.200",
        port=0
    )
