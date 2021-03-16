#include <SPI.h>
#include <Wire.h>

const short S1 = 2;
const short S2 = 3;

const short Slave1 = 10;
const short Slave2 = 9;

class Flanke {
   public:
    bool now;
    bool fPos(bool in) {
        bool prev = now;
        now = in;
        return in && !prev;
    }
};

Flanke F1, F2;

void setup() {
    SPI.begin();
    SPI.setClockDivider(SPI_CLOCK_DIV8);
    digitalWrite(Slave1, 1);
    digitalWrite(Slave2, 1);
}

void loop() {
    bool Flanke1 = F1.fPos(digitalRead(S1));
    bool Flanke2 = F2.fPos(digitalRead(S2));

    if (Flanke1) {
        send(Slave1, readPoti());
    }

    if (Flanke2) {
        send(Slave1, readPoti());
    }
}

int readPoti() {
    return map(analogRead(A0), 0, 1024, 0, 255);
}

void send(int pin, int data) {
    digitalWrite(pin, 0);
    SPI.transfer(data);
    digitalWrite(pin, 1);
}