class Tag {
  PVector pos;
  String type;
  Node N;
  Way W;

  Tag(Node N, Way W, String type) {
    this.N=N;
    this.W=W;
    this.pos=N.pos;
    this.type=type;
  }

  void show() {
    fill(255);
    text(type, N.screenPos.x, N.screenPos.y);
    ellipse(N.screenPos.x, N.screenPos.y, 6, 6);
  }
}
