class Orb {
  Node start, end;
  PVector pos, movedPos;
  boolean moving;
  float movePercentage=0;
  float speed=0.02;
  IntList pastNodes =new IntList();
  boolean Epsilon;
  int lineNumber;

  Orb(Node start) {
    this.start=start;
    this.pos=start.pos.copy();
    this.movedPos=start.pos;
  }
  Orb(Node start, IntList past) {
    this.start=start;
    this.pos=start.pos.copy();
    this.movedPos=start.pos;
    pastNodes=past;
  }
  Orb(Node start, IntList past, boolean Epsilon) {
    this.start=start;
    this.pos=start.pos.copy();
    this.movedPos=start.pos;
    pastNodes=past;
    this.Epsilon=Epsilon;
  }

  ////////////////////////////////////////////////////////////////////////////////////////////////
  void show() {
    movedPos=pos.copy().add(transOffset);
    fill(255, 0, 0);
    if (Epsilon) {
      fill(100, 200, 150);
    }
    ellipse(movedPos.x, movedPos.y, 8, 8);
  }


  ////////////////////////////////////////////////////////////////////////////////////////////////
  void move() {
    if (moving) {
      boolean loop=false;
      if (start.equals(end)) {
        loop=true;
      }
      if (!start.straighten.hasValue(lineNumber)) {
        pos=(start.moveOnBezier(end, movePercentage, loop)).sub(transOffset);
      } else {
        pos=(start.moveOnLine(end, movePercentage)).sub(transOffset);
      }
      movePercentage+=speed;

      if (movePercentage>=1) {
        end.Orbs.add(this); 
        speed=0.02;
        start=end;
        pos=end.pos.copy();
        moving=false;
        movePercentage=0;
        end.reserved=false;
        Epsilon=false;
      }
      globalMoving=true;
    }
  }

  ////////////////////////////////////////////////////////////////////////////////////////////////
  void react() {
    if (moveOrbs) {
      if (start.Orbs.size()>0) {
        boolean first=true;
        boolean moved=false;
        if (movePercentage==0) {
          for (int i = 0; i<start.outputs.size(); i++) {
            Node Target = start.outputs.get(i);
            if (StrictlyContains(start.conditions.get(i), input)) {
              moved=true;
              if (first) {
                end=Target;
                moving=true;
                pastNodes.append(start.index);
                start.Orbs=removeOrb(start.Orbs, this);
                first=false;
                lineNumber=i;
              } else {
                Orb New = new Orb(start, pastNodes.copy());
                New.end=Target;
                New.moving=true;
                New.lineNumber=i;
                Orbs.add(New);
              }
            }
          }
          if (!moved) {
            start.Orbs=removeOrb(start.Orbs, this);
            Orbs=removeOrb(Orbs, this);
          }
        }
      }
    }
  }
}

////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////
ArrayList removeOrb(ArrayList<Orb> List, Orb O) {
  for (int i=List.size()-1; i >=0; i--) {
    Orb OrbI = List.get(i);
    if (O.equals(OrbI)) {
      List.remove(i);
    }
  }
  return List;
}
////////////////////////////////////////////////////////////////////////////////////////////////
boolean StrictlyContains(String S, String testfor) {
  String[] splitted=split(S, ',');
  for (String Str : splitted) {
    if (Str.equals(testfor)) {
      return true;
    }
  }
  return false;
}

////////////////////////////////////////////////////////////////////////////////////////////////
void resetOrbs() {
  Orbs.clear();
  for (Node N : Nodes) {
    N.reserved=false;
    N.Orbs.clear(); 
    if (N.index==0) {
      Orb O = new Orb(N);
      Orbs.add(O);
      N.Orbs.add(O);
    }
  }
}
