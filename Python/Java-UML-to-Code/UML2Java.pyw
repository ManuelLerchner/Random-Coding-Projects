
import pyperclip as pc


input = pc.paste()

outbuffer = []
out = []

for line in input.split('\n'):
    if not line:
        continue

    line = line.replace('\r', "\n")

    # public
    modifier = "private" if line[0] == '-' else "public"
    brackets = "(" in line

    amountColon = line[1:].count(':')

    if(amountColon == 1):
        splitted = line[1:].replace(" ", "").split(':')

        if(len(splitted) == 2 and not "(" in splitted[0]):
            out.append(modifier+" " + splitted[1][0:-1]+" "+splitted[0]+";")
        else:
            out.append(modifier+" "+splitted[1][0:-1]+" " +
                       splitted[0]+" {\n\n}" if brackets else ""+";")

    elif(amountColon == 2):
        splitted = line[1:].replace(" ", "").split(':')
        locationbrace = splitted[0].find("(")

        out.append(modifier+" "+splitted[0][0:locationbrace+1] +
                   splitted[1][0:-1] + " " + splitted[0][locationbrace+1:]+")"+" {\n\n}" if brackets else "")

    else:
        outbuffer.append(line)


def copy2clip(txt):
    print(txt)
    if(txt):
        pc.copy(txt)
    else:
        print(pc.paste())


copy2clip("\n".join(out))
