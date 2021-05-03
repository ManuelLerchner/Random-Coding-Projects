import numpy as np
import matplotlib.pyplot as plt


P = 3*np.pi
x0 = 0

n = 4


def f(x):
    x = np.mod(x+x0, P)+x0

    return np.absolute(np.sin(x))
    # return np.maximum(np.minimum(np.sqrt(x), 2-x), x*x/5)
    # return np.minimum(x, 3-x)


def integrate(func, lower, higher, N=500):
    x = np.linspace(lower, higher, N*2+1)
    y = func(x)
    S = np.sum(4*y[1::2]) + sum(2*y[2:-1:2])+y[0]+y[-1]
    return S*(higher-lower)/(6*N)


def getFourierCoefficient():
    a = []
    b = []
    for i in range(n):
        a.append(2/P*integrate(lambda x: f(x)*np.cos(2*np.pi/P*i*x), x0, x0+P))
        b.append(2/P*integrate(lambda x: f(x)*np.sin(2*np.pi/P*i*x), x0, x0+P))
    return a, b


def getFourierSeries(x, a, b):
    val = a[0]/2
    for i in range(1, n):
        val += a[i]*np.cos(i*2*np.pi/P*x)+b[i]*np.sin(i*2*np.pi/P*x)

    return val


def getFreq(x, a, b):
    val = a[0]/2
    plt.plot(x, np.ones(len(x))*val)
    for i in range(1, n):
        val = a[i]*np.cos(i*2*np.pi/P*x)+b[i]*np.sin(i*2*np.pi/P*x)
        ax3.plot(x, val)


a, b = getFourierCoefficient()
print("a", a)
print("b", b)

# Setup Plot

fig, (ax1, ax2, ax3) = plt.subplots(3, 1, sharex=True)

x = np.arange(x0-2*P, x0+2*P, 0.01)

yIdeal = f(x)
yFourier = getFourierSeries(x, a, b)

getFreq(x, a, b)

# Plot
ax1.plot(x, yIdeal)
ax2.plot(x, yFourier)

plt.axis('equal')
plt.grid()

plt.show()
