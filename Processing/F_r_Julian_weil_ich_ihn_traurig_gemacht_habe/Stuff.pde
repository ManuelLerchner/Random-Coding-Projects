class Complex {
  float re, im;
  Complex(String s, float re, float im) {
    this.re=re;
    this.im=im;
  }
  Complex(float mag, float phase) {
    phase=radians(phase);
    this.re=mag*cos(phase);
    this.im=mag*sin(phase);
  }

  float mag() {
    return sqrt(re*re+im*im);
  }

  float phase() {
    return atan2(im, re);
  }
}


class Vec {
  Complex val;
  boolean kartesian=false;

  PVector offset=new PVector();
  color c;
  String text;

  Vec( Complex val, color c, String text) {
    this.val=val;
    this.c=c;
    this.text=text;
  }



  void show() {
    pushMatrix();
    
    //Location
    translate(globalOffset.x, -globalOffset.y);
    translate(offset.x, offset.y);

    PVector head= new PVector(val.re, val.im);
    PVector tail=new PVector();

    //Props
    float phi= val.phase();
    float mag= val.mag();

    fill(c);
    stroke(c);

    //Triangle
    pushMatrix();
    translate(head.x, -head.y);
    rotate(-phi+HALF_PI);
    triangle(-mag/12, mag/6, 0, 0, mag/12, mag/6);
    rotate(-PI/2);
    text(text, -mag/4, 5+mag/10);
    popMatrix();

    head.limit(mag*0.85);

    //Line
    strokeWeight(mag/25);
    strokeCap(SQUARE);
    line(tail.x, -tail.y, head.x, -head.y);
    strokeWeight(1);
    
    popMatrix();
  }


  void move(float vx, float vy) {
    offset.add(vx, -vy);
  }
}
