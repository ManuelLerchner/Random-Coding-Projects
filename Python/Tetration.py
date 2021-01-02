import numpy as np
import matplotlib.pylab as plt
from colorsys import hls_to_rgb
import timing

np.seterr(all="ignore")


def colorize(z):
	c = np.zeros((len(z), 3))
	c[np.isinf(z)] = (1.0, 1.0, 1.0)
	c[np.isnan(z)] = (0.5, 0.5, 0.5)

	idx = ~(np.isinf(z) + np.isnan(z))
	A = np.angle(z[idx]) / (2 * np.pi) + 0.5
	A = (A + 0.5) % 1.0
	B = 1.0 - 0.98 / (1 + abs(z[idx]))
	c[idx] = [hls_to_rgb(a, b, 1) for a, b in zip(A, B)]
	return c


N = 1000
axRange = 3
A = np.zeros((N, N), dtype='complex')
axis_x = np.linspace(-axRange, axRange, N)
axis_y = np.linspace(-axRange, axRange, N)
X, Y = np.meshgrid(axis_x, axis_y)
Z = X + Y*1j


def tet(a, n=10):
	val = a
	for _ in range(n):
		val = np.power(a, val)
	return val


for k in range(N):
	A[k] = tet(Z[k])
	if divmod(k, 100)[1] == 0:
		print("Row calculated: ", round(100 * k / N, 2), "%")

timing.log("calculated")

n, m = A.shape
col = np.zeros((n, m, 3))
for k in range(N):
	col[k] = colorize(A[k])
	if divmod(k, 100)[1] == 0:
		print("Row colorized: ", round(100 * k / N, 2), "%")

timing.log("Colorized")

from PIL import Image


img = Image.fromarray((col * 255).astype(np.uint8))
# img.save('MandelBrot.png')
plt.imshow(img, interpolation="bicubic", extent=(-axRange, axRange, -axRange, axRange))
plt.show()
