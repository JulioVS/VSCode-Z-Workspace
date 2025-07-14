from flask import Flask, render_template
import requests
import json

app = Flask(__name__)

# define the home route, and the function to run
@app.route("/")
def index():

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
    return render_template('index.html', catalog=responseList)


if __name__ == "__main__":
    app.run(
        host="204.90.115.200",
        port=0
    )
