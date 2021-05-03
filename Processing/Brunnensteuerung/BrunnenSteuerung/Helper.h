#ifndef HELPER_H
#define HELPER_H

class Flanke {
  public:
    bool now;
    bool fPos(bool in) {
      bool prev = now;
      now = in;
      return !prev && now;
    }
};

struct color {
  int r, g, b;
};


struct Error {
  String type;
  String text;
};

#endif
