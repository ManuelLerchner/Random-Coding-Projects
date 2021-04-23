#include <iostream>
#include <string>

#include "Helper.hpp"
#include "Network.hpp"
#include "Neuron.hpp"

using namespace std;

// Parameters//
int dims[] = {2, 4, 4, 1};
int numTrainSamples = 10;
int numTestCases = 100;

int main() {
    // Topology
    vector<int> topology;
    topology.assign(begin(dims), end(dims));

    // Init NN
    Network NN = Network(topology);

    // Make Data
    Data DataList[4];
    makeData(DataList);

    // Train
    Data D;
    vector<double> result;
    for (int i = 0; i < numTrainSamples; i++) {
        int r = rand() % 4;
        D = DataList[r];
        result = NN.train(D);
    }

    // Test
    int correct = 0;
    for (int i = 0; i < numTestCases; i++) {
        int r = rand() % 4;
        Data D = DataList[r];
        bool currRes = NN.test(D);
        correct += currRes;

        string resString = (currRes == true) ? "True" : "False";

        // Print
        cout << "Test: " << i << endl;
        cout << endl << "Input: [" << D.in[0] << "," << D.in[1] << "]" << endl;
        cout << "Expected: [" << D.expected[0] << "]" << endl;
        cout << "Out: [" << result[0] << "]" << endl;
        cout << "Correct: " << resString << endl << endl;
    }

    // Print Percentage
    cout << endl
         << "Conclusion:" << endl
         << "-------------------------" << endl
         << "TrainSamples: " << numTrainSamples << endl
         << "TestCases: " << numTestCases << endl
         << "Average Accuracy: " << 100 * correct / numTestCases << "%" << endl
         << "-------------------------";

    return 0;
}
