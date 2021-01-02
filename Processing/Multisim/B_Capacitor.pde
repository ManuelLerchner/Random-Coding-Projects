class Capacitor {
  Bauteil B;
  PVector absPos;
  String Name;

  Complex val;
  double capacitance=pow(10, -4);
  double Rintern=0.00001;

  Capacitor(PVector absPos) {
    this.absPos=absPos;
    double Xc=-1/(TWO_PI*freq*capacitance);
    val=new Complex(Rintern, Double.isInfinite(Xc)?9999999:Xc);
  }

  void show() {
    stroke(0);
    strokeWeight(2);
    line(0, 4, 0, +len);
    line(0, -4, 0, -len);
    strokeWeight(1);

    line(-len/2, 4, len/2, 4);
    line(-len/2, -4, len/2, -4);
    fill(0);
    textSize(10);
    text(Name, 5, -len/3-10);
    text(str((float)capacitance)+"F", 5, -len/3);
    text("-j"+nf(abs((float)val.im),0,1)+"Ω", 5, len/3);
    textSize(14);
    drawCurrentArrow(B);
  }
}
