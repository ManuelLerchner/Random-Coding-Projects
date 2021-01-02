class NOT {
  UTILITY Parent;
  NOT() {
  }


  boolean fun(boolean A) {
    return !A;
  }

  void show() {
    stroke(0);
    strokeWeight(1);
    fill(255);

    //Pins
    rect(-10, 0, 10, 2);
    rect(-10, 0, 10, 2);

    if (Parent.highlighted) {
      stroke(255, 0, 125);
    }

    //Body
    rect(0, 0, 20, 20);
    fill(0);
    text("!", 0, 0);

    stroke(0);
    fill(100);
    if (Parent.invert[0]) {
      ellipse(-12, 0, 4, 4);
    }
    if (Parent.invert[1]) {
      ellipse(12, 0, 4, 4);
    }
  }
}
