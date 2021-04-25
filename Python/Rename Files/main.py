import os

dir = "data"

for filename in os.listdir(dir):
    if filename.endswith(".mp3"):
        try:
            preparedName = filename.replace(".", " ")
            splitted = preparedName.split(" ")
            filtered = splitted[3:-1]
            splitIndex = filtered.index("")

            artist = " ".join(filtered[0:splitIndex])
            songname = " ".join(filtered[splitIndex+1:])

            newFileName = artist + " - " + songname+".mp3"

            print(filename, "---->", newFileName)

            os.rename(f"{dir}\{filename}",
                      f"{dir}\{newFileName}")
        except:
            print(filename, "failed")
