class gridWall {
  PVector pos;
  boolean showTop = true, showLeft= true, showBot= true, showRight= true;
  boolean visited;
  int index;

  gridWall(PVector pos_, int index_) {
    pos=pos_;
    index=index_;
  }

  void show() {
    strokeWeight(1);
    colorMode(HSB, 1000, 100, 100);
    stroke(index%1000, 100, index);

    if (showLeft) {
      beginShape();
      vertex(pos.x, pos.y);
      vertex(pos.x, pos.y);
      vertex(pos.x, pos.y+size);
      endShape();
    }
    if (showBot) {
      beginShape();
      vertex(pos.x, pos.y+size);
      vertex(pos.x, pos.y+size);
      vertex(pos.x+size, pos.y+size);
      endShape();
    }
    if (showRight) {
      beginShape();
      vertex(pos.x+size, pos.y);
      vertex(pos.x+size, pos.y);
      vertex(pos.x+size, pos.y+size);
      endShape();
    }
    if (showTop) {
      beginShape();
      vertex(pos.x, pos.y);
      vertex(pos.x, pos.y);
      vertex(pos.x+size, pos.y);
      endShape();
    }

    colorMode(RGB, 255, 255, 255);
  }
}
