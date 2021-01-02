from matplotlib.ticker import FuncFormatter, MultipleLocator
import matplotlib.pyplot as plt
from cmath import exp, sin, cos, pi, phase
import numpy as np
import json
import timing

print("\nLoad Json")
with open("Data/train.json", "r") as json_file:
    extracted = json.load(json_file)["drawing"]

##############################################################################################
skip = 5
myList = [complex(extracted[i]["x"], -extracted[i]["y"]) for i in range(0, len(extracted), skip)]
N = len(myList)
print("Found", N, "Points")


##############################################################################################
def fft(L):
    n = len(L)
    if n == 1:
        return L
    else:
        g = fft([L[i] for i in range(0, n, 2)])
        u = fft([L[i] for i in range(1, n, 2)])
        c = [0 for k in range(n)]
        for k in range(0, n // 2):
            root = exp(complex(0, -2 * pi * k / n))
            c[k] = g[k] + u[k] * root
            c[k + n // 2] = g[k] - u[k] * root
        return c


def dft(L):
    w = np.zeros((N, N), dtype=np.complex_)
    for col in range(N):
        for row in range(col + 1):
            root = exp(complex(0, -2 * pi * row * col / N))
            w[row][col] = w[col][row] = root
    return np.dot(w, L)


print("Calculating Fourier Transform")
Fourier = dft(myList)


def fun(x):
    return sum(Fourier[k] * exp(complex(0, k * x)) for k in range(N)) / len(Fourier)


##########################################################################################
##########################################################################################
##########################################################################################
print("Extracting Values")
x = np.arange(0, 2 * pi * (1 + 1 / N), step=(2 * pi / N))
val = np.array(list(map(fun, x)))
fReal, fIm = val.real, val.imag

#############################################
print("Start Plot")
# Path
plt.figure(1)
plt.plot(fReal, fIm, color="m")
plt.axhline(y=0, color='k', linewidth=0.5)
plt.axvline(x=0, color='k', linewidth=0.5)
plt.axis('equal')

#############################################
#############################################
# Spektrogram
plt.figure(2)
plt.subplot(2, 1, 1)
xpos = np.array(range(len(Fourier))) - len(Fourier) / 2
mag = [abs(2 * Fourier[k]) for k in range(len(xpos))]
plt.bar(xpos, np.fft.fftshift(mag), align="edge", color="g")

plt.axhline(y=0, color='k', linewidth=0.5)
plt.axvline(x=N / 2, color='k', linewidth=0.5)
plt.axvline(x=-N / 2, color='k', linewidth=0.5)
plt.xlabel('Freq')
plt.ylabel('Mag')

#############################################
# Graphs
plt.subplot(2, 1, 2)
plt.plot(x, fReal, "b", label='re[F]')
plt.plot(x, fIm, "r", label='im[F]')

ax = plt.gca()
ax.xaxis.set_major_formatter(FuncFormatter(
    lambda val, pos: '{:.0g}$\pi$'.format(val / np.pi) if val != 0 else '0'
))
ax.xaxis.set_major_locator(MultipleLocator(base=np.pi))

plt.grid(True, which='both')
plt.axhline(y=0, color='k')
plt.axvline(x=2 * pi, color='k')
plt.axvline(x=0, color='k')
plt.xlabel('Samples')
plt.ylabel('Amp')
plt.legend()

#############################################
#############################################
timing.log("Done")
plt.show()
