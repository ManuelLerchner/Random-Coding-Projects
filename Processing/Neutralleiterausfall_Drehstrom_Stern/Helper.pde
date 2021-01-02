class Complex {
  float re, im;
  Complex(String s, float x1, float x2) {
    if (s.equals("cartesian")) {
      this.re=x1;
      this.im=x2;
    } else if (s.equals("polar")) {
      x2=radians(x2);
      this.re=x1*cos(x2);
      this.im=x1*sin(x2);
    }
  }

  float mag() {
    return sqrt(re*re+im*im);
  }

  float phase() {
    return atan2(im, re);
  }

  String polar() {
    return str(mag())+" < "+str(degrees(phase()))+"°";
  }

  void add(Complex Z2) {
    this.re+=Z2.re;
    this.im+=Z2.im;
  }
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////
Complex divide(Complex Z1, Complex Z2) {
  float a=Z1.re;
  float b=Z1.im;
  float c=Z2.re;
  float d=Z2.im;

  float re= a*c+b*d;
  float im= b*c-a*d;
  float s= c*c+d*d;

  return new Complex("cartesian", re/s, im/s);
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////
Complex scale(Complex Z1, float v) {
  float re= Z1.re*v;
  float im= Z1.im*v;
  return new Complex("cartesian", re, im);
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////
Complex sub(Complex Z1, Complex Z2) {
  Complex temp=new Complex("cartesian", 0, 0);
  temp.add(Z1);
  temp.add( scale(Z2, -1));
  return temp;
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////
class Arrow {
  Complex val;

  PVector internalOffset=new PVector();
  color c;
  float internalScale=1, strokeFactor=0.8, side=1;
  String text;

  Arrow( Complex val, color c, String text) {
    this.val=val;
    this.c=c;
    this.text=text;
  }

  void show() {
    pushMatrix();

    //Location
    translate(globalPanOffset.x, -globalPanOffset.y);
    translate(internalOffset.x, internalOffset.y);

    PVector head= new PVector(val.re*internalScale, val.im*internalScale);

    //polar
    float phi= val.phase();
    float mag= head.mag();

    fill(c);
    stroke(c);

    //Triangle
    pushMatrix();
    translate(head.x, -head.y);
    rotate(-phi+HALF_PI);
    triangle(-mag/12, mag/6, 0, 0, mag/12, mag/6);
    rotate(-PI/2);
    textSize(mag/12);
    text(text, -mag/5, side*(1+mag/10));
    popMatrix();

    head.limit(head.mag()*0.85);

    //Line
    strokeWeight(mag/25*strokeFactor);
    strokeCap(SQUARE);
    line(0, 0, head.x, -head.y);
    strokeWeight(1);

    popMatrix();
  }


  void move(float vx, float vy) {
    internalOffset.add(vx, -vy);
  }
}
