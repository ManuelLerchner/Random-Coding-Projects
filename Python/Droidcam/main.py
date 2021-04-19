import cv2
import imutils

my_ip = '192.168.0.144'

vcap = cv2.VideoCapture('http://'+my_ip+":8080/video")

frame = None


def calcDiff(frame, frameA, frameB):

    frameDelta = cv2.absdiff(frameA, frameB)
    thresh = cv2.threshold(frameDelta, 25, 255, cv2.THRESH_BINARY)[1]

    thresh = cv2.dilate(thresh, None, iterations=5)

    cnts = cv2.findContours(thresh.copy(), cv2.RETR_EXTERNAL,
                            cv2.CHAIN_APPROX_SIMPLE)
    cnts = imutils.grab_contours(cnts)

    for c in cnts:
        # if the contour is too small, ignore it
        if cv2.contourArea(c) < 500:
            continue
        (x, y, w, h) = cv2.boundingRect(c)
        cv2.rectangle(frame, (x, y), (x + w, y + h), (0, 255, 0), 2)


gray = None

while vcap.isOpened():

    ret, frame = vcap.read()

    prevFrame = gray

    #frame = imutils.resize(frame, width=500)
    gray = cv2.cvtColor(frame, cv2.COLOR_BGR2GRAY)
    gray = cv2.GaussianBlur(gray, (21, 21), 0)

    if frame is not None:

        if prevFrame is not None:
            calcDiff(frame, prevFrame, gray)

        cv2.imshow('cam', frame)

        if cv2.waitKey(22) & 0xFF == ord('q'):
            break
    else:
        break
else:
    print("failed")

vcap.release()
cv2.destroyAllWindows()
