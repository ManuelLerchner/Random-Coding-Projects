class Node {
  ArrayList<Node> outputs= new ArrayList();
  ArrayList<Orb> Orbs= new ArrayList();
  ArrayList<PVector> textPos= new ArrayList();
  StringList conditions= new StringList();
  IntList straighten= new IntList();

  PVector pos, movedPos;
  boolean hovered, selected, acceptingNode;
  int hoveredLine, index;
  long selectTime;

  boolean reserved;


  Node(PVector pos) {
    this.pos=pos.copy();
    this.movedPos=pos;
    for (int i=0; i < Nodes.size()*3; i++) {
      boolean valid=true;
      for (Node N : Nodes) {
        if (N.index==i) {
          valid=false;
        }
      }
      if (valid) {
        index=i;
        break;
      }
    }
  }

  ////////////////////////////////////////////////////////////////////////////////////////////////
  void initialize(Node after, String Condition) {
    outputs.add(after);
    conditions.append(Condition);
  }

  ////////////////////////////////////////////////////////////////////////////////////////////////
  void show() {
    //Ellipse
    movedPos=pos.copy().add(transOffset);
    fill(255);
    if (acceptingNode) {
      ellipse(movedPos.x, movedPos.y, 23, 23);
      fill(200, 200, 18);
    }
    if (index==0) {
      fill(0, 255, 255);
    }
    if (hovered) {
      fill(0, 255, 0);
    }

    ellipse(movedPos.x, movedPos.y, 15, 15);
    text("Z"+index, movedPos.x, movedPos.y+16);
  }

  ////////////////////////////////////////////////////////////////////////////////////////////////
  void connect() {
    textPos.clear();
    //Create BezierCurves

    for (int i = 0; i<outputs.size(); i++) {
      Node N = outputs.get(i);
      PVector mid = (movedPos.copy().add(N.movedPos)).mult(0.5);
      float angle = atan2(N.pos.y-pos.y, N.pos.x-pos.x);
      float loop = (N.movedPos.copy().sub(movedPos.copy())).mult(0.7).mag();
      if (N.equals(this)) {
        noFill();
        bezier(movedPos.x, movedPos.y, movedPos.x+40, movedPos.y-60, movedPos.x-40, movedPos.y-60, movedPos.x, movedPos.y);
        PVector Textpos=moveOnBezier(N, 0.5, true);
        textPos.add(Textpos.copy());
        float hLen=5;
        pushMatrix();
        translate(Textpos.x, Textpos.y);
        rotate(HALF_PI);
        fill(0);
        triangle(-hLen, -hLen, +hLen, -hLen, 0, +hLen);  
        popMatrix();
      } else {
        if (!straighten.hasValue(i)) {
          PVector Textpos=moveOnBezier(N, 0.5, false);
          noFill();
          bezier(movedPos.x, movedPos.y, mid.x-0.5*cos(angle+HALF_PI)*loop, mid.y-0.5*sin(angle+HALF_PI)*loop, mid.x-0.3*cos(angle+HALF_PI)*loop, mid.y-0.3*sin(angle+HALF_PI)*loop, N.movedPos.x, N.movedPos.y);
          textPos.add(Textpos.copy());
          float hLen=constrain(loop/15, 5, 40);
          pushMatrix();
          translate(Textpos.x, Textpos.y);
          rotate(angle-HALF_PI);
          fill(0);
          triangle(-hLen, -hLen, +hLen, -hLen, 0, +hLen);  
          popMatrix();
        } else {
          line(movedPos.x, movedPos.y, N.movedPos.x, N.movedPos.y);
          float hLen=constrain(loop/15, 5, 40);
          pushMatrix();
          translate(mid.x, mid.y);
          rotate(angle-HALF_PI);
          fill(0);
          triangle(-hLen, -hLen, +hLen, -hLen, 0, +hLen);  
          popMatrix();
          textPos.add(mid.copy());
        }
      }
      fill(255);
      if (hoveredLine==i) {
        fill(230, 70, 30);
      }

      text(conditions.get(i), textPos.get(i).x, textPos.get(i).y);
    }

    //Selected
    if (selected) {
      noFill();
      if (mousePos.dist(pos)>10) {
        PVector mid = (movedPos.copy().add(mousePos.copy().add(transOffset))).mult(0.5);
        float loop = (mousePos.copy().sub(pos)).mult(0.7).mag();
        float angle = atan2(mousePos.y-pos.y, mousePos.x-pos.x);
        bezier(movedPos.x, movedPos.y, mid.x-0.5*cos(angle+HALF_PI)*loop, mid.y-0.5*sin(angle+HALF_PI)*loop, mid.x-0.3*cos(angle+HALF_PI)*loop, mid.y-0.3*sin(angle+HALF_PI)*loop, mousePos.x+transOffset.x, mousePos.y+transOffset.y);
      } else { 
        bezier(movedPos.x, movedPos.y, movedPos.x+40, movedPos.y-60, movedPos.x-40, movedPos.y-60, movedPos.x, movedPos.y);
      }
    }
  }

  ////////////////////////////////////////////////////////////////////////////////////////////////
  PVector moveOnBezier(Node N, float step, boolean loopOnItself) {
    if (loopOnItself) {
      float x = bezierPoint(movedPos.x, movedPos.x+40, movedPos.x-40, movedPos.x, step);
      float y = bezierPoint(movedPos.y, movedPos.y-60, movedPos.y-60, movedPos.y, step);
      return new PVector(x, y);
    }
    PVector mid = (movedPos.copy().add(N.movedPos.copy())).mult(0.5);
    float angle = atan2(N.pos.y-pos.y, N.pos.x-pos.x);
    float loop = (N.movedPos.copy().sub(movedPos.copy())).mult(0.7).mag();
    float x = bezierPoint(movedPos.x, mid.x-0.5*cos(angle+HALF_PI)*loop, mid.x-0.3*cos(angle+HALF_PI)*loop, N.movedPos.x, step);
    float y = bezierPoint(movedPos.y, mid.y-0.5*sin(angle+HALF_PI)*loop, mid.y-0.3*sin(angle+HALF_PI)*loop, N.movedPos.y, step);
    return new PVector(x, y);
  }

  ////////////////////////////////////////////////////////////////////////////////////////////////
  PVector moveOnLine(Node N, float step) {
    float x= movedPos.x+(N.movedPos.x-movedPos.x)*step;
    float y= movedPos.y+(N.movedPos.y-movedPos.y)*step;
    return new PVector(x, y);
  }

  void interact() {
    hovered=false;
    if (pos.dist(mousePos)<20) {
      hovered=true;
    }
    hoveredLine=-1;
    for (int i=textPos.size()-1; i>=0; i--) {
      PVector p= textPos.get(i);
      if (abs(p.copy().sub(transOffset).x-mousePos.x)<5+0.5*textWidth(conditions.get(i))) {
        if (abs(p.copy().sub(transOffset).y-mousePos.y)<15) {
          hoveredLine=i;
        }
      }
    }
  }
}
