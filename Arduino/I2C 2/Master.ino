//Master

#include <Wire.h>

const short Start_S12 = 4;
const short Stop_S12 = 3;
const short Toggle_S3 = 2;

const short Poti1 = A0;
const short Poti2 = A1;
const short Poti3 = A2;
const short Poti4 = A3;

class Flanke
{
public:
    bool now;
    bool fPos(bool in)
    {
        bool prev = now;
        now = in;
        return in && !prev;
    }
};

Flanke F1, F2, F3;

void setup()
{
    Wire.begin();
    Serial.begin(9600);
    pinMode(2, INPUT);
    pinMode(3, INPUT);
    pinMode(4, INPUT);
}

void loop()
{
    bool Flanke1 = F1.fPos(digitalRead(Start_S12));
    bool Flanke2 = F2.fPos(digitalRead(Stop_S12));
    bool Flanke3 = F3.fPos(digitalRead(Toggle_S3));

    if (Flanke1)
    {
        Serial.println('R');
        transmitRGB(getAnalog(Poti2), getAnalog(Poti3), getAnalog(Poti4), 1);
    }

    if (Flanke2)
    {
        Serial.println('R');
        transmitRGB(getAnalog(Poti2), getAnalog(Poti3), getAnalog(Poti4), 2);
    }

    if (Flanke3)
    {
        Serial.println('A');
        transmitAnalog(getAnalog(Poti1), 3);
    }
}

void transmitAnalog(byte val, int I2CAdress)
{
    Wire.beginTransmission(I2CAdress);
    Wire.write('A'); //Analog
    Wire.write(val);
    Wire.endTransmission();
}

void transmitRGB(byte R, byte G, byte B, int I2CAdress)
{
    Wire.beginTransmission(I2CAdress);
    Wire.write('R'); //RGB
    Wire.write(R);
    Wire.write(G);
    Wire.write(B);
    Wire.endTransmission();
}

int getAnalog(int num)
{
    return 255 - map(analogRead(num), 0, 1024, 0, 256);
}
