#include <Wire.h>

void setup() {
    Wire.begin();

    Serial.begin(9600);
}

void loop() {
    digitalWrite(2, 2);
    digitalWrite(2, 2);

    Serial.println("2");
}