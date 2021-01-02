///////////////////////////////////////////////////////////////////////
PVector mapPixeltoCoord(PVector in) {
  PVector out = new PVector();
  in.div(scale);
  out.x=map(in.x, -width/2, width/2, lookAtX-2, lookAtX+2);
  out.y=map(in.y, height/2, -height/2, lookAtY-2, lookAtY+2);
  return out;
}

///////////////////////////////////////////////////////////////////////
PVector mapCoordtoPixel(PVector in) {
  PVector out = new PVector();
  out.x=map(in.x, lookAtX-2, lookAtX+2, -width/2, width/2);
  out.y=map(in.y, lookAtY-2, lookAtY+2, height/2, -height/2);
  return out;
}

///////////////////////////////////////////////////////////////////////
PVector mapCoordtoPixelMovement(PVector in) {
  PVector out = new PVector();
  out.x=map(in.x, lookAtX-2+movement.x, lookAtX+2+movement.y, -width/2, width/2);
  out.y=map(in.y, lookAtY-2, lookAtY+2, height/2, -height/2);
  return out;
}

///////////////////////////////////////////////////////////////////////
float angle(PVector a) {
  float angle=atan2(a.y, a.x);
  if (angle<0) {
    angle+=TWO_PI;
  }
  return angle;
}

///////////////////////////////////////////////////////////////////////
void Axes() {
  PVector center=mapCoordtoPixel(new PVector(0, 0));
  PVector unit=mapCoordtoPixel(new PVector(1, 1));
  stroke(0, 0, 0);
  line(center.x, -height/2/scale, center.x, height/2/scale);
  line(-width/2/scale, center.y, width/2/scale, center.y);
  fill(0, 0, 1);
  ellipse(unit.x, center.y, 5, 5);
  ellipse(center.x, unit.y, 5, 5);
  text("1", unit.x+3, center.y);
  text("1", center.x+3, unit.y);
}
