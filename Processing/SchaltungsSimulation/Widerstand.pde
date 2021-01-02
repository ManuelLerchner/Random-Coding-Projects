class Widerstand {
  PVector pos;
  PVector size = new PVector(20, 10);
  PVector TextSpot = new PVector(0, 15);
  boolean selected;
  boolean hovered;
  float rotation;
  float val;
  int index;
  int morePositive;
  String Name;
  String currentDir;
  double current;

  Widerstand(PVector pos_, float val_, int index_) {
    pos=pos_;
    val=val_;
    index=index_;
    Name="R"+str(index);
  }

  void show() {
    pushMatrix();
    translate(pos.x, pos.y); 
    rotate(rotation);
    fill(255);
    stroke(0);
    line(-size.x, 0, size.x, 0);
    rect(0, 0, size.x, size.y);
    drawCurrentArrow();
    popMatrix();
    showStats();
  }

  void drawCurrentArrow() {
    fill(0);
    float hLen=3;
    if (current>=0.000001) {
      if (morePositive==2) {
        triangle(hLen, 0, -hLen, hLen, -hLen, -hLen );
      }
      if (morePositive==1) {
        triangle(-hLen, 0, hLen, hLen, hLen, -hLen );
      }
    }
  }

  void showStats() {
    hovered=false;
    if (mousePos.dist(pos)<gridSize) {
      if (mouseStill) {
        boolean exit=false;
        for (Widerstand W : Widerstaende) {
          if (W.hovered) {
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
      if (current>=0.000001) {
        text=nf((float)(current), 0, 3)+"A";
      }
      HudRectSize=new PVector(textWidth(text)+5, 15);
      HudPos=pos.copy();
      HudText=text;
    }
    TextSpot.x=abs(sin(rotation)*25);
    TextSpot.y=abs(cos(rotation)*15);
    fill(255);
    text(val+"Ω", pos.x+TextSpot.x, pos.y+TextSpot.y);
  }


  void AddConnector() {
    PVector ConnectorPosL = new PVector(pos.x+size.x*cos(rotation), pos.y+size.x*sin(rotation));
    PVector ConnectorPosR = new PVector(pos.x-size.x*cos(rotation), pos.y-size.x*sin(rotation));
    Connectors.add(new Connector(roundToGrid(ConnectorPosL), 1, Name));
    Connectors.add(new Connector(roundToGrid(ConnectorPosR), 2, Name));
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
