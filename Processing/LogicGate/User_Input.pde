void mouseDragged() {
  if (mouseButton==RIGHT) {
    float dx=mouseX-pmouseX;
    float dy=mouseY-pmouseY;

    globalPanOffset.add(dx/scale, dy/scale);
  }
}

void mouseWheel(MouseEvent e) {
  scale*= 1-0.2/e.getCount();
}


Connector currentlySelected;
void mousePressed() {

  //Move
  if (mouseButton==CENTER) {
    for (UTILITY U : Utility) {
      if (U.pos.copy().add(globalPanOffset).dist(mouse)<25) {
        if (globalSelected ) {
          if (U.selected) {
            U.selected=false;
            globalSelected=false;
          }
        } else {
          if (!globalSelected ) {
            U.selected=true;
            globalSelected=true;
          }
        }
        return;
      }
    }
  }

  //Connector
  if (mouseButton==LEFT) {
    for (UTILITY U : Utility) {
      if (U.pos.copy().add(globalPanOffset).dist(mouse)<25) {
        for (Connector C : U.Connectors) {
          if (C.pos.copy().add(globalPanOffset).add(U.pos).dist(mouse)<5) {
            if (globalDrawSelected ) {
              if (C.selected) {
                C.selected=false;
                globalDrawSelected=false;
              } else {
                C.connected.add(currentlySelected); 
                currentlySelected.connected.add(C);
                currentlySelected.selected=false;
                globalDrawSelected=false;
                for (UTILITY O : Utility) {
                  O.WireUpdate(currentlySelected, currentlySelected.state);
                }
                updateNetwork();
              }
            } else {
              currentlySelected=C;
              C.selected=true;
              globalDrawSelected=true;
            }
            return;
          }
        }
      }
    }
  }

  //Button
  if (mouseButton==LEFT) {
    if (!globalDrawSelected && !globalSelected) {
      for (UTILITY U : Utility) {
        if (insideSquare(U.pos.copy().add(globalPanOffset), 10, mouse)) {
          if (insideSquare(U.pos.copy().add(globalPanOffset), 8, mouse)) {
            if (U.BUTTON !=null ) {
              U.BUTTON.state=!U.BUTTON.state;
              U.WireUpdate(U.Connectors.get(0), U.BUTTON.state^U.invert[0]);
              if (U.BUTTON.Flanke) {
                U.BUTTON.state=false;
                U.WireUpdate(U.Connectors.get(0), U.BUTTON.state^U.invert[0]);
              }
              updateNetwork();
              return;
            }
          } else {
            if (!globalHighlighted) {
              U.highlighted=true;
              globalHighlighted=true;
            } else {
              if (U.highlighted) {
                U.highlighted=false;
                globalHighlighted=false;
              }
            }
            return;
          }
        } else {
          if (U.highlighted) {
            U.highlighted=false;
            globalHighlighted=false;
          }
        }
      }
    }
  }

  //Remove
  if (mouseButton==RIGHT) {
    if (!globalDrawSelected && !globalSelected) {
      for (int i=0; i<Utility.size(); i++) {
        UTILITY U = Utility.get(i);
        if (U.highlighted==false) {
          if (U.pos.copy().add(globalPanOffset).dist(mouse)<10) {         
            for (Connector C : U.Connectors) {
              for (Connector O : C.connected) {             
                for (Connector K : O.U.Connectors) {
                  K.connected.remove(C);
                }
              }
            }
            Utility.remove(U);
          }
        }

        for (int k=U.Connectors.size()-1; k>=0; k--) {
          Connector c = U.Connectors.get(k);
          for (int l=c.connected.size()-1; l>=0; l--) {
            Connector o = c.connected.get(l);
            float x1=c.U.pos.x+c.pos.x+globalPanOffset.x-mouse.x;
            float x2=o.U.pos.x+o.pos.x+globalPanOffset.x-mouse.x;
            float y1=c.U.pos.y+c.pos.y+globalPanOffset.y-mouse.y;
            float y2=o.U.pos.y+o.pos.y+globalPanOffset.y-mouse.y;
            if ((-1>=min(x1, x2) && -1<=max(x1, x2))) {
              float dr=sqrt(sq(x1-x2)+sq(y1-y2));
              float D=x1*y2-x2*y1;
              if (sq(2)*sq(dr)-sq(D)>0) {
                c.connected.remove(o);
                o.connected.remove(c);
                return;
              }
            }
          }
        }
      }
    }
  }
}

void mouseReleased() {
}

void keyPressed() {
  if (globalHighlighted) {
    int index=int(key)-48;
    for (UTILITY U : Utility) {
      if (U.highlighted) {
        if (U.BUTTON!=null) {
          if (key=='f') {
            U.BUTTON.Flanke =!U.BUTTON.Flanke;
          }
        }
        if (U.invert.length+1>index) {
          U.invert[index-1]=!U.invert[index-1];
          if (U.BUTTON!=null) {
            U.WireUpdate(U.Connectors.get(0), U.BUTTON.state^U.invert[0]);
            if (U.BUTTON.Flanke) {
              U.BUTTON.state=false;
              U.WireUpdate(U.Connectors.get(0), U.BUTTON.state^U.invert[0]);
            }
          }
        }
      }
    }
  }
  if (key=='n') {
    Utility.add(new UTILITY(new NOT(), mouse.copy().sub(globalPanOffset)));
  }
  if (key=='a') {
    Utility.add(new UTILITY(new AND(), mouse.copy().sub(globalPanOffset)));
  }
  if (key=='o') {
    Utility.add(new UTILITY(new OR(), mouse.copy().sub(globalPanOffset)));
  }
  if (key=='x') {
    Utility.add(new UTILITY(new XOR(), mouse.copy().sub(globalPanOffset)));
  }
  if (key=='e') {
    Utility.add(new UTILITY(new EQU(), mouse.copy().sub(globalPanOffset)));
  }
  if (key=='t') {
    Utility.add(new UTILITY(new TORCH(), mouse.copy().sub(globalPanOffset)));
  }
  if (key=='b') {
    Utility.add(new UTILITY(new BUTTON(), mouse.copy().sub(globalPanOffset)));
  }
  if (key=='A') {
    Utility.add(new UTILITY(new NAND(), mouse.copy().sub(globalPanOffset)));
  }
  if (key=='O') {
    Utility.add(new UTILITY(new NOR(), mouse.copy().sub(globalPanOffset)));
  }

  if (key=='s') {
    selectOutput("Select or create a file to write to:", "fileSelectedOUT");
  }
  if (key=='l') {
    selectInput("Select a file to load:", "fileSelectedIN");
  }
  updateNetwork();
}
