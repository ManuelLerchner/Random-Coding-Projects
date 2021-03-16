//Slave 2
#include <Wire.h>

const int R = 3;
const int G = 5;
const int B = 6;

struct colRGB
{
    int R;
    int G;
    int B;
};

colRGB color = {255, 100, 255};

void setup()
{
    Wire.begin(2);
    Wire.onReceive(evalI2C);
    pinMode(R, OUTPUT);
    pinMode(G, OUTPUT);
    pinMode(B, OUTPUT);
}

void loop()
{
    analogWrite(R, color.R);
    analogWrite(G, color.G);
    analogWrite(B, color.B);
}

void evalI2C(int len)
{
    while (Wire.available())
    {
        byte b = Wire.read();
        char chr = char(b);

        switch (chr)
        {
        case 'R':
            color.R = Wire.read();
            color.G = Wire.read();
            color.B = Wire.read();
            break;
        }
    }
}