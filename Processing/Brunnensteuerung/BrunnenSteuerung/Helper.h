#ifndef HELPER_H
#define HELPER_H

class Flanke {
  public:
    bool nowP;
    bool nowN;
    
    bool fPos(bool in) {
      bool prev = nowP;
      nowP = in;
      return !prev && nowP;
    }
    
    bool fNeg(bool in) {
      bool prev = nowN;
      nowN = in;
      return prev && !nowN;
    }
};

struct Color {
  int r, g, b;
};


struct Error {
  String type;
  String text;
};

float mapf(float x, float in_min, float in_max, float out_min, float out_max) {
  return (x - in_min) * (out_max - out_min) / (in_max - in_min) + out_min;
}

#endif
