//******************************************************************************//
//******************************************************************************//
void Grid() {
  stroke(51, 100);
  strokeWeight(3);
  line(0, 0, width, 0);
  strokeWeight(1);
  //Grid;
  for (float i=0; i<=width; i+=len) {
    line(i, 0, i, height);
  }
  for (float i=0; i<=height; i+=len) {
    line(0, i, width, i);
  }
}

//////////////////////////////////////////////////////////////////////////////////
void rotateBauteil(Bauteil B, PVector pos) {
  translate(pos.x, pos.y);
  rotate(B.rotation);
}

//******************************************************************************//
//******************************************************************************//
void updateLines() {

  //MergeDifferentLineSegments
  for (int i=0; i < Lines.size(); i++) {
    for (Line L : Lines) {
      for (Line O : Lines) {
        if (!L.equals(O)) {
          if (O.segments.contains(L.endPos)||O.segments.contains(L.startPos)) {
            int minIndex=min(O.index, L.index);
            L.index=minIndex;
            O.index=minIndex;
          }
        }
      }
    }
  }

  //Create Segments
  Nodes.clear();
  for (Bauteil B : Bauteile) {
    for (Connector C : B.Connectors) {
      C.inNode=null;
    }
  }
  for (Line L : Lines) {
    for (Bauteil B : Bauteile) {
      for (Connector C : B.Connectors) {
        if (L.segments.contains(C.absPos)) {
          boolean addetToNode=false;
          for (Node N : Nodes) {
            if (N.lineNum==L.index) {
              N.Connectors.add(C);
              C.inNode=N;
              addetToNode=true;
            }
          }
          if (!addetToNode) {
            Node N=new Node(L.index, C);
            Nodes.add(N);
            C.inNode=N;
          }
        }
      }
    }
  }

  //Remove shortet Bauteile
  for (Node N : Nodes) {
    ArrayList<Bauteil> inBauteil=new ArrayList();
    for (int i=N.Connectors.size()-1; i >=0; i--) {
      if (i<N.Connectors.size()) {
        Connector C=N.Connectors.get(i);
        if (!inBauteil.contains(C.B)) {
          inBauteil.add(C.B);
        } else {
          for (Connector K : C.B.Connectors) {
            N.Connectors.remove(K);
          }
        }
      }
    }
  }

  //Remove one sided Connections
  ArrayList<Bauteil> valid=new ArrayList();
  for (Node N : Nodes) {
    for (Node O : Nodes) {
      if (!N.equals(O)) {
        for (Connector C : N.Connectors) {
          for (Connector L : O.Connectors) {
            if (C.B.equals(L.B)) {
              valid.add(C.B);
            }
          }
        }
      }
    }
  }

  for (Node N : Nodes) {
    for (int i =N.Connectors.size()-1; i>=0; i--) {
      Connector S= N.Connectors.get(i);
      if (!valid.contains(S.B)) {
        N.Connectors.remove(i);
      }
    }
  }

  //Remove empty
  for (int i = Nodes.size()-1; i>=0; i--) {
    if (Nodes.get(i).Connectors.size()==0) {
      Nodes.remove(i); 
      for (int j = i; j<Nodes.size(); j++) {
        Nodes.get(j).lineNum--;
      }
    }
  }

  //Remove Double Connectors
  for (int k=Nodes.size()-1; k >=0; k--) {
    Node N=Nodes.get(k);
    for (int i=N.Connectors.size()-1; i >=0; i--) {
      Connector C=N.Connectors.get(i);
      for (int j=N.Connectors.size()-1; j >=0; j--) { 
        Connector O=N.Connectors.get(j);
        if (i!=j) {
          if (C.equals(O)) {
            N.Connectors.remove(j);
          }
        }
      }
    }
  }
}


//******************************************************************************//
//******************************************************************************//
void drawLine() {
  boolean ConnectorClicked=false;
  for (Bauteil B : Bauteile) {
    for (Connector C : B.Connectors) {
      if (mousePos.equals(C.absPos)) {
        ConnectorClicked=true;
        if (!drawLine) {
          createLine();
        } else {
          endLine();
        }
      }
    }
  }
  if (!ConnectorClicked) {
    if (drawLine) {
      boolean LineClicked=false;
      for (Line L : Lines) {
        if (L.segments.contains(mousePos)) {
          LineClicked=true;
          endLine();
        }
      }
      if (!LineClicked) {
        currLine.interpolate(mousePos);
      }
    } else {
      for (int i=0; i<Lines.size(); i++) {
        Line L=Lines.get(i);
        if (L.segments.contains(mousePos)) {
          createLine();
          break;
        }
      }
    }
  }
}

