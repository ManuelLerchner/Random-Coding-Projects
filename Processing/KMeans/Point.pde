class Point {
  PVector pos;

  color col;
  float alpha;
  int cluster=-1;

  Point(PVector pos) {
    this.pos=pos;
  }
  Point() {
  }




  void show() {
    col= color(255, 255, 255);
    if (cluster!=-1) {
      float PHI = (1 + sqrt(5))/2;
      float n = cluster * PHI - floor(cluster * PHI);
      col=  hsv2rgb(n, 1, 1);
    }

    fill(col);
    ellipse(pos.x, pos.y, 5, 5);
  }
}
