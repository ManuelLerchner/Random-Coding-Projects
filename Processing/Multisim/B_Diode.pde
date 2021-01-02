class Diode {
  Bauteil B;
  PVector absPos;
  String Name;

  double geq;
  double Id;
  double Ieq;
  double Is=pow(10, -12);
  double Vt =0.025;

  Diode(PVector absPos) {
    this.absPos=absPos;
  }

  void show() {
    stroke(0);
    strokeWeight(2);
    line(0, -len, 0, +len);
    strokeWeight(1);
    fill(255);
    triangle(-len/3, -len/3, 0, len/3, len/3, -len/3);
    line(-len/3, len/3, len/3, len/3);
    fill(0);
    textSize(10);
    text(Name, len/3, len/3);
    text(nf((float)B.Vacross.re, 0, 2)+"V", len/3, len/3+10);
    textSize(14);


    drawCurrentArrow(B);
  }


  void calc() {
    double interVD=B.Vacross.re;

    if (Double.isNaN(interVD)) {
      interVD=0;
    }
    if (interVD>1) {
      interVD=1;
    }

    geq=exp((float)(interVD/ Vt))* Is/ Vt;
    Id =Is* (exp((float)(interVD/ Vt))-1);
    Ieq=Id- geq*interVD;


    B.Resistance=Reciprocal(new Complex(geq+0.000001,0));
    B.CurrentSource=new Complex(Ieq, 0);
  }
}
