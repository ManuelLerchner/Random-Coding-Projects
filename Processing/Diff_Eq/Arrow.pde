class Arrow {
  PVector screenPixelPos;
  PVector pos;

  PVector arrowPos;
  PVector arrowPixelPos;
  PVector arrowDir;

  Arrow(PVector pos) {
    this.pos=pos;
  }

  void show() {
    strokeWeight(1);
    screenPixelPos=toScreenPos(pos);


    fill(4.2, 0.51, 1);
    strokeWeight(1);
    stroke(0, 0, 0.4);
    ellipse(screenPixelPos.x, screenPixelPos.y, 30*stepSize/range, 30*stepSize/range);
  }

  void drawArrow() {

    arrowPixelPos=toScreenPos(arrowPos);

    stroke(0, 0, 0.4);
    line(screenPixelPos.x, screenPixelPos.y, arrowPixelPos.x, arrowPixelPos.y);
    noStroke();

    pushMatrix();
    translate(arrowPixelPos.x, arrowPixelPos.y);
    rotate(-arrowDir.heading()-PI/2);
    float hLen=60*stepSize/range;
    triangle(-hLen, -hLen, hLen, -hLen, 0, hLen);  
    popMatrix();
  }

  void calcGradient() {
    PVector grad=functionPrime(pos);


    arrowDir=grad;
    arrowDir.mult(0.1);
    //arrowDir.limit(stepSize/2);

    arrowPos=pos.copy().add(arrowDir);
  }
}
