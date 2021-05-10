import cv2
import imutils
import time
import json

with open(".secrets") as file:
    data = json.load(file)
    username = data['username']
    password = data['password']

my_ip = '192.168.0.103'


vcap = cv2.VideoCapture(f'http://{username}:{password}@'+my_ip+":8080/video")

lasttime = time.time()
frame = None
gray = None


def detectMotion(frame, frameA, frameB):
    frameDelta = cv2.absdiff(frameA, frameB)
    thresh = cv2.threshold(frameDelta, 10, 255, cv2.THRESH_BINARY)[1]
    thresh = cv2.dilate(thresh, None, iterations=10)

    cnts = cv2.findContours(thresh.copy(), cv2.RETR_EXTERNAL,
                            cv2.CHAIN_APPROX_SIMPLE)
    cnts = imutils.grab_contours(cnts)

    for c in cnts:
        if cv2.contourArea(c) < 200:
            continue
        (x, y, w, h) = cv2.boundingRect(c)
        frame = cv2.rectangle(frame, (x, y), (x + w, y + h), (0, 255, 0), 2)
    return len(cnts)


while vcap.isOpened():
    ret, frame = vcap.read()
    #frame = cv2.rotate(frame, cv2.cv2.ROTATE_180)

    prevFrame = gray

    gray = cv2.cvtColor(frame, cv2.COLOR_BGR2GRAY)
    gray = cv2.GaussianBlur(gray, (21, 21), 0)

    if frame is not None:
        if prevFrame is not None:
            objectsCount = detectMotion(frame, prevFrame, gray)

            if objectsCount != 0:
                cv2.imshow('cam', frame)
                lasttime = time.time()

            if objectsCount == 0:
                if time.time()-lasttime < 5:
                    cv2.imshow('cam', frame)
                else:
                    cv2.destroyAllWindows()

        if cv2.waitKey(22) & 0xFF == ord('q'):
            break
    else:
        print("no Frame")
        break
else:
    print("closed")

vcap.release()
cv2.destroyAllWindows()
