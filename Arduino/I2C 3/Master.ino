
#include <Wire.h>

// Master

int slave = 0;

struct Setting {
    String setting;
};

Setting list[] = {{"OM"}, {"OY126"}, {"X"}};

void setup() {
    Wire.begin();
    Serial.begin(9600);

    // delay(200);
    // transmit(2, "OY");

    // delay(400);
    // transmit(2, "X10");
}

void loop() {
    if (Serial.available()) {
        int slaveReq = Serial.parseInt();
        slave = slaveReq;

        String action = list[0].setting;
        // transmit(slave,action);

        transmit(slave, "OY");
    }
}

void transmit(int adress, char string[]) {
    Serial.println(adress);
    Serial.println(string);
    Wire.beginTransmission(adress);

    Wire.write(string);
    Wire.endTransmission();
}