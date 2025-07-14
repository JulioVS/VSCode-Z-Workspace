from flask import Flask, render_template
import requests
import json


app = Flask(__name__)


# define the home route, and the function to run
@app.route("/")
def index():
    # define URL to call
    getItemsURL = "http://204.90.115.200:50780/catalogManager/items?startItemID="

    # set auth info
    header = {"Authorization": "Basic Tmljb2xhc0Jvc3M6bmljb2xhcw=="}

    # call request
    response = requests.get(getItemsURL+"0", headers=header)

    # extract catalog of items
    responseJSON = response.json()
    responseList = responseJSON["DFH0XCMNOperationResponse"]["ca_inquire_request"]["ca_cat_item"]

    # render catalog in a template webpage
    return render_template("index.html", catalog=responseList)


if __name__ == "__main__":
    app.run(
        host="204.90.115.200",
        port=0
    )
