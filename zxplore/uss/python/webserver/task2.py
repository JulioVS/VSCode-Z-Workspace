from flask import Flask

app = Flask(__name__)

# define the home route, and the function to run
@app.route("/")
def index():
    return "Hello world, look at my first application on z/OS!"

if __name__ == "__main__":
    app.run(
        host="204.90.115.200",
        port=0
    )
