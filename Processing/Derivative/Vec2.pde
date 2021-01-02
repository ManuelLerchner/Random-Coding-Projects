class Vec2 {
  double x, y;
  Vec2(double x, double y) {
    this.x=x;
    this.y=y;
  }
  Vec2() {
    this.x=0;
    this.y=0;
  }
}

double distV(Vec2 A, Vec2 B) {
  return Math.sqrt(  Math.pow(A.x-B.x, 2)+ Math.pow(A.y-B.y, 2));
}
