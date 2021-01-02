class Diode {
  PVector pos;
  PVector size = new PVector(20, 20);
  PVector TextSpot = new PVector(0, 0);
  boolean selected;
  boolean hovered;
  float rotation;
  float val;
  int index;
  int morePositive;
  String NamePos;
  String NameNeg;
  double voltage;

  double deltaV;
  double VoltageAK;
  double Geq;
  double Ieq;
  double Id;
  double Is=pow(10, -12);
  double Vt =0.025;
  double ClampForwardVoltage=1;

  Diode(PVector pos_, int index_) {
    pos=pos_;
    index=index_;
    NamePos="D"+str(index)+"P";
    NameNeg="D"+str(index)+"N";
  }

  void show() {
    pushMatrix();
    translate(pos.x, pos.y); 
    rotate(rotation);
    fill(255);
    stroke(0);
    line(-size.x, 0, size.x, 0);
    line(size.x/2, -size.x/2, size.x/2, size.x/2);
    triangle(size.x/2, 0, -size.x/2, size.x/2, -size.x/2, -size.x/2 );
    drawCurrentArrow();
    popMatrix();
    showStats();
    TextSpot.x=abs(sin(rotation)*35);
    TextSpot.y=abs(cos(rotation)*15);
    fill(255);
    float textVal=(float)VoltageAK;
    if (VoltageAK==1) {
      textVal=0;
    }
    text(nf(textVal, 0, 2)+"V", pos.x+TextSpot.x, pos.y+TextSpot.y);
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
      if (Math.abs(Id)>=0.000001) {
        text=nf((float)(Is*(Math.exp(VoltageAK/Vt)-1)), 0, 3)+"A";
      }
      HudRectSize=new PVector(textWidth(text)+5, 15);
      HudPos=pos.copy();
      HudText=text;
    }
  }

  void drawCurrentArrow() {
    fill(0);
    float hLen=3;
    if (Id>=0.000001) {
      if (morePositive==1) {
        triangle(hLen, 0, -hLen, hLen, -hLen, -hLen );
      }
    }
  }


  void AddConnector() {
    PVector ConnectorPosL = new PVector(pos.x+size.x*cos(rotation), pos.y+size.x*sin(rotation));
    PVector ConnectorPosR = new PVector(pos.x-size.x*cos(rotation), pos.y-size.x*sin(rotation));
    Connectors.add(new Connector(roundToGrid(ConnectorPosL), 1, NameNeg));
    Connectors.add(new Connector(roundToGrid(ConnectorPosR), 2, NamePos));
  }

  void calcValues() {
    VoltageAK=Math.min(VoltageAK, ClampForwardVoltage);
    Id=Is*(Math.exp(VoltageAK/Vt)-1);
    Geq=Is/Vt*Math.exp(VoltageAK/Vt);
    Ieq=Id-Geq*VoltageAK;
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
