from waitress import serve
from flask import Flask, render_template, request, redirect, session
from flask.helpers import url_for
import ServerFunctions
import logToFile


app = Flask(__name__)
app.config['SECRET_KEY'] = 'e5ac358c-f0gf-11e5-9e39-d35532c10a28'


@app.route('/')
@app.route('/index')
def main():
    logToFile.log(f"User: {request.remote_addr} connected to 'Main'")
    return render_template("index.html")


@app.route('/about')
def about():
    logToFile.log(f"User: {request.remote_addr} connected to 'About'")
    return render_template("about.html")


@app.route('/controller')
def controller():
    logToFile.log(f"User: {request.remote_addr} connected to 'Controller'")
    messagesPC = []
    messagesRelay = []
    colorRelay = ""
    colorPC = ""

    if(session.get('messagesRelay')):
        messagesRelay = session.get('messagesRelay')
        colorRelay = session.get("colorRelay")
        session.clear()

    if(session.get('messagesPC')):
        messagesPC = session.get('messagesPC')
        colorPC = session.get("colorPC")
        session.clear()

    statePC, colorPCState = ServerFunctions.getPCState()

    return render_template("controller.html",
                           MessagesPC=messagesPC, ColorPC=colorPC,
                           MessagesRelay=messagesRelay, ColorRelay=colorRelay,
                           StatePC=statePC, ColorPCState=colorPCState)


@app.route('/notify')
def notify():
    logToFile.log(f"User: {request.remote_addr} connected to 'Notify'")
    messages = []
    if(session.get('messagesNotification')):
        messages = session.get('messagesNotification')
        session.clear()

    return render_template("notify.html", Messages=messages)


@app.route('/handlePost', methods=["POST"])
def handlePost():
    logToFile.log(f"User: {request.remote_addr} made Post-Request")
    data = request.form
    URL_Location = request.referrer.split("/")[3]

    cookies = ServerFunctions.handleRequest(URL_Location, data)

    for cookie in cookies:
        session[cookie[0]] = cookie[1]

    return redirect(URL_Location)


if __name__ == '__main__':
    # app.run("192.168.0.100",port=80)
    serve(app, host="192.168.0.100", port=80)
