void mousePressed() {
  //SelectBauteile
  boolean globalSelBevore =GlobalSelected;
  for (Widerstand W : Widerstaende) {
    W.Select();
  }
  for (SpannungsQuelle S : SpannungsQuellen) {
    S.Select();
  }
  for (Diode D : Dioden) {
    D.Select();
  }
  if ((globalSelBevore == !GlobalSelected)|| mouseButton==RIGHT) { 
    ResetValues();
    UpdateWires=true;
  }

  if (!GlobalSelected) {
    //DrawNewLine
    boolean currAdded=false;
    for (Connector C : Connectors) {
      if (C.pos.dist(mousePos)<20 && !draw) {
        draw=true;
        UpdateWires=true;
        int minIndex=-1;
        int j=0;
        while (true) {
          boolean valid =true;
          for (Line O : Lines) {
            if (O.index==j) {
              valid=false;
            }
          }
          if (valid) {
            minIndex=j;
            break;
          }
          j++;
        }
        if (!InstructionAddLine) {
          InstructionAddLine=true;
          Instruction="Rightclick on Line to delete\nRightclick+key to swap reference Node\n(Press 'Space')";
        }
        Lines.add(new Line(C.pos, minIndex));
        currAdded=true;
      }
    }
    //Line || Delete Line
    for (int i=0; i<Lines.size(); i++) {
      Line L = Lines.get(i);
      if (L.AllPoints.contains(mousePos) && !draw) {
        if (mouseButton==RIGHT) {
          if (keyPressed) {
            for (Line O : Lines) {
              if (O.index==0) {
                O.index=L.index;
              }
            }            
            L.index=0;
            UpdateWires=true;
            break;
          } 
          if (L.index==0) {
            boolean indexZeroTaked=false;
            for (Line O : Lines) {
              if (!L.equals(O)) {
                if (O.index==0) {
                  indexZeroTaked=true;
                  break;
                }
              }
            }
            if (!indexZeroTaked) {
              int minIndex=-1;
              for (int j=1; j < 10000; j++) {                                      
                boolean valid =false;
                for (Line O : Lines) {
                  if (O.index==j) {
                    valid=true;
                  }
                }
                if (valid) {
                  minIndex=j;
                  break;
                }
              }
              for (Line T : Lines) {
                if (T.index==minIndex) {
                  T.index=0;
                }
              }
            }
          }
          Lines.remove(i);
          UpdateWires=true;
          //Deal With Same IDs after Removing a Middle line
          for (Line LN : Lines) {
            for (Line O : Lines) {
              if (!LN.equals(O)) {
                boolean overLap=false;
                for (PVector PO : O.AllPoints) {
                  if (LN.AllPoints.contains(PO)) {
                    overLap=true;
                    break;
                  }
                }
                if (!overLap) {
                  if (LN.index==O.index) {          
                    int minIndex=-1;
                    int j=0;
                    while (true) {
                      boolean valid =true;
                      for (Line O2 : Lines) {
                        if (O2.index==j) {
                          valid=false;
                        }
                      }
                      if (valid) {
                        minIndex=j;
                        break;
                      }
                      j++;
                    }
                    LN.index=minIndex;
                  }
                }
              }
            }
          }
          break;
        }
        draw=true;
        UpdateWires=true;
        Lines.add(new Line(mousePos, Lines.size()));
      }
    }
    //BreakDrawing
    if (draw) {
      if (mouseButton==RIGHT) {
        for (int i=0; i<Lines.size(); i++) {
          if (Lines.get(i).Selected) {
            Lines.remove(i);
            draw=false;
            UpdateWires=true;
          }
        }
      }
    }
    //DrawLine
    if (draw) {
      UpdateWires=true;
      for (Line L : Lines) {
        if (L.Selected) {
          if (!currAdded) {
            L.Vertex.add(L.EndLine);
            //EndOnSegment
            for (Connector C : Connectors) {
              if (C.pos.dist(L.EndLine)<20 && !C.equals(L.Vertex.get(0))) {
                draw=false;
                L.Selected=false;
              }
            }
            //EndOnLine
            for (Line O : Lines) {
              if (!L.EndLine.equals(L.StartLine)) {
                if (O.AllPoints.contains(new PVector(L.EndLine.x, L.EndLine.y))) {
                  draw=false;
                  L.Selected=false;
                }
              }
            }
          }
        }
      }
    }
  }
  //Add Bauteile
  if (!GlobalSelected) {
    if (!draw) {
      if (mouseButton==LEFT) {
        //Select Input
        InputSelected=false;
        if (abs(mouseX-(width-60))<50 && abs(mouseY-(height-20))<10) {
          InputSelected=true;
        }
        if (abs(mouseX-(width-60))<50 && abs(mouseY-(height-40))<10) {
          if (BauteilSelected=="W") {
            BauteilSelected="Sp";
          } else {
            if (BauteilSelected=="Sp") {
              BauteilSelected="D";
            } else 
            if (BauteilSelected=="D") {
              BauteilSelected="W";
            }
          }
        }
      }
      if (mouseButton==CENTER) {
        AddBauteil(mousePos);
      }
    }
  }
}


