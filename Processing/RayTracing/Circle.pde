class Circle implements Object {
  boolean selected;
  PVector pos;
  float rad;

  float refractiveIndex=1.2;

  Color col;

  Circle(PVector pos, float rad, Color col) {
    this.pos=pos; 
    this.rad=rad;
    this.col=col;
  }


  void show() {
    if (selected) {
      pos.set(mouse);
    }
    stroke(col);
    fill(col);
    ellipse(pos.x, pos.y, 2*rad, 2*rad);
  }


  Color getColor() {
    return col;
  }



  float distance(PVector point) {
    return pos.dist(point);
  }

  boolean isInside(PVector point) {
    return distance(point)<rad;
  }

  PVector surfaceNormal(PVector point) {
    PVector dir= point.copy().sub(pos).normalize();
    return dir;
  }

  PVector getPos() {
    return pos;
  }

  float getRefractiveIndex() {
    return refractiveIndex;
  }

  void interact() {
    if (mousePressed) {
      if (isInside(mouse)) {
        selected=!selected;
      }
    }
  }
}
