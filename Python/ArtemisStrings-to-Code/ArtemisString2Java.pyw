import re
import pyperclip as pc


input = pc.paste()

clean = input.replace("⎵", " ")


variableParts = re.findall('<(.+?)>', clean)
stringparts = re.split('<(.+?)>', clean)

formattedList = []

for sp in stringparts:
    for var in variableParts:
        variablePart = ""+var
        sp = sp.replace(
            var, "⎵ + " + variablePart.title().replace(" ", "") + "  + ")
    formattedList.append(sp)


out = ""

for formatted in formattedList:
    if(len(formatted) > 0 and formatted[0] == "⎵"):
        out += formatted.replace("⎵", "")
    else:
        if(len(formatted) > 0 and formatted[0] != '"'):
            out += '"'+formatted+'"'


def copy2clip(txt):
    print(txt)
    if(txt):
        pc.copy(txt)
    else:
        print(pc.paste())


copy2clip(out)
