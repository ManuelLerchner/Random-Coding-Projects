from ast import Num

import numpy as np

data = [0, 1]


NN_DIM = [2, 2, 4, 1]


def sigmoid(a):
    return 1/(1+np.exp(-a))


class Layer:
    def __init__(self, i):
        self.i = i
        self.weights = np.random.uniform(-5, 5, (NN_DIM[i], NN_DIM[i-1]))
        #self.weights = np.ones((NN_DIM[i], NN_DIM[i-1]))
        self.bias = np.ones(NN_DIM[i])

    def forward(self, vec):
        out = np.matmul(self.weights, vec)
        out = np.add(out, self.bias)
        out = sigmoid(out)
        return out

    def backwards():
        pass


class Network:

    def __init__(self, NN_DIM):
        self.Layers = []

        for i in range(1, len(NN_DIM)):
            L = Layer(i)
            self.Layers.append(L)

    def forward(self, vec):
        data = vec

        for L in self.Layers:
            data = L.forward(data)

        return data

    def backwards():
        pass


NN = Network(NN_DIM)

res = NN.forward(data)


print(res)
