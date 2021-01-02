class CurrentSource {
  Bauteil B;
  PVector absPos;
  String Name;

  Complex current=new Complex(1, 0);

  CurrentSource(PVector absPos) {
    this.absPos=absPos;
  }

  void show() {
    stroke(0);
    strokeWeight(2);
    line(-len*0.6, 0, len*0.6, 0);
    line(0, -len, 0, -0.6*len);
    line(0, len, 0, 0.6*len);
    noFill();
    strokeWeight(1);
    ellipse(0, 0, len*1.2, len*1.2);
    strokeWeight(1);
    fill(0);
    textSize(10);
    text(Name, 10, -len*0.8);
    text(str((float)current.re)+((current.im!=0)?("+j"+str((float)current.im)):"")+"A", 10, -len*0.8+10);
    textSize(14);
    drawCurrentArrow(B);
  }
}
