#ifndef Network_H
#define Network_H

#include <cassert>
#include <iostream>
#include <vector>

#include "Neuron.hpp"

class Neuron;
typedef vector<Neuron> Layer;

struct Data {
    vector<double> in;
    vector<double> expected;
};

////////////
// Network//
////////////
class Network {
   public:
    Network(const vector<int> &topology);
    void feedForward(const vector<double> &inputVals);
    void backProp(const vector<double> &target);
    void getResults(vector<double> &result) const;
    vector<double> train(Data D);
    bool test(Data D);
    vector<Layer> m_layer;

   private:
    double m_error;
    double m_recentError = 1;
    double m_recentErrorSmoothingFactor = 0.5;
};

// Network:: Constructor
Network::Network(const vector<int> &topology) {
    int numLayers = topology.size();
    for (int l = 0; l < numLayers; l++) {
        m_layer.push_back(Layer());

        int numNeuron = topology[l];
        int numOutputs = l == numLayers - 1 ? 0 : topology[l + 1];
        for (int n = 0; n <= numNeuron; n++) {
            m_layer.back().push_back(Neuron(numOutputs, n));
        }

        m_layer.back().back().setOutputVal(1.0);
    }
}

// Network:: feedForward
void Network::feedForward(const vector<double> &inputVals) {
    assert(inputVals.size() == m_layer[0].size() - 1);

    // Set first layer
    for (int i = 0; i < inputVals.size(); i++) {
        m_layer[0][i].setOutputVal(inputVals[i]);
    }

    // forward
    for (int i = 1; i < m_layer.size(); i++) {
        Layer &prevLayer = m_layer[i - 1];
        for (int n = 0; n < m_layer[i].size() - 1; n++) {
            m_layer[i][n].feedForward(prevLayer);
        }
    };
}

// Network:: backProp
void Network::backProp(const vector<double> &target) {
    // calc error
    Layer &outputLayer = m_layer.back();
    m_error = 0.0;

    for (int i = 0; i < outputLayer.size() - 1; i++) {
        double delta = target[i] - outputLayer[i].getOutputVal();
        m_error += delta * delta;
    }
    m_error /= outputLayer.size() - 1;
    m_error = sqrt(m_error);

    // measure Error
    m_recentError = (m_recentError * m_recentErrorSmoothingFactor + m_error) /
                    (m_recentErrorSmoothingFactor + 1);

    cout << "Recent Error: " << m_recentError << endl;

    // calc output gradient
    for (int i = 0; i < outputLayer.size() - 1; i++) {
        outputLayer[i].calcOutputGradients(target[i]);
    }

    // calc layer gradient
    for (int l = m_layer.size() - 2; l > 0; l--) {
        Layer &hiddenLayer = m_layer[l];
        Layer &nextLayer = m_layer[l + 1];
        for (int i = 0; i < hiddenLayer.size() - 1; i++) {
            hiddenLayer[i].calcHiddenGradients(nextLayer);
        }
    }

    // update Weights
    for (int l = m_layer.size() - 1; l > 0; l--) {
        Layer &layer = m_layer[l];
        Layer &prevLayer = m_layer[l - 1];
        for (int i = 0; i < layer.size() - 1; i++) {
            layer[i].updateInputWeights(prevLayer);
        }
    };
}

// Network:: getResults
void Network::getResults(vector<double> &result) const {
    result.clear();

    for (int i = 0; i < m_layer.back().size(); i++) {
        result.push_back(m_layer.back()[i].getOutputVal());
    }
};

// Network:: train
vector<double> Network::train(Data D) {
    // forward
    feedForward(D.in);
    // backward
    backProp(D.expected);

    // results
    vector<double> result;
    getResults(result);
    return result;
}

// Network:: test
bool Network::test(Data D) {
    // forward
    feedForward(D.in);
    // backward
    vector<double> result;
    getResults(result);

    // evaluate correctness
    return round(result[0]) == D.expected[0];
}

#endif