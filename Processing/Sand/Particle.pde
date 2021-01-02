class Particle {
  PVector pos;

  Particle(PVector pos) {
    this.pos=pos;
  }

  void show() {
    rect(pos.x, pos.y, 5, 5);
  }

  void move() {
    if (pos.y<height-10) {
      this.pos.add(0, 2);
    }
  }
}
