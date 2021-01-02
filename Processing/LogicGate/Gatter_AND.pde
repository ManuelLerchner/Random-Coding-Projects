class AND {
  UTILITY Parent;

  AND() {
  }


  boolean fun(boolean A, boolean B) {
    return A&&B;
  }

  void show() {
    stroke(0);
    strokeWeight(1);
    fill(255);

    //Pins
    rect(-10, 5, 10, 2);
    rect(-10, -5, 10, 2);
    rect(10, 0, 10, 2);


    if (Parent.highlighted) {
      stroke(255, 0, 125);
    }

    //Body
    rect(0, 0, 20, 20);
    fill(0);
    text("&", 0, 0);

    stroke(0);
    fill(100);
    if (Parent.invert[0]) {
      ellipse(-12, 5, 4, 4);
    }
    if (Parent.invert[1]) {
      ellipse(-12, -5, 4, 4);
    }
    if (Parent.invert[2]) {
      ellipse(12, 0, 4, 4);
    }
  }
}
