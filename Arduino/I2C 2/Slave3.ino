//Slave 3
#include <Wire.h>

const int ledPin = 5;
int ledBrightness;

void setup()
{
    Wire.begin(3);
    Wire.onReceive(evalI2C);
    pinMode(5, OUTPUT);
}

void loop()
{
    analogWrite(ledPin, ledBrightness);
}

void evalI2C(int len)
{
    while (Wire.available())
    {
        byte b = Wire.read();
        char chr = char(b);

        switch (chr)
        {
        case 'A':
            byte val = Wire.read();
            ledBrightness = val;
            break;
        }
    }
}