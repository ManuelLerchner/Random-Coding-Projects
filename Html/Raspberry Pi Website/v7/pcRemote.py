import subprocess
import json
import logToFile

# Login Creds
with open('auth.json') as json_file:
    config = json.load(json_file)

username = config.get("UN_MIC_PC")
password = config.get("PW_MIC_PC")
mac = config.get("PC_MAC")
ip = config.get("PC_IP")

# Commands
shutdownCommand = rf'net rpc shutdown -t 30 -U {username}%{password} -I {ip}'.split()
wakeupCommand = "wakeonlan {mac}"


def shutdown():
    logToFile.log("PC-Shutdown:")
    executeCommand(shutdownCommand)


def wakeUp():
    logToFile.log("PC-WakeUp:")
    executeCommand(wakeupCommand)


def executeCommand(command):
    subprocess.run(
        command,
        stdout=subprocess.PIPE,
        encoding='UTF8'
    )
