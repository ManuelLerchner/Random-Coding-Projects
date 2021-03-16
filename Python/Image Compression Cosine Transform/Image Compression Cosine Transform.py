import numpy as np
from scipy import fftpack
from matplotlib.image import imread
import matplotlib.pyplot as plt
from PIL import Image
import timing


imgOriginal = imread('Python/Data/grace-face-1.jpg')
# imgOriginal = imread('Uhd.jpg')

# to Greyscale
rgb_weights = [0.2989, 0.5870, 0.1140]
img = np.dot(imgOriginal[..., 0:3], rgb_weights)
imgData = np.array(img)
width, height = len(imgOriginal), len(imgOriginal[0])

blockSize = 8
quantTableScale = 50

quantTable = [
	[16, 11, 10, 16, 24, 40, 51, 61],
	[12, 12, 14, 19, 26, 58, 60, 55],
	[14, 13, 16, 24, 40, 57, 69, 56],
	[14, 17, 22, 29, 51, 87, 80, 62],
	[18, 22, 37, 56, 68, 109, 103, 77],
	[24, 35, 55, 64, 81, 104, 113, 92],
	[49, 64, 78, 87, 103, 121, 120, 101],
	[72, 92, 95, 98, 112, 100, 103, 99],
]
quantTable = np.multiply(quantTable, quantTableScale)
quantTable = quantTable[0:blockSize, 0:blockSize]

compressedImage = np.zeros((width, height))
compressedData = np.zeros((width, height))

for k in range(0, width, blockSize):
	for j in range(0, height, blockSize):
		if k <= width - blockSize and j <= height - blockSize:
			myList = imgData[k:k + blockSize, j:j + blockSize]

			cosineTran = fftpack.dct(fftpack.dct(myList, axis=0), axis=1)
			quantized = np.round(np.divide(cosineTran, quantTable))

			# ready to send quanized

			dequantized = np.multiply(quantized, quantTable)
			inverseTran = fftpack.idct(fftpack.idct(dequantized, axis=0), axis=1) / (4 * blockSize ** 2)

			compressedData[k:k + blockSize, j:j + blockSize] = np.abs(quantized) * 80
			compressedImage[k:k + blockSize, j:j + blockSize] = inverseTran

# Plot
fig, ax = plt.subplots(nrows=2, ncols=2, sharex='all', sharey='all')
ax[0, 0].imshow(Image.fromarray(imgData))
ax[1, 0].imshow(Image.fromarray(compressedImage))
ax[1, 1].imshow(Image.fromarray(compressedData))
ax[0, 1].axis('off')

print(str(100 * (1 - np.count_nonzero(compressedData) / (width * height))) + "% of the image are Zeros")

timing.log("Done")
plt.show()
