class Square implements Object {
  boolean selected;
  PVector pos;
  float rad, diam;
  float refractiveIndex=2;


  Color col;

  Square(PVector pos, float rad, Color col) {
    this.pos=pos; 
    this.rad=rad;
    this.diam=2*rad;
    this.col=col;
  }


  void show() {
    if (selected) {
      pos.set(mouse);
    }

    stroke(col);
    fill(col);
    rect(pos.x, pos.y, diam, diam);
  }



  boolean isInside(PVector point) {
    boolean insideX=(point.x>pos.x-rad)&&(point.x<pos.x+rad);
    boolean insideY=(point.y>pos.y-rad)&&(point.y<pos.y+rad);
    return insideX&&insideY;
  }


  PVector surfaceNormal(PVector point) {

    PVector dir=new PVector();
    float heading= point.copy().sub(pos).normalize().heading()+PI;

    if (heading<PI/4) {
      dir.set(-1, 0);
    } else if (heading <PI/4*3) {
      dir.set(0, -1);
    } else if (heading <PI/4*5) {
      dir.set(1, 0);
    } else if (heading <PI/4*7) {
      dir.set(0, 1);
    } else {
      dir.set(-1, 0);
    }


    return dir;
  }


  Color getColor() {
    return col;
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
