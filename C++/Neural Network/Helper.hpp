#ifndef Helper_H
#define Helper_H

#include "Network.hpp"

void makeData(Data DataList[4]) {
    int counter = 0;
    for (int a = 0; a <= 1; a++) {
        for (int b = 0; b <= 1; b++) {
            vector<double> in;
            in.push_back(a);
            in.push_back(b);

            vector<double> res;
            res.push_back(int(a ^ b));

            Data D;
            D.in = in;
            D.expected = res;
            DataList[counter] = D;
            counter++;
        }
    }
}

#endif