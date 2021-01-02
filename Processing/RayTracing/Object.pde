interface Object {


  void show();
  void interact();

  Color getColor();
  boolean isInside(PVector point);
  PVector surfaceNormal(PVector point);
  PVector getPos();
  float getRefractiveIndex();
}
