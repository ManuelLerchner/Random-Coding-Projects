from selenium import webdriver
from time import sleep

PATH = "C:\Program Files (x86)\chromedriver.exe"

driver = webdriver.Chrome(PATH)


driver.get("https://tfo-bruneck.digitalesregister.it/v2/login")
sleep(1.5)


def login(name):
    bar = driver.find_element_by_xpath('//*[@id="inputUserName"]')

    login = driver.find_element_by_xpath(
        '/html/body/div/div[2]/div[3]/form/button')

    bar.clear()

    bar.send_keys(name)

    password = driver.find_element_by_xpath('//*[@id="inputPassword"]')
    password.send_keys("123")

    login.click()
    sleep(0.5)


while True:
    for i in range(5):
        pass

        # login("jesjul")
        # login("epptob")

        # login("kroben")
        # login("wegfel")

        # login("vopale")
        login("grusim")

        # login("nökthe")
        login("fieluk")

        login("siejon")
        login("aueman")

        # login("zingab")
        # login("kirmor")

    sleep(300)
