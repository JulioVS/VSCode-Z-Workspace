from flask import Flask

app = Flask(__name__)

# define the home route
@app.route("/")
# name of the function to be called for "/"
def index():
    return "Hello world, look at my first application on z/OS!"

if __name__ == "__main__":
    app.run(
        host="204.90.115.200",
        port=0,
        debug=False
    )
    