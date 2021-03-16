import numpy as np
from scipy.integrate import odeint
import matplotlib.pyplot as plt

# function that returns dy/dt


def model(y, t, k):
    dydt =  np.log(y)
    return dydt


# initial condition
y0 = 3

# time points
t = np.linspace(0, 40)

# solve ODEs

k = 0.2
y2 = odeint(model, y0, t, args=(k,))

# plot results

plt.plot(t, y2, 'b--', linewidth=2, label="k={}".format(k))

plt.xlabel('time')
plt.ylabel('y(t)')
plt.legend()
plt.show()
