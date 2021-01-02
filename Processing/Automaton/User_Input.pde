long mPressed;
PVector mousePos=new PVector(0, 0);
////////////////////////////////////////////////////////////////////////////////////////////////
void mousePressed() {
  mPressed=millis();
  if (!programmingMode) {
    if (dist(mouseX, mouseY, width-20, height-20)<15) {
      singleInput=!singleInput;
      resetOrbs();
    }
  }
}

ArrayList<Node> Selected=new ArrayList();
////////////////////////////////////////////////////////////////////////////////////////////////
void mouseReleased() {
  if (programmingMode) {
    if (millis()-mPressed<200) {
      if (mouseButton==LEFT) {
        boolean Connecting=false;
        for (int i=Nodes.size()-1; i>=0; i--) {
          Node N = Nodes.get(i);
          if (N.hoveredLine!=-1) {
            Connecting=true;
            if (!N.straighten.hasValue(N.hoveredLine)) {
              N.straighten.append(N.hoveredLine);
            } else {
              for (int k=N.straighten.size()-1; k >=0; k--) {
                int Line =N.straighten.get(k);
                if (Line==N.hoveredLine) {
                  N.straighten.remove(k);
                }
              }
            }
          }
        }
        for (Node N : Nodes) {
          if (N.hovered) {
            Connecting=true;
            N.selected=true;
            Selected.add(N);
            N.selectTime=millis();
          }
          if (N.selected) {
            Connecting=true;
          }
        }
        if (Connecting) {
          if (Selected.size()==2) {
            Node T1= Selected.get(0);
            Node T2= Selected.get(1);
            T1.selected=false;
            T2.selected=false;
            Selected.clear();
            if (input.length()>0) {
              if (T1.selectTime<T2.selectTime) {
                T1.initialize(T2, input);
              } else {
                T2.initialize(T1, input);
              }
            }
          }
        } else {
          Node New = new Node(mousePos.copy());
          Nodes.add(New);
          if (New.index==0) {
            Orb O = new Orb(New);
            Orbs.add(O);
            New.Orbs.add(O);
          }
        }
      }
      if (mouseButton==RIGHT) {
        for (int i=Nodes.size()-1; i>=0; i--) {
          Node N = Nodes.get(i);
          if (N.hovered) {
            for (int k=N.Orbs.size()-1; k>=0; k--) {
              for (int j=Orbs.size()-1; j>=0; j--) {
                Orb Global = Orbs.get(j);
                Orb Node= Orbs.get(k);
                if (Global.equals(Node)) {
                  N.Orbs.remove(k);
                  Orbs.remove(j);
                }
              }
            }
            for (int l=Nodes.size()-1; l>=0; l--) {
              Node O = Nodes.get(l);
              if (!O.equals(N)) {
                for (int m=O.outputs.size()-1; m>=0; m--) {
                  Node M =O.outputs.get(m);
                  if (N.equals(M)) {
                    O.outputs.remove(M);
                  }
                }
              }
            }
            Nodes.remove(i);
          }
          if (N.hoveredLine!=-1) {
            N.outputs.remove(N.hoveredLine);
            N.conditions.remove(N.hoveredLine);
            for (int k=N.straighten.size()-1; k >=0; k--) {
              int Line =N.straighten.get(k);
              if (Line==N.hoveredLine) {
                N.straighten.remove(k);
              }
            }
            N.hoveredLine=-1;
          }
        }
      }
      if (mouseButton==CENTER) {
        for (int i=Nodes.size()-1; i>=0; i--) {
          Node N = Nodes.get(i);
          if (N.hovered) {
            N.acceptingNode=!N.acceptingNode;
          }
          if (N.hoveredLine!=-1) {
            N.conditions.set(N.hoveredLine, "ε");
          }
        }
      }
    }
  }
}


int cursorPos=input.length();
StringList Word=new StringList();
boolean inputSelected;
////////////////////////////////////////////////////////////////////////////////////////////////
void keyPressed() {
  if (programmingMode) {
    if (keyCode==10) {
      programmingMode=false;
    }
  } else {
    if (!singleInput) {
      resetOrbs();
    }
  }
  if (!programmingMode) {
    if (key==' ') {
      programmingMode=true;
      cursorPos=0;
      resetOrbs();
    }
  }
  inputSelected=false;
  if (keyCode==37) {
    cursorPos--;
    cursorPos=max(cursorPos, 0);
    inputSelected=true;
  }
  if (keyCode==39) {
    cursorPos++;
    cursorPos=min(cursorPos, input.length() );
    inputSelected=true;
  }
  if (keyCode==8||keyCode==127) {
    inputSelected=true;
  }
  String validChars="abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890,";
  if (validChars.contains(str(key))) {
    inputSelected=true;
  }

  if (inputSelected) {
    if (validChars.contains(str(key))) {
      String prev=input.subSequence(0, cursorPos).toString();
      String after=input.subSequence(cursorPos, input.length()).toString();
      prev=prev+key;
      cursorPos++;
      input=prev.concat(after);
    } else if (keyCode==8 || keyCode==127) {
      if (input.length()>0) {
        String prev=input.subSequence(0, cursorPos).toString();
        String after=input.subSequence(cursorPos, input.length()).toString();
        if (keyCode==8) {
          if (prev.length()>0) {
            prev=prev.substring(0, prev.length()-1);
            cursorPos--;
          }
        } else {
          if (cursorPos<input.length()) {
            after=after.substring(1, after.length());
          }
        }
        input=prev.concat(after);
      }
    }
  }

  if (keyCode==10&&singleInput) {
    if (input.length()>0) {
      inputPrev=input;
      Word.clear();
      cursorPos=0;
      StringCount=0;
      if (!OneDigitEntries) {
        String[] splitted=split(input, ',');
        for (String S : splitted) {
          Word.append(S);
        }
      } else {
        for (int i=0; i<input.length(); i++) {
          Word.append(str(input.charAt(i)));
        }
      }
      autoTest=true;
    }
  }


  if (keyCode==10&&!singleInput) {
    if (input.length()>0) {
      inputPrev=input;
      Word.clear();
      cursorPos=0;
      StringCount=0;
      if (!OneDigitEntries) {
        String[] splitted=split(input, ',');
        for (String S : splitted) {
          Word.append(S);
        }
      } else {
        for (int i=0; i<input.length(); i++) {
          Word.append(str(input.charAt(i)));
        }
      }
      autoTest=true;
      resetOrbs();
      println("\n");
    }
  }
}

////////////////////////////////////////////////////////////////////////////////////////////////
void mouseWheel(MouseEvent e) {
  scale*=1-e.getCount()/10.0;
}

////////////////////////////////////////////////////////////////////////////////////////////////
void mouseDragged() {
  transOffset.x+=(mouseX-pmouseX)/scale;
  transOffset.y+=(mouseY-pmouseY)/scale;
}
