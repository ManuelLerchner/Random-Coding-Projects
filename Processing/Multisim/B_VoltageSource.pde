class VoltageSource {
  Bauteil B;
  PVector absPos;
  String Name;

  Complex Voltage=new Complex(10, 0);
  Complex ri=new Complex(0.00001, 0);

  VoltageSource(PVector absPos) {
    this.absPos=absPos;
  }

  void show() {
    stroke(0);
    strokeWeight(2);
    line(0, -len, 0, +len);
    noFill();
    strokeWeight(1);
    ellipse(0, 0, len*1.2, len*1.2);
    strokeWeight(1);
    fill(0);

    textSize(10);
    text(Name, 10, -len*0.8);
    text(str((float)Voltage.re)+((Voltage.im!=0)?("+j"+str((float)Voltage.im)):"")+"V", 10, -len*0.8+10);
    textSize(14);
    drawCurrentArrow(B);
  }
}
