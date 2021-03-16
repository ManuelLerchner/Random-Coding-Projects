import matplotlib.pyplot as plt
from matplotlib.image import imread
import numpy as np
from PIL import Image
import timing

imgOriginal = imread('Python/Data/grace-face-1.jpg')

rgb_weights = [0.2989, 0.5870, 0.1140]
img = np.dot(imgOriginal[..., 0:3], rgb_weights)
imgData = np.array(img)
width, height = len(imgOriginal), len(imgOriginal[0])

row = 2
col = 1

Fourier = np.fft.fft2(imgData)

##########################Plot#########################################
plt.subplots_adjust(top=0.85)
figOriginal = plt.figure(1)
plt.imshow(imgOriginal)
plt.suptitle('Original', fontsize=16)

figFourier = plt.figure(2)
plt.imshow(np.log(1 + np.abs(np.fft.fftshift(Fourier))) ** 2)
plt.suptitle('Fourier: log(mag)^2', fontsize=16)

fig = plt.figure(3)
fig.suptitle('Lerrys Image Compression', fontsize=16)

for i in range(0, row * col):
    mask = np.absolute(Fourier) > np.absolute(Fourier).max() * 0.0004 * i * i / (row * col)
    count = (np.count_nonzero(mask) / (width * height))

    tempFourier = np.multiply(Fourier, mask)

    restored = np.fft.ifft2(tempFourier)
    restoredImage = Image.fromarray(np.absolute(restored))

    ax = fig.add_subplot(row, col, 1 + i)
    ax.imshow(restoredImage)
    ax.set_title(str(round(count * 100, 4)) + "%")
    ax.axis('off')

    plt.tight_layout(rect=[0, 0, 1, 0.95])
    plt.draw()
    plt.pause(0.001)

timing.log("Done")
plt.show()
