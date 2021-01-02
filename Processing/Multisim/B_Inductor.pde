class Inductor {
  Bauteil B;
  PVector absPos;
  String Name;

  Complex val=new Complex(0, 10);
  double inductance=0.1;
  double Rintern=0.00001;

  Inductor(PVector absPos) {
    this.absPos=absPos;
    val=new Complex(Rintern, TWO_PI*freq*inductance );
  }

  void show() {
    stroke(0);
    strokeWeight(2);
    line(0, -len, 0, +len);
    strokeWeight(1);
    fill(0);
    rect(0, 0, len/1.8, len*1.2);
    fill(0);
    textSize(10);
    text(Name, len/3, -len/3-10);
    text(str((float)inductance)+"H", len/3, -len/3);
    text("j"+nf(abs((float)val.im), 0, 1)+"Ω", len/3, len/3);
    textSize(14);
    drawCurrentArrow(B);
  }
}
