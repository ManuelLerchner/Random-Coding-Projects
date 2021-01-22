

#include <iostream>
using namespace std;

void MaxorMin(int f, int g, int *a, int *b) {
    int n = 5;

    cout << n << endl;

    *a = n;
    *b = 2 * n;
}

int main() {
    int a;
    int b;
    MaxorMin(1, 2, &a, &b);

    cout << a << endl;
    cout << b << endl;
}