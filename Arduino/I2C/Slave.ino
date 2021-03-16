//Slave 1
#include <Wire.h>

const int ledPin = 5;
bool ledStatus;

void setup() {
    Wire.begin(1);
    Wire.onReceive(evalI2C);
    pinMode(5, OUTPUT);
}

void loop() {
    digitalWrite(ledPin, ledStatus);
}

void evalI2C(int len) {
    while (Wire.available()) {
        byte byte = Wire.read();
        char chr = char(byte);

        switch (chr) {
            case 'S':
                ledStatus = true;
                break;

            case 'X':
                ledStatus = false;
                break;

            case 'T':
                ledStatus ^= true;
                break;
        }
    }
}