class Line {
  ArrayList<PVector> Vertex = new ArrayList();
  ArrayList<PVector> AllPoints = new ArrayList();
  boolean Selected=false;
  boolean hovered=false;
  PVector EndLine=new PVector();
  PVector StartLine = new PVector();
  int index;
  int inNode;
  double Voltage;

  Line(PVector start_, int index_) {
    Vertex.add(start_);
    StartLine=start_;
    Selected=true;
    EndLine=start_;
    index=index_;
  }

  void show() {
    //ConnectLine
    stroke(0);
    strokeWeight(1);
    noFill();
    if (index==0) {  
      stroke(255, 0, 0);
      strokeWeight(2);
    }
    beginShape();
    for (PVector P : Vertex) {
      vertex(P.x, P.y);
    }
    endShape();
    strokeWeight(1);
    //Preview
    if (Selected) {
      PVector Last =Vertex.get(Vertex.size()-1);
      if (abs(Last.x-mousePos.x)<abs(Last.y-mousePos.y)) {
        EndLine= new PVector(Last.x, mousePos.y);
      } else {
        EndLine= new PVector(mousePos.x, Last.y);
      }
      stroke(0);
      line(Last.x, Last.y, EndLine.x, EndLine.y);
    }
  }

  void Interpolate() { 
    for (int i =1; i < Vertex.size(); i++) {
      PVector T = Vertex.get(i);
      PVector O = Vertex.get(i-1);
      PVector InterPolate = new PVector();
      if (T.x==O.x) {
        float Ydist=abs(T.y-O.y);
        for (float y=min(T.y, O.y); y <= min(T.y, O.y)+Ydist; y+=gridSize) {
          InterPolate=roundToGrid(new PVector(T.x, y));
          AllPoints.add(InterPolate);
        }
      } else if (T.y==O.y) {
        float Xdist=abs(T.x-O.x);
        for (float x=min(T.x, O.x); x <= min(T.x, O.x)+Xdist; x+=gridSize) {
          InterPolate=roundToGrid(new PVector(x, T.y));
          AllPoints.add(InterPolate);
        }
      }
    }
  }

  void Hover() {
    hovered=false;
    for (PVector P : AllPoints) {
      if (mousePos.dist(P)<0.8*gridSize) {
        if (mouseStill) {
          boolean exit=false;
          for (Line L : Lines) {
            if (L.hovered) {
              exit=true;
              break;
            }
          }
          if (!exit) {
            hovered=true;
          }
        }
      }
    }
    if (hovered) {
      String text=" ";
      PVector pos=new PVector(mousePos.x-20-textWidth(text)-5, mousePos.y-20);
      text=nf((float)(Voltage), 0, 3)+"V";
      HudRectSize=new PVector(textWidth(text)+5, 15);
      HudPos=pos.copy();
      HudText=text;
    }
  }
}
