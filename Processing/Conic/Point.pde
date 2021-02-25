class Point {

  PVector pos;


  boolean selected;
  Point(PVector pos) {
    this.pos=pos;
  }

  void plot() {

    PVector mapped=Plotter.mapToGrid(pos);
    fill(255, 0, 0);
    ellipse(mapped.x, mapped.y, 10, 10);
  }


  void update() {
    if (selected) {
      pos= Plotter.mapToCoords(new PVector(mouseX, mouseY));
    }
  }
}
