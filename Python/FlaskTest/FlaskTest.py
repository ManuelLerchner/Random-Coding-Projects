from flask import Flask, render_template


app = Flask(__name__)


status = False


posts = [
    {
        "author": "Manuel",
        "title": "test1",
        "content": "first first",
        "date": "22.09.2002"
    },
    {
        "author": "Jango",
        "title": "testJango",
        "content": "first testJango",
        "date": "5.19.2002"
    }
]


@app.route("/")
def hallo():
    return render_template("index.html", posts=posts)


@app.route("/toggle")
def toggle():
    global status
    status = not status

    return str(status)


app.run()
