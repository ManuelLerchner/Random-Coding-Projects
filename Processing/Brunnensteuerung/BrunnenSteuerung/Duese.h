#include "Helper.h"

class Duese {
  public:
    boolean ventilState;

    color RGBCol = {0, 0, 0};

    int pinR;
    int pinG;
    int pinB;
    int pinVentil;

    Duese(int PWMPins[], int pinVentil) {
      pinR = PWMPins[0];
      pinG = PWMPins[1];
      pinB = PWMPins[2];
      this->pinVentil = pinVentil;
    }


    void show() {
      RGBCol = ventilState ? RGBCol : color{0, 0, 0};

      showRGB(pinR, pinG, pinB, RGBCol);
      digitalWrite(pinVentil,ventilState);
    }

    void showRGB(int pR, int pG, int pB, color col) {
      analogWrite(pR, col.r);
      analogWrite(pG, col.g);
      analogWrite(pB, col.b);
    }

};
