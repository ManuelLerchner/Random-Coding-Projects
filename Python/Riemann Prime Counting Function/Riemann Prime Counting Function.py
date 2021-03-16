import matplotlib.pyplot as plt
import numpy as np
import scipy.integrate as integrate
from mpmath.libmp.libintmath import moebius
from scipy.special import expi


primes = []

zeros = []

with open('Data/zerosZeta.txt') as inputfile:
	for line in inputfile:
		zeros.append(float(line))

with open('Data/1000Primes.txt') as inputfile:
	for line in inputfile:
		primes.append(int(line))


def primeCountStep(x):
	counter = 0
	while primes[counter] < int(x):
		counter += 1
	return counter


def Ei(x):
	return expi(x)


def Li(x):
	return Ei(np.log(x))


def RiemannF(x, zeroCount):
	zz = [complex(0.5, zeros[i]) for i in range(zeroCount)]
	summ = sum([Ei(z * np.log(x)) + Ei((1 - z) * np.log(x)) for z in zz]).real
	integral = integrate.quad(lambda t: 1.0 / (np.log(t) * (t ** 3 - t)), x, 1000)[0]
	return Li(x) - summ - np.log(2) + integral


def Pi(x):
	global zeroCount
	sup_lim = int(np.log(x) / np.log(2.0)) + 3
	val = 0
	for n in range(1, sup_lim):
		R = RiemannF(x ** (1.0 / n), zeroCount)
		mu = moebius(n) / n
		val += mu * R
	return val


def update():
	global ycont
	ycont = [Pi(x) for x in xcont1]


def onclick(MouseEvent):
	global zeroCount
	zeroCount += 10
	print("Zeros", zeroCount)
	update()


# initialize
rangeX = 500
zeroCount = 0
xcont0 = np.arange(0, rangeX)
xcont1 = np.linspace(2, rangeX, 250)
ystep = [primeCountStep(c) for c in xcont0]
ycont = []

# Plot
fig, ax = plt.subplots()
cid = fig.canvas.mpl_connect('button_press_event', onclick)
update()

while True:
	plt.step(xcont0, ystep)
	plt.plot(xcont1, ycont)
	plt.pause(0.05)
	ax.clear()

plt.show()
