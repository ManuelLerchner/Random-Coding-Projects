import matplotlib.pyplot as plt
from multiprocessing import Pool, cpu_count
import numpy as np

import time
import datetime
import Color
from PIL import Image


# Image
WIDTH = 480
ASPECTRATIO = 4/3
HEIGHT = round(WIDTH/ASPECTRATIO)


def render(canvas):
    plt.imshow(canvas.reshape((HEIGHT, WIDTH, 3)))
    plt.gca().invert_yaxis()


def calcImage():
    pixel = np.array([(x/WIDTH, y/HEIGHT) for y in range(HEIGHT)
                      for x in range(WIDTH)])

    canvas = np.zeros((WIDTH*HEIGHT, 3))
    counter = 0

    # Render
    with Pool(processes=cpu_count()) as pool:
        print("---Started Calculations---  ", datetime.datetime.now())
        for i, col in enumerate(pool.imap(Color.getColor, pixel)):
            canvas[i] = col

            if i % WIDTH == 0:
                plt.cla()
                render(canvas)
                plt.pause(0.00001)
                counter += 1
                print(counter/HEIGHT*100, r"% completed")

        render(canvas)
        print("\n---Finished Calculations---  ", datetime.datetime.now())

        return canvas.reshape((HEIGHT, WIDTH, 3))


if __name__ == "__main__":
    tstart = time.time()

    canvas = calcImage()

    timeTaken = round(1000*(time.time()-tstart))/1000

    print("Took", timeTaken, "s to render the", (WIDTH, HEIGHT), "image")

    plt.title(f"{(WIDTH, HEIGHT)}px,   took {timeTaken}s")
    plt.xlabel(Color.Objects.World, horizontalalignment='left', x=0)
    plt.suptitle("Raytracing")

    im = Image.fromarray((canvas * 255).astype(np.uint8))
    im = im.transpose(Image.FLIP_TOP_BOTTOM)

    # im.save("Image5_480.png")

    plt.show()
