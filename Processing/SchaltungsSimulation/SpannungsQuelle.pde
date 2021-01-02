class SpannungsQuelle {
  PVector pos;
  PVector size = new PVector(0, 20);
  PVector TextSpot = new PVector(0, 15);
  boolean selected;
  boolean hovered;
  float rotation=HALF_PI;
  float val;
  int index;
  String NamePos;
  String NameNeg;
  double Ri=0.0001;
  double current;

  SpannungsQuelle(PVector pos_, float val_, int index_) {
    pos=pos_;
    val=val_;
    index=index_;
    NamePos="U"+str(index)+"P";
    NameNeg="U"+str(index)+"N";
  }

  void show() {
    pushMatrix();
    translate(pos.x, pos.y); 
    rotate(rotation);
    noFill();
    stroke(0);
    line(0, -size.y, 0, size.y);
    ellipse(0, 0, size.y+10, size.y+10);
    fill(255);
    text("+", 10, -size.y);
    popMatrix();
    showStats();
  }

  void showStats() {
    hovered=false;
    if (mousePos.dist(pos)<gridSize) {
      if (mouseStill) {
        boolean exit=false;
        for (SpannungsQuelle S : SpannungsQuellen) {
          if (S.hovered) {
            exit=true;
            break;
          }
        }
        if (!exit) {
          hovered=true;
        }
      }
    }
    if (hovered) {
      String text=" ";
      PVector pos=new PVector(mousePos.x-20-textWidth(text)-5, mousePos.y-20);
      if (Math.abs(current)>=0.000001) {
        text=nf((float)(current), 0, 3)+"A";
      }
      HudRectSize=new PVector(textWidth(text)+5, 15);
      HudPos=pos.copy();
      HudText=text;
    }
    TextSpot.x=(cos(rotation)*35);
    TextSpot.y=(sin(rotation)*25);
    text(val+"V", pos.x+TextSpot.x, pos.y+TextSpot.y);
  }

  void AddConnector() {
    PVector ConnectorPosT = new PVector(pos.x+size.y*sin(rotation), pos.y-size.y*cos(rotation));
    PVector ConnectorPosB = new PVector(pos.x-size.y*sin(rotation), pos.y+size.y*cos(rotation));
    Connectors.add(new Connector(roundToGrid(ConnectorPosT), 1, NamePos));
    Connectors.add(new Connector(roundToGrid(ConnectorPosB), 2, NameNeg));
  }

  void Select() {
    if (mousePos.dist(pos)<max(size.x, size.y) && !draw) {
      selected=!selected;
      GlobalSelected=!GlobalSelected;
      UpdateWires=true;
    }
  }

  void move() {
    if (selected) {
      pos=roundToGrid(mousePos);
    }
  }
}
