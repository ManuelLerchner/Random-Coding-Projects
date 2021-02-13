from selenium import webdriver
from selenium.webdriver.common.keys import Keys
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
from selenium.webdriver.chrome.options import Options
import time

twait = 0.5

# Path Chrome Webdriver
PATH = "C:\Program Files (x86)\chromedriver.exe"
options = Options()
options.add_argument('--log-level=3')
#options.add_argument("--headless")
driver = webdriver.Chrome(PATH, options=options)


# Credentials Dictionary
CredentialsDict = {}
for row in open("C:/Users/Manuel/Documents/Coding Projects/Python/Data/routerConf.dat", 'r'):
    values = row.split(":")
    CredentialsDict.update({values[0]: (values[1].rstrip()).strip()})


def restartTPLink_11():
    global driver
    driver.get("http://192.168.0.11/")

    print("192.168.0.11 loaded")

    # credentials

    WebDriverWait(driver, 20).until(
        EC.element_to_be_clickable(
            (By.XPATH, '//*[@id="login-username"]'))
    ).send_keys(CredentialsDict.get("UsernameTP-Link"))

    WebDriverWait(driver, 20).until(
        EC.element_to_be_clickable(
            (By.XPATH, '// *[@id="form-login"]/div[2]/div/div/div[1]/span[1]/input[1]'))
    ).send_keys(CredentialsDict.get("PasswordTP-Link"))

    # login
    WebDriverWait(driver, 20).until(
        EC.element_to_be_clickable(
            (By.XPATH, '//*[@id="login-btn"]'))
    ).click()

    print("     logged in")

    # Find System Tools
    WebDriverWait(driver, 20).until(
        EC.element_to_be_clickable((By.LINK_TEXT, "Reboot"))
    ).click()
    print("     switched to Reboot Menu")

   # Find System Tools
    WebDriverWait(driver, 20).until(
        EC.element_to_be_clickable(
            (By.XPATH, '//*[@id="reboot_confirm_msg"]/div[4]/div/div/div[2]/div/div[2]/button'))
    ).click()

    print("     rebooted ...")


def restartTPLink_10():
    global driver
    driver.get("http://192.168.0.10/")

    print("192.168.0.10 loaded")

    # credentials

    WebDriverWait(driver, 20).until(
        EC.element_to_be_clickable(
            (By.XPATH, '//*[@id="local-login-pwd"]/div[2]/div[1]/span[2]/input[1]'))
    ).send_keys(CredentialsDict.get("PasswordTP-Link"))

    # login
    WebDriverWait(driver, 20).until(
        EC.element_to_be_clickable(
            (By.XPATH, '//*[@id="local-login-button"]/div[2]/div[1]/a/span[2]'))
    ).click()

    print("     logged in")

    # Find System Tools
    WebDriverWait(driver, 20).until(
        EC.element_to_be_clickable((By.LINK_TEXT, "Einstellungen"))
    ).click()
    print("     switched to Menu")

   # Find System Tools
    WebDriverWait(driver, 20).until(
        EC.element_to_be_clickable((By.LINK_TEXT, "System-Tools"))
    ).click()

    print("     switched to System Menu")

    # Find System Tools
    WebDriverWait(driver, 20).until(
        EC.element_to_be_clickable((By.LINK_TEXT, "Neustart"))
    ).click()

    print("     switched to Reboot Menu")

    # Reboot
    WebDriverWait(driver, 20).until(
        EC.element_to_be_clickable(
            (By.XPATH, '//*[@id = "reboot-button"]/div[2]/div[1]/a/span[2]'))
    ).click()

    WebDriverWait(driver, 20).until(
        EC.element_to_be_clickable(
            (By.XPATH, '//*[@id= "global-confirm-btn-ok"]/div[2]/div[1]/a/span[2]'))
    ).click()

    print("     rebooted ...")


def restartTPLink_04():
    global driver
    driver.get("http://192.168.0.4/")

    print("192.168.0.4 loaded")

    # credentials
    WebDriverWait(driver, 20).until(
        EC.element_to_be_clickable((By.XPATH, '//*[@id="userName"]'))
    ).send_keys(CredentialsDict.get("UsernameTP-Link"))

    WebDriverWait(driver, 20).until(
        EC.element_to_be_clickable((By.XPATH, '//*[@id = "pcPassword"]'))
    ).send_keys(CredentialsDict.get("PasswordTP-Link"))

    # login
    WebDriverWait(driver, 20).until(
        EC.element_to_be_clickable((By.XPATH, '//*[@id="loginBtn"]'))
    ).click()

    print("     logged in")

    # Change to Menu
    driver.switch_to.frame("bottomLeftFrame")
    time.sleep(twait)

    # Find System Tools
    WebDriverWait(driver, 20).until(
        EC.element_to_be_clickable((By.LINK_TEXT, "System Tools"))
    ).click()
    print("     switched to Menu")

    # Find System Tools
    WebDriverWait(driver, 20).until(
        EC.element_to_be_clickable((By.PARTIAL_LINK_TEXT, "Reboot"))
    ).click()

    print("     switched to Reboot Menu")

    # Change to Main
    driver.switch_to.parent_frame()
    driver.switch_to.frame("mainFrame")
    time.sleep(twait)

    # Reboot
    driver.find_element_by_xpath('//*[@id = "reboot"]').click()

    driver.switch_to.alert.accept()
    print("     rebooted ...")


