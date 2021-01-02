class Resistor {
  Bauteil B;
  PVector absPos;
  String Name;

  Complex resistance=new Complex(10, 0);

  Resistor(PVector absPos) {
    this.absPos=absPos;
  }

  void show() {
    stroke(0);
    strokeWeight(2);
    line(0, -len, 0, +len);
    strokeWeight(1);
    fill(255);
    rect(0, 0, len/1.8, len*1.2);
    fill(0);
    textSize(10);
    text(Name, len/3, -len/3-10);
    text(str((float)resistance.re)+((resistance.im!=0)?("+j"+str((float)resistance.im)):"")+"Ω", len/3, -len/3);
    textSize(14);
    drawCurrentArrow(B);
  }
}
