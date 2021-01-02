//A Lerchner Ind. Production
//28.12.2019
//1250 Zeilen

/*
 LeftClick: Draw Line
 RightClick on Line: Delete Line
 Click on Bauteil: Select
 "r" rotate Selected Bauteil
 RightClick+key on Line: Make Line Reference Voltage
 Hover over Bauteil to show Stats
 */

ArrayList<Widerstand> Widerstaende = new ArrayList();
ArrayList<SpannungsQuelle> SpannungsQuellen = new ArrayList();
ArrayList<Diode> Dioden = new ArrayList();
ArrayList<Line> Lines = new ArrayList();
ArrayList<Connector> Connectors = new ArrayList();
ArrayList<Node> Nodes = new ArrayList();

boolean GlobalSelected;
boolean UpdateWires;
boolean mouseStill;
boolean draw;
String BauteilSelected="W";
boolean InputSelected;
boolean InstructionAddComponent;
boolean InstructionAddLine;
long tmovedLast;
float gridSize=20;

PVector mousePos=new PVector();
PVector HudRectSize=new PVector();
PVector HudPos=new PVector();
String HudText="";
String ErrorMessage="";
String Instruction="Type in value and hit 'Enter'.\nClick on Component Name to toggle.\n(Press 'Space')";
String ValInput="10";

CircuitTree CircuitTree=new CircuitTree();
GaussJordan GaussJordan=new GaussJordan();

void setup() {
  size(600, 600);
  textAlign(CENTER, CENTER);
  rectMode(CENTER);
}

void draw() {
  InititalFunctions();
  MainFunctions();
  MergeWires();
  CalculateSolution();
  HUD();
}

///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
void InititalFunctions() {
  background(100);
  grid();
  Connectors.clear();
  for (Line L : Lines) {
    L.AllPoints.clear();
  }
  mousePos=(new PVector(round(mouseX/gridSize), round(mouseY/gridSize))).mult(gridSize);
  mouseStill();
}

///////////////////////////////////////////////////////////////////
int WireCount;
void MergeWires() {
  if (UpdateWires) {
    WireCount=Lines.size();
  }
  //DrawDot
  fill(0, 20, 0, 100);
  stroke(0);
  for (Line LN : Lines) {
    for (Line ON : Lines) {
      if (ON.AllPoints.contains(LN.EndLine)||ON.AllPoints.contains(LN.StartLine)) {
        ellipse(LN.EndLine.x, LN.EndLine.y, 5, 5);
        ellipse(LN.StartLine.x, LN.StartLine.y, 5, 5);
      }
    }
  }
  //MergeDifferentLineSegments
  if (WireCount>=0) {
    for (int i=0; i < Lines.size(); i++) {
      for (Line LN : Lines) {
        for (Line ON : Lines) {
          if (!LN.equals(ON)) {
            if (ON.AllPoints.contains(LN.EndLine)||ON.AllPoints.contains(LN.StartLine)) {
              int minIndex=min(ON.index, LN.index);
              LN.index=minIndex;
              ON.index=minIndex;
            }
          }
        }
      }
    }
  }
  WireCount--;
}

///////////////////////////////////////////////////////////////////
boolean StopLoop=false;
void CalculateSolution() {
  if (UpdateWires) {
    UpdateWires=false;
    fill(255, 0, 0, 100);
    ellipse(width-15, 15, 10, 10);
    for (int i=0; i < 50; i++) {
      GetCircuitInformation();
      StopLoop=false;
      if (Nodes.size()>0) {
        c=0;
        while (!StopLoop) {
          GetMatrix();
          GetVector();
          CalculateSolutionVector();
        }
      }
    }
  }
}

///////////////////////////////////////////////////////////////////
void GetCircuitInformation() {
  CircuitTree.Tree.clear();
  Nodes.clear();
  int NodeCount=0;
  int maxIndex=-1;
  for (Line L : Lines) {
    if (L.index>maxIndex) {
      maxIndex=L.index;
    }
  }
  ArrayList<Connector> AlreadyAdded=new ArrayList();
  for (int i =0; i<=maxIndex; i++) {
    Nodes.add(new Node(NodeCount));
    for (Connector C : Connectors) {
      for (Line L : Lines) {
        if (L.index==i) {
          if (L.AllPoints.contains(C.pos)) {
            if (!AlreadyAdded.contains(C)) {
              AlreadyAdded.add(C);
              CircuitTree.addInformation(C.Name, C.ConnectorNum, NodeCount);
              L.inNode=NodeCount;
            }
          }
        }
      }
    }
    NodeCount++;
  }
  dealWithEdgeCases();
}

