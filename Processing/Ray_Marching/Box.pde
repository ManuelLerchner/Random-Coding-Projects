class Box {
  PVector pos;
  PVector size;
  color col;

  Box(PVector pos, PVector size) {
    this.pos=pos;
    this.size=size;
    col = color(random(50, 255), random(50, 255), random(50, 255));
  }

  void show() {
    noStroke();
    fill(col);
    rect(pos.x, pos.y, 2*size.x, 2*size.y);

    fill(0);
    ellipse(pos.x+size.x-1, pos.y+size.y-1, 5, 5);
    ellipse(pos.x+size.x-1, pos.y-size.y+1, 5, 5);
    ellipse(pos.x-size.x+1, pos.y+size.y-1, 5, 5);
    ellipse(pos.x-size.x+1, pos.y-size.y+1, 5, 5);
  }
}

float sgnDstToBox(PVector p, PVector center, PVector size) {
  PVector offset = absPV(p.copy().sub(center)).copy().sub(size);
  float unsignedDist = maxPV(offset, new PVector(0, 0)).mag();
  float dstInside =maxOfPV(minPV(offset, new PVector(0, 0)));
  return unsignedDist+dstInside;
}

//////////////////////////////////////////////////////////////////

PVector absPV(PVector P) {
  PVector out = P.copy();
  if (out.x<0) {
    out.x*=-1;
  }
  if (out.y<0) {
    out.y*=-1;
  }
  return out;
}

PVector maxPV(PVector P1, PVector P2) {
  PVector out = P1.copy();
  if (P2.x>P1.x) {
    out.x=P2.x;
  }
  if (P2.y>P1.y) {
    out.y=P2.y;
  }
  return out;
}

PVector minPV(PVector P1, PVector P2) {
  PVector out = P1.copy();
  if (P2.x<P1.x) {
    out.x=P2.x;
  }
  if (P2.y<P1.y) {
    out.y=P2.y;
  }
  return out;
}

float maxOfPV(PVector P) {
  float out = -100000;
  if (P.x>out) {
    out=P.x;
  }
  if (P.y>out) {
    out=P.y;
  }
  return out;
}
