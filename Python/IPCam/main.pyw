import requests
import cv2
import imutils
import time
import json
import datetime


with open(".secrets") as file:
    data = json.load(file)
    username = data['username']
    password = data['password']

my_ip = '192.168.0.189:8080'


vcap = cv2.VideoCapture(f"http://{username}:{password}@{my_ip}/video/mjpeg")

tDetected = time.time()
window_name = "Camera"
frame = None
gray = None
NightMode = False

requests.get(
    f"http://{username}:{password}@{my_ip}/settings/night_vision?set=off")
print("NightMode Off")


def detectMotion(frame, frameA, frameB):
    frameDelta = cv2.absdiff(frameA, frameB)
    thresh = cv2.threshold(frameDelta, 10, 255, cv2.THRESH_BINARY)[1]
    thresh = cv2.dilate(thresh, None, iterations=10)

    cnts = cv2.findContours(thresh.copy(), cv2.RETR_EXTERNAL,
                            cv2.CHAIN_APPROX_SIMPLE)
    cnts = imutils.grab_contours(cnts)

    count = 0

    for c in cnts:
        if cv2.contourArea(c) < 1000:
            continue
        count += 1

        (x, y, w, h) = cv2.boundingRect(c)
        frame = cv2.rectangle(frame, (x, y), (x + w, y + h), (0, 255, 0), 2)
    return count


def handleNightMode():
    global NightMode
    now = datetime.datetime.now()
    now_time = now.time()

    if now_time >= datetime.time(20, 30) or now_time <= datetime.time(6, 00):
        if not NightMode:
            requests.get(
                f"http://{username}:{password}@{my_ip}/settings/night_vision?set=on")
            print("NightMode On")
            NightMode = True
    else:
        if NightMode:
            requests.get(
                f"http://{username}:{password}@{my_ip}/settings/night_vision?set=off")
            print("NightMode Off")
            NightMode = False


while vcap.isOpened():
    ret, frame = vcap.read()
    #frame = cv2.rotate(frame, cv2.cv2.ROTATE_180)

    prevFrame = gray

    gray = cv2.cvtColor(frame, cv2.COLOR_BGR2GRAY)
    gray = cv2.GaussianBlur(gray, (21, 21), 0)

    if frame is not None:
        if prevFrame is not None:
            #cv2.imshow("Frame1", frame)
            objectsCount = detectMotion(frame, prevFrame, gray)

            detected = False
            if objectsCount != 0:
                tDetected = time.time()
                detected = True

            if detected:
                cv2.imshow(window_name, frame)
                #cv2.setWindowProperty(window_name, cv2.WND_PROP_TOPMOST, 1)

            if not detected:
                if time.time()-tDetected < 5:
                    cv2.imshow(window_name, frame)
                    #cv2.setWindowProperty(window_name, cv2.WND_PROP_TOPMOST, 1)
                else:
                    cv2.destroyWindow(window_name)

        handleNightMode()

        if cv2.waitKey(22) & 0xFF == ord('q'):
            break
    else:
        print("no Frame")
        break
else:
    print("closed")

vcap.release()
cv2.destroyAllWindows()