///////////////////////////////////////////////////////////////////
void dealWithEdgeCases() {
  //Remove if Shorted
  //Resistor
  for (Node N : Nodes) {
    ArrayList<String> toRemove =new ArrayList();
    for (String S : N.Connected) {
      for (int j = N.Connected.size()-1; j>=0; j--) {
        if (S.charAt(0)=='R') {
          String testfor1=S.substring(0, S.length()-1)+"P";
          String testfor2=S.substring(0, S.length()-1)+"N";
          if (j!=N.Connected.indexOf(S)) {
            if (N.Connected.get(j)==testfor1 ||N.Connected.get(j)==testfor2) {
              toRemove.add(S);
            }
          }
        }
      }
    }
    for (String S : toRemove) {
      N.Connected.remove(S);
    }
  }
  //VoltageSource
  for (Node N : Nodes) {
    ArrayList<String> toRemove =new ArrayList();
    for (String S : N.Connected) {
      for (int j = N.Connected.size()-1; j>=0; j--) {
        if (S.charAt(0)=='U') {
          if (j!=N.Connected.indexOf(S)) {
            if (N.Connected.get(j)==S) {
              toRemove.add(S);
            }
          }
        }
      }
    }
    for (String S : toRemove) {
      N.Connected.remove(S);
    }
  }
  //RemoveOneSidedConnections
  ArrayList<String> Valid = new ArrayList();
  for (Node N : Nodes) {
    for (String S : N.Connected) {
      if (S.charAt(0)=='R') {
        if (!Valid.contains(S)) {
          for (Node O : Nodes) {
            if (!N.equals(O)) {
              if (O.Connected.contains(S)) {
                if (O.Connected.size()>1&&N.Connected.size()>1) {
                  Valid.add(S);
                  break;
                }
              }
            }
          }
        }
      } else if (S.charAt(0)=='U' || S.charAt(0)=='D') {
        if (!Valid.contains(S)) {
          for (Node O : Nodes) {
            if (!N.equals(O)) {
              String testfor=S.substring(0, S.length()-1)+"P";
              for (int i=0; i < 2; i++) {
                if (O.Connected.contains(testfor)) {
                  if (O.Connected.size()>1&&N.Connected.size()>1) {
                    Valid.add(S);
                    break;
                  }
                }
                testfor=S.substring(0, S.length()-1)+"N";
              }
            }
          }
        }
      }
    }
  }
  for (Node N : Nodes) {
    for (int i =N.Connected.size()-1; i>=0; i--) {
      String S= N.Connected.get(i);
      if (!Valid.contains(S)) {
        N.Connected.remove(i);
      }
    }
  }
  //Remove empty
  for (int i = Nodes.size()-1; i>=0; i--) {
    if (Nodes.get(i).Connected.size()==0) {
      Nodes.remove(i); 
      for (int j = i; j<Nodes.size(); j++) {
        Nodes.get(j).index--;
      }
    }
  }
}

