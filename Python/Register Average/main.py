from selenium import webdriver
from time import sleep

PATH = "C:\Program Files (x86)\chromedriver.exe"

driver = webdriver.Chrome(PATH)


driver.get("https://tfo-bruneck.digitalesregister.it/v2/login")
sleep(1.5)


def login():
    bar = driver.find_element_by_xpath('//*[@id="inputUserName"]')

    login = driver.find_element_by_xpath(
        '/html/body/div/div[2]/div[3]/form/button')

    bar.clear()

    bar.send_keys("lerman")

    password = driver.find_element_by_xpath('//*[@id="inputPassword"]')
    password.send_keys("321Register#")

    login.click()
    sleep(1.5)


def changeToBewertungen():

    driver.find_element_by_xpath('/html/body/div[1]/a').click()
    driver.find_element_by_xpath('/html/body/div[2]/a[7]').click()
    sleep(0.5)


login()
changeToBewertungen()

grades = driver.find_elements_by_class_name('grade with-tooltip ng-binding')

print(grades)

sleep(100)
