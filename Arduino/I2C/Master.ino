//Master

#include <Wire.h>

const short Start_S12 = 4;
const short Stop_S12 = 3;
const short Toggle_S3 = 2;

class Flanke {
   public:
    bool now;
    bool fPos(bool in) {
        bool prev = now;
        now = in;
        return in && !prev;
    }
};

Flanke F1, F2, F3;

void setup() {
    Wire.begin();
    Serial.begin(9600);
    pinMode(2, INPUT);
    pinMode(3, INPUT);
    pinMode(4, INPUT);
}

void loop() {
    bool Flanke1 = F1.fPos(digitalRead(Start_S12));
    bool Flanke2 = F2.fPos(digitalRead(Stop_S12));
    bool Flanke3 = F3.fPos(digitalRead(Toggle_S3));

    /*   
    T: Toggle
    S: Start
    X: Stop
    */

    if (Flanke1) {
        Serial.println('S');
        transmit('S', 1);
        transmit('S', 2);
    }

    if (Flanke2) {
        Serial.println('X');
        transmit('X', 1);
        transmit('X', 2);
    }

    if (Flanke3) {
        Serial.println('T');
        transmit('T', 3);
    }
}

void transmit(char action, int I2CAdress) {
    Wire.beginTransmission(I2CAdress);
    Wire.write(action);
    Wire.endTransmission();
}
