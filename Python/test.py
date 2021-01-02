import re

list = []
with open("Data/input.txt", "r") as f:
    list = f.read().splitlines()

count = 0

for txt in list:
    range = re.findall("[0-9]*-[0-9]*", txt)

    x = range[0]
    Split = x.split("-")

    low = int(Split[0])
    high = int(Split[1])

    letter = str(re.findall(" [a-z]:", txt))[3]
    password = str(re.findall("[a-z][a-z]+", txt))

    if (password[low+0] == letter) ^ (password[high+0] == letter):
        count += 1

print(count)
