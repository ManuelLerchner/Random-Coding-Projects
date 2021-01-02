class Circle {
  PVector pos;
  float rad;
  color col;

  Circle(PVector pos, float rad) {
    this.pos=pos;
    this.rad=rad;
    col = color(random(50, 255), random(50, 255), random(50, 255));
  }

  void show() {
    noStroke();
    fill(col);
    ellipse(pos.x, pos.y, 2*rad, 2*rad);
  }
}

float sgnDstToCirlce(PVector p, PVector center, float rad) {
  return (center.copy().sub(p)).mag()-rad;
}
