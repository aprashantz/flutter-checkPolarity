from logging import debug
from flask import Flask, jsonify, request
from generatePolarity import getPolarity

app = Flask(__name__)


@app.route('/')
def index():
    return 'Go to /textblob/your_data for textblob api'

# method to handle post request


@app.route('/textblob', methods=['POST'])
def createPolarity():
    request_data = request.get_json()
    data = request_data['data']
    generated_polarity = getPolarity(data)
    return {"polarity": generated_polarity}


if __name__ == "__main__":
    app.run(debug=True, host="192.168.0.2", port=4652)
