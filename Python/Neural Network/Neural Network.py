import math
import random

import numpy as np
import pygame


################################
class Layer:
    def __init__(self, upperNetwork, i):
        self.NN = upperNetwork
        self.index = i
        self.weights = np.random.randn(
            upperNetwork.NetworkLayout[i - 1], upperNetwork.NetworkLayout[i])
        self.bias = np.zeros(upperNetwork.NetworkLayout[i])

    def forward(self, inputs, func):
        out = np.dot(inputs, self.weights) + self.bias
        self.z = out
        self.a = func(out)

    def backwardsLastLayer(self, desired):
        Nabla_aC = np.subtract(self.a, desired)
        # Nabla_aC = [(self.a[i] - desired[i]) / (self.a[i] - self.a[i] * self.a[i]) for i in range(len(desired))]
        sigmaPrime = sigmoidPrime(self.z)

        self.deltaL = np.multiply(Nabla_aC, sigmaPrime)

    def backwards(self):
        print()
        error = np.transpose(np.dot(
            NN.Layers[self.index + 1].weights, np.transpose(NN.Layers[self.index + 1].deltaL)))
        sigmaPrime = sigmoidPrime(self.z)
        self.deltaL = np.multiply(error, sigmaPrime)


def sigmoid(x):
    return 1 / (1 + np.exp(-x))


def sigmoidPrime(x):
    return sigmoid(x) * (1 - sigmoid(x))


################################
class Network:
    Layers = []

    def __init__(self, **kwargs):
        self.NetworkLayout = kwargs.get("NetworkLayout")
        self.nonLinearity = kwargs.get("nonLinearity")
        self.initialize()
        self.learningRate = 0.1

    # Initialize Network
    def initialize(self):
        for k in range(len(self.NetworkLayout)):
            self.Layers.append(Layer(self, k))

    # feedForward
    def feedForward(self, input):
        self.Layers[0].a = input
        for k in range(1, len(self.NetworkLayout)):
            self.Layers[k].forward(self.Layers[k - 1].a, self.nonLinearity)

        return self.Layers[-1].a

    def backwards(self, desired):
        self.Layers[-1].backwardsLastLayer(desired)
        for k in range(len(self.NetworkLayout) - 2, 0, -1):
            self.Layers[k].backwards()

    def adjust(self):
        batchSize = len(self.Layers[0].a)
        for l in range(1, len(self.Layers)):
            for j in range(0, self.NetworkLayout[l]):
                for k in range(0, self.NetworkLayout[l - 1]):
                    delC_w = 0
                    for batch in range(batchSize):
                        delC_w += self.Layers[l - 1].a[batch][k] * \
                            self.Layers[l].deltaL[batch][j]
                        self.Layers[l].weights[k][j] -= delC_w * \
                            self.learningRate

            delC_b = 0
            for batch in range(batchSize):
                delC_b += self.Layers[l].deltaL[batch][j]
            self.Layers[l].bias[j] -= delC_b * self.learningRate

    #####
    def train(self, input, desired):
        self.feedForward(input)
        self.backwards(desired)
        self.adjust()

    def predict(self, input):
        return self.feedForward(input)


################################

n = 300

pygame.init()
display = pygame.display.set_mode((n, n), pygame.RESIZABLE)


def gray(im):
    w, h = im.shape
    ret = np.empty((w, h, 3), dtype=np.uint8)
    ret[:, :, 2] = ret[:, :, 1] = ret[:, :, 0] = im
    return ret


def plot():
    data = np.empty((n, n))
    for i in range(len(data)):
        for j in range(len(data[i])):
            data[i][j] = NN.predict([i / n, j / n])

    Z = gray(255 * data)
    display.blit(pygame.surfarray.make_surface(Z), (0, 0))
    pygame.display.update()


def createXOR():
    a = round(random.random())
    b = round(random.random())
    return [a, b], [int(bool(a) ^ bool(b))]


def createCIRCLE():
    x = random.random() - 0.5
    y = random.random() - 0.5

    dist = abs(x) + abs(y)
    dist2 = math.sqrt(math.pow(x, 2) + math.pow(y, 2))

    onSquare = 0.3 > dist > 0.25
    onCircle = 0.35 > dist2 > 0.3

    onYCenter = abs(x) < 0.025
    onXCenter = abs(y) < 0.025

    result = int(onSquare or onCircle or onYCenter or onXCenter)

    if abs(x + y) < 0.025:
        result = 1

    if abs(x - y) < 0.025:
        result = 1

    return [[x + 0.5, y + 0.5], [result]]


NN = Network(NetworkLayout=[2, 16, 1], nonLinearity=sigmoid)

index = 0

while True:

    X = []
    Y = []
    for batch in range(4):
        dat = createXOR()
        X.append(dat[0])
        Y.append(dat[1])

    NN.train(X, Y)

    if index % 100 == 0:
        print("Iterations: " + str(index))

        plot()
    index += 1
