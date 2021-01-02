import nnfs
from nnfs.datasets import vertical_data
import numpy as np

nnfs.init()


class Layer_Dense:
    def __init__(self, inputs, outputs):
        self.weights = 0.02 * np.random.randn(inputs, outputs)
        self.bias = np.zeros((1, outputs))

    def forward(self, inputs):
        self.output = np.dot(inputs, self.weights) + self.bias


class Activation_RelU:
    def forward(self, inputs):
        self.output = np.maximum(inputs, 0)


class Activation_Softmax:
    def forward(self, inputs):
        exp_val = np.exp(inputs - np.max(inputs, axis=1, keepdims=True))
        probabilities = exp_val / np.sum(exp_val, axis=1, keepdims=True)
        self.output = probabilities


class Loss:
    def calculate(self, output, y):
        sample_loss = self.forward(output, y)
        data_loss = np.mean(sample_loss)
        return data_loss


class Loss_CategoricalCrossEntropy(Loss):
    def forward(self, y_pred, y_true):
        samples = len(y_pred)

        y_pred_clipped = np.clip(y_pred, 1e-7, 1 - 1e-7)

        if len(y_true.shape) == 1:
            correct_confidence = y_pred_clipped[range(samples), y_true]

        elif len(y_true.shape) == 2:
            correct_confidence = np.sum(y_pred_clipped * y_true, axis=1)

        negLog = -np.log(correct_confidence)
        return negLog


X, y = vertical_data(100, 3)

L0 = Layer_Dense(2, 3)
A0 = Activation_RelU()

L1 = Layer_Dense(3, 3)
A1 = Activation_Softmax()

LossFunction = Loss_CategoricalCrossEntropy()

####
L0.forward(X)
A0.forward(L0.output)

L1.forward(A0.output)
A1.forward(L1.output)

loss = LossFunction.calculate(A1.output, y)

print(A1.output[:5])
print(loss)
