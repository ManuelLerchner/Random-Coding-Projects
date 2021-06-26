import requests
import json
import numpy as np
import cv2

with open(".secrets") as secr:
    secrets = json.load(secr)
    username = secrets["username"]
    password = secrets["password"]

my_ip = "manuellerchner.ddns.net:4250"
url = f"http://{username}:{password}@{my_ip}/photoaf.jpg"


def getLatestImage():
    response = requests.get(url, stream=True).raw

    img = np.asarray(bytearray(response.read()), dtype="uint8")
    img = cv2.flip(cv2.imdecode(img, cv2.IMREAD_COLOR), -1)

    filename = "test.jpg"
    cv2.imwrite(filename, img)

    print('Image sucessfully Downloaded: ', filename)
