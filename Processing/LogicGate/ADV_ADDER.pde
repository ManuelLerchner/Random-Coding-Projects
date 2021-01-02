class ADDER {
  UTILITY Parent;

  ADDER() {
  }


  boolean sum(boolean A, boolean B, boolean C) {
    boolean temp1=A^B;
    return temp1^C;
  }

  boolean co(boolean A, boolean B, boolean C) {
    boolean temp1=A^B;
    boolean temp2=temp1&&C;
    boolean temp3=A&&B;
    return temp2||temp3;
  }

  void show() {
    stroke(0);
    strokeWeight(1);
    fill(255);

    //Pins
    rect(-10, 5, 10, 2);
    rect(-10, -5, 10, 2);
    rect(10, 0, 10, 2);
    rect(0, 10, 2, 10);
    rect(0, -10, 2, 10);


    if (Parent.highlighted) {
      stroke(255, 0, 125);
    }

    //Body
    rect(0, 0, 20, 20);
    fill(0);
    text("ADD", 0, 0);

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
