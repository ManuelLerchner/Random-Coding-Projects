import requests
from datetime import datetime

from PIL import Image
import matplotlib.pyplot as plt


NASA_API_KEY = "yDb5IxFMtHpPd7eQbb8hqswqGQg3vHVJUTQ0bJRH"

parameters = {
    "lat": 46.7150,
    "lon": 12.145,
    "api_key": NASA_API_KEY,
    "dim": 0.2
}


def getResponse():
    response = requests.get(
        "https://api.nasa.gov/planetary/earth/imagery", params=parameters, stream=True)

    image = Image.open(response.raw)

    image.save("Map.png")


if __name__ == '__main__':
    print("started")
    getResponse()
