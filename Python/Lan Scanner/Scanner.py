import subprocess
import re
import threading


def scan(ip):
    res = subprocess.check_output(
        f"nslookup {ip}", shell=True, stderr=subprocess.DEVNULL).decode("utf-8")

    match = re.search("Name: *(.*)\n", res)
    if(match):
        deviceName = match.group(1).split(".")[0]
        print("{:<16}  {:<25}".format(ip, deviceName))


for i in range(100, 201):
    ip = f"192.168.0.{i}"
    x = threading.Thread(target=scan, args=[ip])
    x.start()
