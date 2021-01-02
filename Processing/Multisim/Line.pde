Line currLine;
class Line {
  ArrayList<PVector> segments=new ArrayList();
  PVector startPos, endPos;
  boolean selected;
  boolean hovered;
  int index;

  Complex Voltage=new Complex();

  Line(int index, PVector start) {
    this.startPos=start;
    this.index=index;
    endPos=start;
  }

  void show() {
    //Color
    noFill();
    stroke(0);
    strokeWeight(3);
    if (selected) {
      stroke(255, 0, 0);
    }
    if (index==0) {
      stroke(255, 125, 0);
    }

    //Draw Line
    beginShape();
    for (PVector S : segments) {
      PVector seg= mapToCoordinates(S);
      vertex(seg.x, seg.y);
    }
    endShape();


    //Line Preview
    if (selected) {
      PVector currEndPos= mapToCoordinates(endPos);
      stroke(0, 100, 100);
      if (abs(currEndPos.x-mouseX)>abs(currEndPos.y-mouseY)) {
        line(currEndPos.x, currEndPos.y, mouseX, currEndPos.y);
      } else {
        line(currEndPos.x, currEndPos.y, currEndPos.x, mouseY);
      }
    }

    //EndPoints
    if (startPos!=null) {
      PVector start= mapToCoordinates(startPos);
      ellipse(start.x, start.y, 5, 5);
    }
    if (endPos!=null) {
      PVector end= mapToCoordinates(endPos);
      ellipse(end.x, end.y, 5, 5);
    }
  }

  //////////////////////////////////////////////////////////////////////////////////
  void interpolate(PVector newPos) {
    if (abs(endPos.x-newPos.x)>abs(endPos.y-newPos.y)) {
      newPos.y=endPos.y;
    } else {
      newPos.x=endPos.x;
    }
    if (endPos.x<newPos.x) {
      for (float i=endPos.x+1; i <=newPos.x; i++) {
        segments.add(new PVector(i, endPos.y));
      }
    } else if (endPos.x>newPos.x) {
      for (float i=endPos.x-1; i >=newPos.x; i--) {
        segments.add(new PVector(i, endPos.y));
      }
    }
    if (endPos.y>newPos.y) {
      for (float j=endPos.y-1; j >=newPos.y; j--) {
        segments.add(new PVector(endPos.x, j));
      }
    } else  if (endPos.y<newPos.y) {
      for (float j=endPos.y+1; j <=newPos.y; j++) {
        segments.add(new PVector(endPos.x, j));
      }
    }
    endPos=newPos;
  }

  void hover() {
    if (millis()-tLastMoved>500) {
      hovered=false;
      if (segments.contains(mousePos)) {
        hovered=true;
      }
      if (hovered) {
        showTextOnHud(Voltage, "V");
      }
    }
  }
}
