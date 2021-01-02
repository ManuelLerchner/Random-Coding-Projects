class Button {
  PVector pos;
  String name;
  boolean sw;
  boolean on;
  int radius = 22;

  Button(float x_, float y_, String _name) {
    pos = new PVector(x_, y_);
    name = _name;
  }

  Button(float x_, float y_, String _name, boolean swit) {
    pos = new PVector(x_, y_);
    name = _name;
    sw=swit;
  }

  void display() {
    noFill();
    if (sw) {
      fill(0);
      if (on) {
        fill(0.5, 0, 0);
      }
    }
    if (hover()) fill(0, 1, 0);
    stroke(0);
    ellipse(pos.x, pos.y, radius*2, radius*2);
    fill(0);
    text(name, pos.x, pos.y);
  }

  boolean hover() {
    PVector mouse = new PVector(mouseX, mouseY);
    if (mouse.dist(pos) < radius) {
      if (sw && mousePressed) {
        on=!on;
      }
      return true;
    } 
    return false;
  }
}
