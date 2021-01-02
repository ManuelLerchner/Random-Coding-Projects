class Piece {
  PVector pos;
  PVector fixPos;
  boolean white;
  boolean isSelected;
  boolean locked;
  ArrayList<PVector> allowedToMove = new ArrayList();
  int layer;

  Piece(PVector pos, boolean white) {
    this.pos=pos;
    this.fixPos=pos.copy();
    this.white=white;
  }

  void show() {
    fill(0);
    if (white) {
      fill(255);
    }
    ellipse(pos.x, pos.y, rad, rad);
    fill(0);
  }


  void move() {
    if (!locked) {
      if (isSelected) {
        pos.set(mouseX-width/2, mouseY-height/2);
        if (!movingPhase) {
          for (PVector P : spots) {
            if (P.z!=1) {
              if (dist(P.x, P.y, pos.x, pos.y)<rad/2+5) {
                pos.set(P);

                if (!mousePressed) {
                  fixPos.set(P.copy());
                  locked=true;
                  P.z=1;
                }
              }
            }
          }
        } else {
          for (PVector P : allowedToMove) {
            if (P.z!=1) {
              if (dist(P.x, P.y, pos.x, pos.y)<rad/2+5) {
                pos.set(P);

                if (!mousePressed) {
                  fixPos.set(P.copy());
                  P.z=1;
                }
              }
            }
          }
        }
      }
    }
    if (mousePressed) {
      isPieceSelected(this);
    } else {
      if (isSelected) {
        isSelected=false;
        globalSelected=false;
        if (!pos.equals(fixPos)) {
          pos.set(fixPos);
        }
      }
    }
  }
}

float rad=30;
void isPieceSelected(Piece P) {
  if (!globalSelected) {
    if (dist(P.pos.x, P.pos.y, mouseX-width/2, mouseY-height/2)<rad) {
      P.isSelected=true;
      globalSelected=true;
      if (movingPhase) {
        P.locked=false;
        for (PVector S : spots) {
          if (P.pos.x==S.x && P.pos.y==S.y) {
            S.z=0;
          }
        }
        P.allowedToMove.clear();
        for (PVector S : spots) {
          if (P.pos.x==S.x) {
            P.allowedToMove.add(S);
          }
          if (P.pos.y==S.y) {
            P.allowedToMove.add(S);
          }
        }

        for (int i = P.allowedToMove.size()-1; i>=0; i--) {
          PVector V =P.allowedToMove.get(i);
          for (int j = P.allowedToMove.size()-1; j>=0; j--) {
            PVector O =P.allowedToMove.get(j);
            if (!O.equals(V)) {
              if (!O.equals(P.fixPos)) {
                if (!V.equals(P.fixPos)) {
                  if (V.x==O.x || V.y==O.y) {
                    float d1=P.fixPos.dist(V);
                    float d2=P.fixPos.dist(O);
                    if (d1>d2) {
                      P.allowedToMove.remove(i);
                      break;
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
  }
}
