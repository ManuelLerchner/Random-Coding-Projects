#ifndef Neuron_H
#define Neuron_H

#include <cmath>
#include <cstdlib>
#include <iostream>
#include <vector>

using namespace std;

class Neuron;
typedef vector<Neuron> Layer;

struct Connection {
    double weight;
    double deltaWeight;
};

// Neuron
class Neuron {
   public:
    Neuron(int numOutputs, int myIndex);
    void feedForward(const Layer &prevLayer);
    void setOutputVal(double val) { m_output = val; }
    double getOutputVal() const { return m_output; }

    void calcOutputGradients(double target);
    void calcHiddenGradients(const Layer &nextLayer);
    void updateInputWeights(Layer &prevLayer);

   private:
    double m_output;
    double m_gradient;
    int m_myIndex;
    static double eta;
    static double alpha;

    vector<Connection> m_outputWeights;
    static double randomWeight() { return (2 * rand() / double(RAND_MAX)) - 1; }
    double sumDOW(const Layer &nextLayer);
    static double transferFunction(double v);
    static double transferFunctionPrime(double v);
};

// LearningRate
double Neuron::eta = 0.2;
double Neuron::alpha = 0.2;

// Neuron:: Transfer Functions
double Neuron::transferFunction(double v) { return tanh(v); }
double Neuron::transferFunctionPrime(double v) {
    return 1 - tanh(v) * tanh(v);
};

// Neuron:: Constructor
Neuron::Neuron(int numOutputs, int myIndex) {
    for (int c = 0; c < numOutputs; c++) {
        m_outputWeights.push_back(Connection());
        m_outputWeights.back().weight = randomWeight();
    }
    m_myIndex = myIndex;
}

// Neuron:: feedForward
void Neuron::feedForward(const Layer &prevLayer) {
    double sum = 0.0;
    for (int i = 0; i < prevLayer.size(); i++) {
        sum += prevLayer[i].getOutputVal() *
               prevLayer[i].m_outputWeights[m_myIndex].weight;
    }
    m_output = Neuron::transferFunction(sum);
}

// Neuron:: sumDOW
double Neuron::sumDOW(const Layer &nextLayer) {
    double sum = 0.0;
    for (int n = 0; n < nextLayer.size() - 1; n++) {
        sum += m_outputWeights[n].weight * nextLayer[n].m_gradient;
    }
    return sum;
}

// Neuron:: calcOutputGradients
void Neuron::calcOutputGradients(double target) {
    double delta = target - m_output;
    m_gradient = delta * Neuron::transferFunctionPrime(m_output);
}

// Neuron:: calcHiddenGradients
void Neuron::calcHiddenGradients(const Layer &nextLayer) {
    double dow = sumDOW(nextLayer);
    m_gradient = dow * Neuron::transferFunctionPrime(m_output);
}

// Neuron:: updateInputWeights
void Neuron::updateInputWeights(Layer &prevLayer) {
    for (int n = 0; n < prevLayer.size(); n++) {
        Neuron &neuron = prevLayer[n];
        double oldDeltaWeight = neuron.m_outputWeights[m_myIndex].deltaWeight;
        double newDeltaWeight =
            eta * neuron.getOutputVal() * m_gradient + alpha * oldDeltaWeight;

        neuron.m_outputWeights[m_myIndex].deltaWeight = newDeltaWeight;
        neuron.m_outputWeights[m_myIndex].weight += newDeltaWeight;
    }
}

#endif