//////////////////////////////////////////////////////////////////////////////////
void createLine() {
  drawLine=true;
  currLine=new Line(minIndex(), mousePos);
  currLine.selected=true;
  currLine.segments.add(mousePos);
  Lines.add(currLine);
}

//////////////////////////////////////////////////////////////////////////////////
void endLine() {
  drawLine=false;
  currLine.selected=false;
  currLine.interpolate(mousePos);
  currLine.segments.add(mousePos);
}

//////////////////////////////////////////////////////////////////////////////////
int minIndex() {
  int minIndex=0;
  while (true) {
    boolean valid =true;
    for (Line L : Lines) {
      if (L.index==minIndex) {
        valid=false;
      }
    }
    if (valid) {
      break;
    }
    minIndex++;
  }
  return minIndex;
}

//******************************************************************************//
//******************************************************************************//
void removeLine() {
  for (int i=0; i<Lines.size(); i++) {
    Line L=Lines.get(i);
    if (L.segments.contains(mousePos)) {
      if (L.index==0) {
        for (Line O : Lines) {
          if (!O.equals(L)) {
            O.index=0;
            break;
          }
        }
      }
      Lines.remove(i);
    }
  }
  //Remove doubleIndexLines
  for (Line L : Lines) {
    for (Line O : Lines) {
      if (!O.equals(L)) {
        if (O.index==L.index) {
          if (!(L.segments.contains(O.endPos)||L.segments.contains(O.startPos)||O.segments.contains(L.endPos)||O.segments.contains(L.startPos))) {
            O.index=minIndex();
          }
        }
      }
    }
  }
}

//////////////////////////////////////////////////////////////////////////////////
void removeBauteil() {
  for (int i=0; i<Bauteile.size(); i++) {
    Bauteil B=Bauteile.get(i);
    if (B.absPos.equals(mousePos)) {
      if (B.R!=null) {
        ResistorCount--;
      }
      if (B.U!=null) {
        VoltageSourceCount--;
      }
      if (B.I!=null) {
        CurrentSourceCount--;
      }
      if (B.D!=null) {
        DiodeCount--;
      }
      if (B.C!=null) {
        CapacitorCount--;
      }
      if (B.L!=null) {
        InductorCount--;
      }

      Bauteile.remove(i);
    }
  }
}

//////////////////////////////////////////////////////////////////////////////////
void transferRefferenceNode() {
  for (Line L : Lines) {
    if (L.segments.contains(mousePos)) {
      for (Line O : Lines) {
        if (O.index==0) {
          O.index=L.index;
        }
      }
      L.index=0;
    }
  }
}

//////////////////////////////////////////////////////////////////////////////////
void clickOnBauteil() {
  boolean bauteilClicked=false;
  for (Bauteil B : Bauteile) {
    if (!drawLine) {
      if (B.absPos.equals(mousePos)) {
        B.selected=! B.selected;
        bauteilClicked=true;
        break;
      }
    }
  }
  if (!bauteilClicked) {
    drawLine();
  }
}


//******************************************************************************//
//******************************************************************************//
void showTextOnHud(Complex val, String Unit) {
  String text="";

  if (abs((float)val.im)<=0.01) {
    text=nf((float)(val.re), 0, 3)+Unit;
  } else {
    text=val.toString()+Unit;
  }
  PVector pos=new PVector(mouseX, mouseY-len/2);

  HudRectSize=new PVector(textWidth(text)+5, 25);
  HudPos=pos;
  HudText=text;
}

//////////////////////////////////////////////////////////////////////////////////
void drawCurrentArrow(Bauteil B) {
  fill(0);
  stroke(0);
  if (B.L!=null) {
    fill(255);
    stroke(255);
  }
  float hLen=4;
  if (abs((float)B.Current.mag())>=0.001) {
    int swap=1;
    if (B.I==null) {
      if (B.U!=null) {
        swap*=-1;
      }
      Complex curr=B.Vacross.clone();
      if (swap*(curr.re+curr.im)>0) {
        triangle(0, hLen*1.2, -hLen, 0, hLen, 0 );
      } else {
        triangle(0, -hLen*1.2, -hLen, 0, hLen, 0 );
      }
    } else {
      if (B.Current.re<0) {
        triangle(0, hLen*1.2, -hLen, 0, hLen, 0 );
      } else {
        triangle(0, -hLen*1.2, -hLen, 0, hLen, 0 );
      }
    }
  }
}
