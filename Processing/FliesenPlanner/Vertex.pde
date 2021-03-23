class Vertex {

  PVector pos;
  PVector screenPos;
  boolean selected;
  int index;


  Vertex child;
  Vertex parent;
  Vertex(PVector pos) {
    this.pos=pos;
  }


  void showVertex() {
    screenPos=toScreenPos(pos);
    vertex(screenPos.x, screenPos.y);
  }

  void showPoint() {
    screenPos=toScreenPos(pos);
    fill(125, 255, 125);
    if (selected) {
      fill(255, 0, 0);
    }
    ellipse(screenPos.x, screenPos.y, 8, 8);
  }

  void showText() {
    if (child!=null) {
      float len=pos.dist(child.pos);

      PVector center=(pos.copy().add(child.pos)).div(2);
      PVector centerScreenPos=toScreenPos(center);

      if (toPrint) fill(0);
      textSize(10+len/4);
      text(nf(len, 0, 2), centerScreenPos.x, centerScreenPos.y);
    }
  }
}
