class Orb {
  Object start, end, lastPlace; 
  PVector pos;
  PVector transPos;
  boolean finished=false;
  boolean endMoving=false;

  Orb(Object start, Object end) {
    this.start=start;
    this.end=end;
    this.pos=start.pos.copy();
  }

  void update() {
    move();
    show();
  }

  void show() {
    fill(255, 100, 0);
    transPos=pos.copy().add(camOffset);
    ellipse(transPos.x, transPos.y, 10, 10);
  }

  void move() {
    pos.lerp(end.pos, 0.1);
    if (!endMoving) {
      if (pos.dist(end.pos)<10) {
        end.currentOrb=this;
        endMoving=true;
      }
    }
  }
}
