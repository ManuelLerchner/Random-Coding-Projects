import os

path = "C:/Users\Manuel/Documents/Coding Projects/Python/"


for file in os.listdir(path):

    if os.path.isfile(path+file):
        folderName = file[:-2]
        if not os.path.exists(path+folderName):
            os.mkdir(path+folderName)
            os.rename(path+file, path+"/"+folderName+"/"+file)
