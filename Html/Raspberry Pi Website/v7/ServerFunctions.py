import os
from passlib.hash import sha256_crypt
import json

# get config
with open('auth.json') as json_file:
    config = json.load(json_file)

#############################
#######--Requests--#########
#############################


def handleRequest(URL, data):
    if(URL == "notify"):
        return handleNotify(data)

    if URL == "controller":
        return handleController(data)


def handleNotify(data):
    name = data.get("nameField")
    text = data.get("textField")
    cookies = []

    # extract Message
    text = name + " sends " + text
    result = text[:30] + (text[30:] and '..')

    msg = [result, "notified Admin"]

    # set Cookie
    cookies.append(["messagesNotification", [msg]])

    return cookies


def handleController(data):
    cookies = []

    # handle Relay
    if data.get("submitRelay") != None:

        password = data.get("passwordRelay")
        isCorrect = sha256_crypt.verify(password, config.get("PW_Relay"))

        answer, color = evalPassword(isCorrect, "Relay opened")

        cookies.append(["messagesRelay", answer])
        cookies.append(["colorRelay", color])

    # handle PC
    if data.get("submitPC") != None:

        password = data.get("passwordPC")
        isCorrect = sha256_crypt.verify(password, config.get("PW_PC"))

        answer, color = evalPassword(isCorrect, "PC-State toggled")

        cookies.append(["messagesPC", answer])
        cookies.append(["colorPC", color])

    return cookies


def evalPassword(isCorrect, extraMessage):
    answer = ["Correct"]
    color = "aqua"
    if not isCorrect:
        answer = ["Wrong Password, try again!"]
        color = "red"

    if isCorrect:
        answer.append(extraMessage)

    return answer, color


#############################
#######--PC-State--#########
#############################

def getPCState():

    response = os.system("ping -n 1 192.168.0.100")
    if response == 0:
        state = "Manuel-PC is currently turned on"
        color = "limegreen"
    else:
        state = "Manuel-PC is currently turned off"
        color = "red"

    return state, color
