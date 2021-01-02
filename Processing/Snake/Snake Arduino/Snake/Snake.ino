#include "LedControl.h"

int x = 16;
int y = 4;

int ax;
int ay;

int device;
int row ;
int col;
int val;
int prevx, prevy;

int tailx[32 * 8];
int taily[32 * 8];

//Datin = 11
//Clock = 13
//Load  = 10


LedControl lc = LedControl(11, 13, 10, 4);


void setup() {

  for (int i = 0; i < lc.getDeviceCount(); i++) {
    lc.shutdown(i, false);
    lc.setIntensity(i, 0.1);
    lc.clearDisplay(i);
  }
  Serial.begin(9600);

  createapple();

}

void loop() {

  //Snake Head
  ConvertPos(prevx , prevy);
  lc.setLed(device, row, col, false);
  ConvertPos(x , y);
  lc.setLed(device, row, col, true);
  prevx = x;
  prevy = y;


  //Apple
  GetProcessing();
  ConvertPos(ax , ay);
  lc.setLed(device, row, col, true);


  //Eat
  if (x == ax && y == ay) {
    createapple();
  }





  



  delay(200);

}



//Get Absolute PosValues
void ConvertPos(int x, int y) {
  int device1;
  device1 =  1 + floor((x - 1) / 8);
  row = y - 1;
  col = (x - 1) - (device1 - 1) * 8;
  device =  4 - device1;
}


void GetProcessing() {
  if (Serial.available()) {
    String UniformSyntax = Serial.readStringUntil('\n');
    if (UniformSyntax.length() == 3  && UniformSyntax.charAt(0) == 'S' && UniformSyntax.charAt(2) == 'E') {
      val = (UniformSyntax.substring(1, 2)).toInt();
    }
  }

  if (val == 1) {
    y--;
  } else if (val == 2) {
    x--;
  } else if (val == 3) {
    y++;
  } else if (val == 4) {
    x++;
  }

  if (x > 32) {
    x = 1;
  }
  if (x < 1) {
    x = 32;
  }
  if (y > 8) {
    y = 1;
  }
  if (y < 1) {
    y = 8;
  }
}


void createapple() {
  ax = floor(random(1, 32));
  ay = floor(random(1, 9));
}
