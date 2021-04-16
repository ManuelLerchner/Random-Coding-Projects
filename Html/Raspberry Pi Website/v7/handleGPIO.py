import RPi.GPIO as GPIO
import time
import threading
import logToFile

GPIO.setmode(GPIO.BOARD)
GPIO.setup(7, GPIO.OUT, initial=GPIO.HIGH)


def closeRelay():
    logToFile.log("Close-Relay")

    def worker():
        GPIO.output(7, GPIO.LOW)
        time.sleep(1.5)
        GPIO.output(7, GPIO.HIGH)

    x = threading.Thread(target=worker)
    x.start()
