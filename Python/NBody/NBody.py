import numpy as np

import matplotlib.pyplot as plt
from mpl_toolkits.mplot3d import Axes3D
import matplotlib.animation as animation
import mpl_toolkits.mplot3d.axes3d as p3


G = 1
deltaT = 1E-2

# Plot

fig = plt.figure()
ax = p3.Axes3D(fig)


class Planet:

    def __init__(self, pos, vel, mass):
        self.pos = np.array(pos)
        self.vel = np.array(vel)
        self.mass = mass
        self.Laufbahn = [[], [], []]

    def update(self):
        deltaV = self.calcVel()
        self.vel = np.subtract(self.vel, deltaV)

        self.pos = np.add(self.pos, np.multiply(self.vel, deltaT))

        for index in range(0, 3):
            self.Laufbahn[index].append(self.pos[index])

    def calcVel(self):
        sum = [0, 0, 0]
        for plnt in Planets:
            if plnt is not self:
                dist = np.subtract(self.pos, plnt.pos)
                mag = np.linalg.norm(dist)

                dir = np.divide(dist, pow(mag, 2)/plnt.mass)
                sum = np.add(sum, dir)

        return np.multiply(sum, G*deltaT)

    def plot(self, ax):
        ax.plot(plnt.Laufbahn[0], plnt.Laufbahn[1],
                plnt.Laufbahn[2])


Planets = []

Planets.append(Planet([0, 1, -3], [-1, 0, 0], 1))
Planets.append(Planet([0, -1, 0], [1, 0, -1], 1))
Planets.append(Planet([-1, -1, 0], [0.5, -1, 1], 1))
Planets.append(Planet([-1, 0, -1], [-0.5, 1, 1], 1))


counter = 0

while True:
    for plnt in Planets:
        plnt.update()

    if counter % 10 == 0:
        ax.cla()
        ax.set_xlim3d(-5, 5)
        ax.set_ylim3d(-5, 5)
        ax.set_zlim3d(-5, 5)

        for plnt in Planets:
            plnt.plot(ax)
        plt.pause(0.01)

    counter += 1


plt.show()
