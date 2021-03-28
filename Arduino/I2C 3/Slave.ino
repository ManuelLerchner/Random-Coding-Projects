
#include <Wire.h>

// Slave 1
const int pinRed = 5;
const int pinGreen = 6;
const int pinBlue = 7;

// Normalized
struct RGB {
    int R, G, B;
};

RGB colorRGB;
bool ledState;

long timeTurnOff;
long timeWait;

void setup() {
    pinMode(pinRed, OUTPUT);
    pinMode(pinGreen, OUTPUT);
    pinMode(pinBlue, OUTPUT);

    Wire.begin(1);
    Wire.onReceive(evalI2C);
    Serial.begin(9600);
}

void loop() {
    //WaitTime
    if (timeTurnOff + timeWait >= millis()) {
        analogWrite(pinRed, 0);
        analogWrite(pinGreen, 0);
        analogWrite(pinBlue, 0);
    } else {
        analogWrite(pinRed, colorRGB.R);
        analogWrite(pinGreen, colorRGB.G);
        analogWrite(pinBlue, colorRGB.B);
    }
}

void evalI2C(int byteLen) {
    char action = ' ';
    char color = ' ';
    String timeWertString = "";
    String brightnessString = "";
    int count = 0;
    while (Wire.available()) {
        char chr = Wire.read();

        if (count == 0) {
            action = chr;
        }

        if (action == 'O') {
            if (count == 1) {
                color = chr;
            }
            if (count >= 2) {
                brightnessString += chr;
            }
        }

        if (action == 'X') {
            if (count >= 1) {
                timeWertString += chr;
            }
        }

        count++;
    }

    int brightness = 255;
    int turnOffTime = 0;
    if (action == 'O') {
        ledState = true;

        // Parse brighntess
        if (count > 2) {
            brightness = brightnessString.toInt();
        }
    }

    if (action == 'X') {
        ledState = false;
        // Parse brighntess
        if (count > 1) {
            turnOffTime = timeWertString.toInt();
            timeTurnOff = millis();
            timeWait = turnOffTime * 100;
            return;
        }
    }

    // Set color
    if (color == 'R') colorRGB = {1, 0, 0};
    if (color == 'G') colorRGB = {0, 1, 0};
    if (color == 'B') colorRGB = {0, 0, 1};
    if (color == 'Y') colorRGB = {1, 1, 0};
    if (color == 'C') colorRGB = {0, 1, 1};

    // Set brighness
    colorRGB.R *= brightness * ledState;
    colorRGB.G *= brightness * ledState;
    colorRGB.B *= brightness * ledState;

    Serial.println(action);
    Serial.println(color);
    Serial.println(brightness);
    Serial.println(turnOffTime);
}