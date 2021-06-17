import os
from passlib.hash import sha256_crypt
import json
import sendEmail
import handleGPIO
import pcRemote

# get config
with open('auth.json') as json_file:
    config = json.load(json_file)

ip = config.get("PC_IP")
pwRelay = config.get("PW_Relay")
pwPC = config.get("PW_PC")

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

    # send Mail
    sendEmail.sendMail("RaspberryPi Messenger-Service", text)

    # set Cookie
    cookies.append(["messagesNotification", msg])

    return cookies


def handleController(data):
    cookies = []

    # handle Relay
    if data.get("submitRelay") != None:

        password = data.get("passwordRelay")
        isCorrect = sha256_crypt.verify(password, pwRelay)

        answer, color = evalPassword(isCorrect, "Relay opened")

        # Action
        if(isCorrect):
            handleGPIO.closeRelay()
            text = "Door just opened!"
            # send Mail
            sendEmail.sendMail("RaspberryPi Door-Service", text)

        cookies.append(["messagesRelay", answer])
        cookies.append(["colorRelay", color])

    # handle PC
    if data.get("submitPC") != None:

        password = data.get("passwordPC")
        isCorrect = sha256_crypt.verify(password, pwPC)

        answer, color = evalPassword(isCorrect, "PC-State toggled")

        # Action
        if(isCorrect):
            statePC, colorPCState = getPCState()
            if statePC.split(" ")[-1] == "on":
                pcRemote.shutdown()
                print("shutdown")
            if statePC.split(" ")[-1] == "off":
                pcRemote.wakeUp()
                print("wakeup")

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


############################
#######--PC-State--#########
############################

def getPCState():
    response = os.system(f"ping -c 1 {ip}")
    if response == 0:
        state = "Manuel-PC is currently turned on"
        color = "limegreen"
    else:
        state = "Manuel-PC is currently turned off"
        color = "red"

    return state, color
