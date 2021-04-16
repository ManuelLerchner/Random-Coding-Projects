import smtplib
import json
import logToFile

fromaddr = 'manuelsraspberrypi@gmail.com'
toaddrs = 'manuel.lerchner1111@gmail.com'

# Login Creds
with open('auth.json') as json_file:
    config = json.load(json_file)

username = config.get("UN_GO")
password = config.get("PW_GO")


def sendMail(SUBJECT, TEXT):
    logToFile.log("Send Email: "+SUBJECT)
    msg = 'Subject: {}\n\n{}'.format(SUBJECT, TEXT)
    server = smtplib.SMTP('smtp.gmail.com:587')
    server.starttls()
    server.login(username, password)
    server.sendmail(fromaddr, toaddrs, msg)
    server.quit()