///////////////////////////////////////////////////////////////////
String[][] VariableMatrix;
void GetMatrix() {
  //Create Matrix
  VariableMatrix = new String[Nodes.size()-1][Nodes.size()-1]; 
  for (int row = 0; row < VariableMatrix.length; row++) {
    for (int column = 0; column < VariableMatrix[row].length; column++) {
      VariableMatrix[row][column]="";
    }
  }
  //FillMatrix with VariableNames
  for (int row = 0; row < VariableMatrix.length; row++) {
    for (int column = 0; column < VariableMatrix[row].length; column++) {
      //Hauptdiagoneale
      if (row==column) {
        for (Node N : Nodes) {
          if (N.index==row+1) { 
            for (String S : N.Connected) {
              if (S.charAt(0)=='R') {
                if (VariableMatrix[row][column].substring(VariableMatrix[row][column].length())!="") {
                  VariableMatrix[row][column]+="+";
                }              
                VariableMatrix[row][column]+=S;
              }
              if (S.charAt(0)=='U') {
                if (VariableMatrix[row][column].substring(VariableMatrix[row][column].length())!="") {
                  VariableMatrix[row][column]+="+";
                }              
                VariableMatrix[row][column]+=S;
              }
              if (S.charAt(0)=='D') {
                if (VariableMatrix[row][column].substring(VariableMatrix[row][column].length())!="") {
                  VariableMatrix[row][column]+="+";
                }              
                VariableMatrix[row][column]+=S;
              }
            }
          }
        }
      } else {
        for (Node N : Nodes) {
          for (Node O : Nodes) {
            if (N.index==row+1 && O.index==column+1) {
              if (!N.equals(O)) {
                for (String S : O.Connected) {
                  if (S.charAt(0)=='R') {
                    if (N.Connected.contains(S)) {
                      if (VariableMatrix[row][column].substring(VariableMatrix[row][column].length())!="") {
                        VariableMatrix[row][column]+="+";
                      }     
                      VariableMatrix[row][column]+=S;
                    }
                  }
                  if (S.charAt(0)=='U') {
                    String testfor1=S.substring(0, S.length()-1)+"P";
                    String testfor2=S.substring(0, S.length()-1)+"N";
                    if (N.Connected.contains(testfor1)||N.Connected.contains(testfor2)) {
                      if (VariableMatrix[row][column].substring(VariableMatrix[row][column].length())!="") {
                        VariableMatrix[row][column]+="+";
                      }     
                      VariableMatrix[row][column]+=S;
                    }
                  }
                  if (S.charAt(0)=='D') {
                    String testfor1=S.substring(0, S.length()-1)+"P";
                    String testfor2=S.substring(0, S.length()-1)+"N";
                    if (N.Connected.contains(testfor1)||N.Connected.contains(testfor2)) {
                      if (VariableMatrix[row][column].substring(VariableMatrix[row][column].length())!="") {
                        VariableMatrix[row][column]+="+";
                      }     
                      VariableMatrix[row][column]+=S;
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

///////////////////////////////////////////////////////////////////
String[] VariableVector;
void GetVector() {
  //CreateVector
  VariableVector = new String[Nodes.size()-1]; 
  for (int row = 0; row < VariableVector.length; row++) {
    VariableVector[row]="";
  }
  //Fill Vector with VariableNames
  for (int row = 0; row < VariableVector.length; row++) {
    for (Node N : Nodes) {
      if (N.index==row+1) { 
        for (String S : N.Connected) {
          if (S.charAt(0)=='U') {
            if (VariableVector[row].substring(VariableVector[row].length())!="") {
              VariableVector[row]+="+";
            }              
            VariableVector[row]+=S;
          }
          if (S.charAt(0)=='D') {
            if (VariableVector[row].substring(VariableVector[row].length())!="") {
              VariableVector[row]+="+";
            }              
            VariableVector[row]+=S;
          }
        }
      }
    }
  }
}

///////////////////////////////////////////////////////////////////
void CalculateSolutionVector() {
  //LeitwertMatrix
  for (Diode D : Dioden) {
    D.calcValues();
  }
  double[][] CoefficentMatrix = new double[VariableMatrix.length][VariableMatrix.length]; 
  for (int row = 0; row < VariableMatrix.length; row++) {
    for (int column = 0; column < VariableMatrix[row].length; column++) {
      for (Widerstand R : Widerstaende) {
        if (StrictlyContains(VariableMatrix[row][column], R.Name)) {
          if (row==column) {
            CoefficentMatrix[row][column]+=1/R.val;
          } else {
            CoefficentMatrix[row][column]+=-1/R.val;
          }
        }
      }
      for (SpannungsQuelle S : SpannungsQuellen) {
        if (StrictlyContains(VariableMatrix[row][column], S.NameNeg)||StrictlyContains(VariableMatrix[row][column], S.NamePos)) {
          if (row==column) {
            CoefficentMatrix[row][column]+=1/S.Ri;
          } else {
            CoefficentMatrix[row][column]+=-1/S.Ri;
          }
        }
      }
      for (Diode D : Dioden) {
        if (StrictlyContains(VariableMatrix[row][column], D.NameNeg)||StrictlyContains(VariableMatrix[row][column], D.NamePos)) {
          if (row==column) {
            CoefficentMatrix[row][column]+=D.Geq;
          } else {
            CoefficentMatrix[row][column]+=-D.Geq;
          }
        }
      }
    }
  }
  //StromVector
  double[] StromVector = new double[Nodes.size()-1];
  for (int row = 0; row < VariableVector.length; row++) {
    for (SpannungsQuelle S : SpannungsQuellen) {
      if (VariableVector[row].contains(S.NamePos)) {
        StromVector[row]+=S.val/(double)S.Ri;
      }
      if (VariableVector[row].contains(S.NameNeg)) {
        StromVector[row]-=S.val/(double)S.Ri;
      }
    }
    for (Diode D : Dioden) {
      if (VariableVector[row].contains(D.NamePos)) {
        StromVector[row]-=D.Ieq;
      }
      if (VariableVector[row].contains(D.NameNeg)) {
        StromVector[row]+=D.Ieq;
      }
    }
  }

  //println("\n\n\n\n\n\n\n\n\n\nMatrix");
  //GaussJordan.printMatrix(VariableMatrix);
  //GaussJordan.printMatrix(CoefficentMatrix);
  //println("\nStrom");
  //GaussJordan.printVector(VariableVector);
  //GaussJordan.printVector(StromVector);
  //println("\nSpannung");
  //SpannungsVector
  double[] SolutionVector=GaussJordan.getSolution(CoefficentMatrix, StromVector);
  //GaussJordan.printVector(SolutionVector);

  //Passing Voltage into Nodes/Lines
  for (int n =0; n<SolutionVector.length; n++) {
    for (Node N : Nodes) {
      if (N.index==n+1) {
        N.Voltage=SolutionVector[n];
      }
    }
  }
  for (Line L : Lines) {
    for (Node N : Nodes) {
      if (L.inNode==N.index) {
        L.Voltage=N.Voltage;
      }
    }
  }


  //CalculateCurrent//CurrentDir
  for (Node N : Nodes) {
    for (Node O : Nodes) {
      if (!N.equals(O)) {
        for (String S : O.Connected) {
          if (N.Connected.contains(S)) {
            for (Widerstand W : Widerstaende) {
              if (W.Name==S) {
                W.current=Math.abs(((N.Voltage-O.Voltage)))/W.val;
                for (Connector C : Connectors) {
                  if (C.Name==S) {
                    for (Line L : Lines) {
                      if (L.AllPoints.contains(C.pos)) {
                        if (L.inNode==N.index) {
                          C.voltage=N.Voltage;
                        }
                      }
                    }
                  }
                }
              }
            }
          }
          String SN=S.substring(0, S.length()-1)+"N";
          String SP=S.substring(0, S.length()-1)+"P";
          if (N.Connected.contains(SN) || N.Connected.contains(SP)) {
            for (Diode D : Dioden) {
              if (D.NamePos==S||D.NameNeg==S) {
                double VoltageBevore=D.voltage;
                D.voltage=Math.abs(((N.Voltage-O.Voltage)));
                if (D.NameNeg==S) {
                  D.deltaV=Math.abs(D.voltage-VoltageBevore);
                }
                for (Connector C : Connectors) {
                  if (C.Name==S) {
                    for (Line L : Lines) {                                        
                      if (L.AllPoints.contains(C.pos)) {                       
                        C.voltage=N.Voltage;
                      }
                    }
                  }
                }
              }
            }
          }
          for (SpannungsQuelle Sp : SpannungsQuellen) {
            if (Sp.NameNeg==S || Sp.NamePos==S) {
              for (Connector C : Connectors) {
                if (C.Name==Sp.NameNeg || C.Name==Sp.NamePos) {
                  for (Line L : Lines) {
                    if (L.AllPoints.contains(C.pos)) {
                      if (L.inNode==N.index) {
                        C.voltage=N.Voltage;
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
  //FindCurrentDir
  for (Widerstand W : Widerstaende) {
    for (Connector C : Connectors) {
      for (Connector O : Connectors) {
        if (!O.equals(C)) {
          if (O.Name==C.Name) {
            if (W.Name==C.Name) {
              if (C.voltage>O.voltage) {
                W.morePositive=C.ConnectorNum;
              }
            }
          }
        }
      }
    }
  }
  for (Diode D : Dioden) {
    for (Connector C : Connectors) {
      for (Connector O : Connectors) {
        if (!O.equals(C)) {
          if (O.Name==D.NameNeg) {
            if (C.Name==D.NamePos) {
              if (C.voltage>O.voltage) {
                D.morePositive=C.ConnectorNum;
              } else {
                D.morePositive=O.ConnectorNum;
              }
              D.VoltageAK=D.voltage;
              if (D.morePositive==2) {
                D.VoltageAK*=-1;
              }
              D.calcValues();
            }
          }
        }
      }
    }
  }
  //CurrentSpannungsquellen
  for (SpannungsQuelle Sp : SpannungsQuellen) {
    for (Connector C : Connectors) {
      if (C.Name.charAt(0)=='U') {
        for (Connector O : Connectors) {
          if (O.Name.charAt(0)=='U') {
            if (!O.equals(C)) {
              String CN=C.Name.substring(0, C.Name.length()-1)+"N";
              String CP=C.Name.substring(0, C.Name.length()-1)+"P";
              String ON=O.Name.substring(0, O.Name.length()-1)+"N";
              String OP=O.Name.substring(0, O.Name.length()-1)+"P";
              if (ON.equals(CN) && OP.equals(CP)) {
                if (C.voltage!=0 || O.voltage!=0) {
                  if (Sp.index==Integer.parseInt(C.Name.substring(1, C.Name.length()-1))) {
                    Sp.current=(((C.voltage-O.voltage+Sp.val)))/Sp.Ri;
                  }
                }
              }
            }
          }
        }
      }
    }
  }

  StopLoop=true;
  for (Diode D : Dioden) {
    if (D.deltaV>0.005) {
      StopLoop=false;
    }
  }
  c++;
  if (c>25000) {
    StopLoop=true;
  }
  if (Dioden.size()==0) {
    StopLoop=true;
  }
}
int c;

///////////////////////////////////////////////////////////////////
void MainFunctions() {
  for (Widerstand W : Widerstaende) {
    W.show(); 
    W.move(); 
    W.AddConnector();
  }
  for (Diode D : Dioden) {
    D.show(); 
    D.move(); 
    D.AddConnector();
  }
  for (SpannungsQuelle S : SpannungsQuellen) {
    S.show(); 
    S.move(); 
    S.AddConnector();
  }
  for (Line L : Lines) {
    L.show();
    L.Interpolate();
    L.Hover();
  }
  for (Connector C : Connectors) {
    C.show();
  }
}

///////////////////////////////////////////////////////////////////
void HUD() {
  boolean show=false;
  for (Widerstand W : Widerstaende) {
    if (W.hovered) {
      show=true;
    }
  }
  for (Diode D : Dioden) {
    if (D.hovered) {
      show=true;
    }
  }
  for (Line L : Lines) {
    if (L.hovered) {
      show=true;
    }
  }  
  for (SpannungsQuelle S : SpannungsQuellen) {
    if (S.hovered) {
      show=true;
    }
  }   
  //Show
  if (show) {
    fill(50, 220);
    stroke(0);
    line(HudPos.x+0.5*HudRectSize.x, HudPos.y+0.5*HudRectSize.y, mousePos.x, mousePos.y);
    rect(HudPos.x, HudPos.y, HudRectSize.x, HudRectSize.y);
    fill(255);
    text(HudText, HudPos.x, HudPos.y);
  }
  if (ErrorMessage!="") {
    fill(50, 220);
    rect(width/2, height-30, textWidth(ErrorMessage)+5, 52);
    fill(255);
    text(ErrorMessage, width/2, height-30);

    if (keyPressed) {
      if (key==' ') {
        ErrorMessage="";
      }
    }
  }
  if (Instruction!="") {
    fill(50, 220);
    rect(20+textWidth(Instruction)/2, height-30, textWidth(Instruction)+5, 52);
    fill(255);
    text(Instruction, 20+textWidth(Instruction)/2, height-30);

    if (keyPressed) {
      if (key==' ') {
        Instruction="";
      }
    }
  }
  //Input
  fill(255);
  rect(width-60, height-30, 100, 40);
  fill(0, 125, 0, 200);
  //1
  if (InputSelected) {
    fill(125, 125, 0, 200);
  }
  rect(width-60, height-20, 100, 20);
  fill(0);
  if (BauteilSelected=="Sp") {
    text("Spa.Quelle", width-60, height-40);
    text(ValInput+"V", width-60, height-20);
  } else if (BauteilSelected=="W") {
    text("Widerstand", width-60, height-40);
    text(ValInput+"Ω", width-60, height-20);
  } else if (BauteilSelected=="D") {
    text("Diode", width-60, height-40);
    text("-", width-60, height-20);
  }
}

///////////////////////////////////////////////////////////////////
void grid() {
  stroke(120, 150); 
  for (int i=0; i < height; i+=gridSize) {
    line(0, i, width, i);
  }
  for (int i=0; i < width; i+=gridSize) {
    line(i, 0, i, height);
  }
}

///////////////////////////////////////////////////////////////////
PVector roundToGrid(PVector in) {
  PVector out=in.copy();
  out.x=gridSize*round(out.x/gridSize);
  out.y=gridSize*round(out.y/gridSize);
  return out;
}

///////////////////////////////////////////////////////////////////
boolean StrictlyContains(String S, String testfor) {
  String[] splitted=split(S, '+');
  for (String Str : splitted) {
    if (Str.equals(testfor)) {
      return true;
    }
  }
  return false;
}