///////////////////////////////////////////////////////////////////
void keyPressed() {
  UpdateWires=true;
  if (key=='r') {
    for (Widerstand W : Widerstaende) {
      if (W.selected) {
        W.rotation+=HALF_PI;
        W.rotation=W.rotation%TWO_PI;
      }
    }
    for (SpannungsQuelle S : SpannungsQuellen) {
      if (S.selected) {
        S.rotation+=HALF_PI;
        S.rotation=S.rotation%TWO_PI;
      }
    }
    for (Diode D : Dioden) {
      if (D.selected) {
        D.rotation+=HALF_PI;
        D.rotation=D.rotation%TWO_PI;
      }
    }
  }
  if (key=='t') {
    if (BauteilSelected=="W") {
      BauteilSelected="Sp";
    } else {
      if (BauteilSelected=="Sp") {
        BauteilSelected="D";
      } else 
      if (BauteilSelected=="D") {
        BauteilSelected="W";
      }
    }
  }
  if (InputSelected) {
    String Numbers="1234567890.";
    if (Numbers.contains(str(key))) {    
      InputSelected=true;
      ValInput=ValInput+key;
    } 
    if (keyCode==8) {    
      if (ValInput.length()>0) {
        ValInput=ValInput.substring(0, ValInput.length()-1);
      }
    }
    if (keyCode==10) {
      AddBauteil(EmptySpot());
      ValInput="";
    }
  }
  //Delete
  if (key=='d') {
    for (int i=0; i<Widerstaende.size(); i++) {
      Widerstand W=Widerstaende.get(i);
      if (W.selected) {
        Widerstaende.remove(i);
        GlobalSelected=false;
      }
    }
    for (int i=0; i<SpannungsQuellen.size(); i++) {
      SpannungsQuelle S=SpannungsQuellen.get(i);
      if (S.selected) {
        SpannungsQuellen.remove(i);
        GlobalSelected=false;
      }
    }
    for (int i=0; i<Dioden.size(); i++) {
      Diode D=Dioden.get(i);
      if (D.selected) {
        Dioden.remove(i);
        GlobalSelected=false;
      }
    }
  }
  if (key==' ') {
    UpdateWires=true;
  }
}

///////////////////////////////////////////////////////////////////
void mouseStill() {
  if (!(abs(mouseX-pmouseX)==0 && abs(mouseY-pmouseY)==0)) {
    tmovedLast=millis();
  }
  mouseStill=false; 
  if (millis()-tmovedLast>500) {
    mouseStill=true;
  }
}

PVector EmptySpot() {
  for (float j=40; j < height-40; j+=40) {
    for (float i=40; i < width-40; i+=60) {
      boolean valid=true;
      PVector tryPos=new PVector(i, j);
      for (Widerstand R : Widerstaende) {
        if (R.pos.equals(tryPos)) {
          valid=false;
          break;
        }
      }
      for (Diode D : Dioden) {
        if (D.pos.equals(tryPos)) {
          valid=false;
          break;
        }
      }
      for (SpannungsQuelle R : SpannungsQuellen) {
        if (R.pos.dist(tryPos)<3*gridSize) {
          valid=false;
          break;
        }
      }
      for (Line L : Lines) {
        for (PVector P : L.AllPoints) {
          if (P.dist(tryPos)<1.5*gridSize) {
            valid=false;
            break;
          }
        }
      }
      if (valid) {
        return roundToGrid(tryPos);
      }
    }
  }
  return(new PVector(width/2, height/2));
}

///////////////////////////////////////////////////////////////////
void AddBauteil(PVector pos) {
  float val;
  try {
    val=Float.parseFloat(ValInput);
  }
  catch (NumberFormatException nfe) {
    val=-1;
  }
  if (val>0||BauteilSelected=="D") {
    if (!InstructionAddComponent) {
      InstructionAddComponent=true;
      Instruction="Select and press 'R' to rotate\nor 'D' to delete\n(Press 'Space')";
    }
    if (BauteilSelected=="Sp") {
      SpannungsQuellen.add(new SpannungsQuelle(pos, val, SpannungsQuellen.size()));
    } else if (BauteilSelected=="W") {
      Widerstaende.add(new Widerstand(pos, val, Widerstaende.size()));
    } else if (BauteilSelected=="D") {
      Dioden.add(new Diode(pos, Dioden.size()));
    }
  } else {
    if (BauteilSelected!="D") {
      ErrorMessage="Invalid Value (Press 'Space')";
    }
  }
}

void ResetValues() {
  for (Line L : Lines) {
    L.Voltage=0;
  }
  for (Node N : Nodes) {
    N.Voltage=0;
  }
  for (Widerstand W : Widerstaende) {
    W.current=0;
    W.morePositive=0;
  }
  for (SpannungsQuelle S : SpannungsQuellen) {
    S.current=0;
  }
  for (Diode D : Dioden) {
    D.voltage=0;
    D.VoltageAK=0;
    D.Id=0;
  }
}
