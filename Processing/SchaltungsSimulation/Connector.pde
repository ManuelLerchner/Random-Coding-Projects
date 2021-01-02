class Connector {
  PVector pos;
  String Name;
  int ConnectorNum;
  double voltage;

  Connector(PVector pos_, int ConnectorNum_, String Name_) {
    pos=pos_;
    Name=Name_;
    ConnectorNum=ConnectorNum_;
  }

  void show() {
    fill(0, 255, 0, 100);
    stroke(0);
    ellipse(pos.x, pos.y, 5, 5);
  }
}
