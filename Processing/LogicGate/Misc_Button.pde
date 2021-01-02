class BUTTON {
  UTILITY Parent;

  boolean state;
  boolean Flanke;
  BUTTON() {
  }


  void show() {
    stroke(0);
    strokeWeight(1);

    fill(255);
    if (state) {
      fill(255, 200, 0);
    }

    //Pin
    rect(10, 0, 10, 2);

    if (Parent.highlighted) {
      stroke(255, 0, 125);
    }

    //Body
    rect(0, 0, 20, 20);
    fill(0);
    if (Flanke) {
      text("F", 0, 0);
    } else {
      text("S", 0, 0);
    }

    stroke(0);
    fill(100);
    if (Parent.invert[0]) {
      ellipse(12, 0, 4, 4);
    }
  }
}