def restartTPLink_03():
    global driver
    driver.get("http://192.168.0.3/")

    print("192.168.0.3 loaded")

    # credentials
    WebDriverWait(driver, 20).until(
        EC.element_to_be_clickable((By.XPATH, '//*[@id="userName"]'))
    ).send_keys(CredentialsDict.get("UsernameTP-Link"))

    WebDriverWait(driver, 20).until(
        EC.element_to_be_clickable((By.XPATH, '//*[@id = "pcPassword"]'))
    ).send_keys(CredentialsDict.get("PasswordTP-Link"))

    # login
    WebDriverWait(driver, 20).until(
        EC.element_to_be_clickable((By.XPATH, '//*[@id="loginBtn"]'))
    ).click()

    print("     logged in")

    # Change to Menu
    driver.switch_to.frame("bottomLeftFrame")
    time.sleep(twait)

    # Find System Tools
    WebDriverWait(driver, 20).until(
        EC.element_to_be_clickable((By.LINK_TEXT, "System Tools"))
    ).click()
    print("     switched to Menu")

    # Find System Tools
    WebDriverWait(driver, 20).until(
        EC.element_to_be_clickable((By.PARTIAL_LINK_TEXT, "Reboot"))
    ).click()

    print("     switched to Reboot Menu")

    # Change to Main
    driver.switch_to.parent_frame()
    driver.switch_to.frame("mainFrame")
    time.sleep(twait)

    # Reboot
    driver.find_element_by_xpath('//*[@id = "reboot"]').click()

    driver.switch_to.alert.accept()
    print("     rebooted ...")


def restartTPLink_02():
    global driver
    driver.get("http://192.168.0.2/")

    print("192.168.0.2 loaded")

    # credentials
    WebDriverWait(driver, 20).until(
        EC.element_to_be_clickable((By.XPATH, '//*[@id="userName"]'))
    ).send_keys(CredentialsDict.get("UsernameTP-Link"))

    WebDriverWait(driver, 20).until(
        EC.element_to_be_clickable((By.XPATH, '//*[@id = "pcPassword"]'))
    ).send_keys(CredentialsDict.get("PasswordTP-Link"))

    # login
    WebDriverWait(driver, 20).until(
        EC.element_to_be_clickable((By.XPATH, '//*[@id="loginBtn"]'))
    ).click()

    print("     logged in")

    # Change to Menu
    driver.switch_to.frame("bottomLeftFrame")
    time.sleep(twait)

    # Find System Tools
    WebDriverWait(driver, 20).until(
        EC.element_to_be_clickable((By.LINK_TEXT, "System Tools"))
    ).click()
    print("     switched to Menu")

    # Find System Tools
    WebDriverWait(driver, 20).until(
        EC.element_to_be_clickable((By.PARTIAL_LINK_TEXT, "Reboot"))
    ).click()

    print("     switched to Reboot Menu")

    # Change to Main
    driver.switch_to.parent_frame()
    driver.switch_to.frame("mainFrame")
    time.sleep(twait)

    # Reboot
    driver.find_element_by_id("button_reboot").click()

    driver.switch_to.alert.accept()
    print("     rebooted ...")


def restartGenexis_01():
    global driver
    driver.get("http://192.168.0.1/")

    print("192.168.0.1 loaded")

    # Credentials
    WebDriverWait(driver, 20).until(
        EC.element_to_be_clickable(
            (By.ID, "login-username"))
    ).send_keys(CredentialsDict.get("UsernameGenexis"))

    WebDriverWait(driver, 20).until(
        EC.element_to_be_clickable(
            (By.ID, "login-password"))
    ).send_keys(CredentialsDict.get("PasswordGenexis"))

    WebDriverWait(driver, 20).until(
        EC.element_to_be_clickable(
            (By.XPATH, '/html/body/main/gen-login/form/button/span'))
    ).click()

    print("     logged in")

    time.sleep(twait*4)

    WebDriverWait(driver, 20).until(
        EC.element_to_be_clickable(
            (By.XPATH, '/html/body/header/nav[1]/a'))
    ).click()

    print("     switched to Menu")
    WebDriverWait(driver, 20).until(
        EC.element_to_be_clickable(
            (By.XPATH, '//*[@id="section-reboot"]/div[1]/div[1]/div[1]/button/span'))
    ).click()

    print("     switched to Reboot Menu")

    WebDriverWait(driver, 20).until(
        EC.element_to_be_clickable(
            (By.XPATH, '/html/body/div/div/div[1]/input'))
    ).send_keys(CredentialsDict.get("PasswordGenexis"))

    WebDriverWait(driver, 20).until(
        EC.element_to_be_clickable(
            (By.XPATH, '/html/body/div/div/div[2]/button[1]'))
    ).click()

    print("     rebooted ...")


# Network Layout
networkLayout = """
Network Layout:

          0.1
           +
           |
           v
 +-------+0.2+------+---------+
 |                  |         |
 v                  v         v
0.4                0.3        PC
 +                  +
 |                  |
 |                  |
 v                  v
0.11               0.10
"""

# Restart all Routers

print(networkLayout+"\n")

restartTPLink_10()
restartTPLink_11()

restartTPLink_03()
restartTPLink_04()

restartGenexis_01()
restartTPLink_02()


print("\nAll Routers Restarted")

driver.quit()
