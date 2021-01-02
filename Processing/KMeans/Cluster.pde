class Cluster {
  PVector pos;
  int num;

  ArrayList<Point> Points=new ArrayList();
  ArrayList<Point> Edge=new ArrayList();

  Cluster(PVector pos, int num) {
    this.pos=pos;
    this.num=num;
  }

  Cluster() {
  }

  void show() {

    if (Points.size()>0) {
      fill(Points.get(0).col, 50);
    }
    beginShape();
    for (Point P : Edge) {
      vertex(P.pos.x, P.pos.y);
    }
    endShape(CLOSE);
  }
}
