float len;
PVector mousePos = new PVector();
PVector mouseGridPos = new PVector();
PVector AttackerPos = new PVector();
PVector AttackerPosN = new PVector();
PVector kingPosW = new PVector();
PVector kingPosS=new PVector() ;
PVector BauernUmwandlungData = new PVector();
PVector AttackerW = new PVector();
PVector AttackerS = new PVector();
PVector SelectedPiece = new PVector();
PVector CheatMenuPos = new PVector();

boolean playerTurn;
boolean developerMode=false;
boolean showCheatMenu=false;
boolean check = false;
boolean allowMove=true;
boolean showPopUp = false;
boolean kingSelected = false;
boolean attackedFromRight = false;
boolean attackedFromLeft = false;
boolean attackedFromTop = false;
boolean attackedFromBottom = false;
boolean attackedFromRight2 = false;
boolean attackedFromLeft2 = false;
boolean attackedFromTop2 = false;
boolean attackedFromBottom2 = false;

ArrayList<Dame> Damen = new ArrayList();
ArrayList<Turm> Tuerme = new ArrayList();
ArrayList<Bauer> Bauern = new ArrayList();
ArrayList<Pferd> Pferde = new ArrayList();
ArrayList<Koenig> Koenige = new ArrayList();
ArrayList<Laeufer> Laeufer = new ArrayList();
ArrayList<PVector> Occupied = new ArrayList();
ArrayList<PVector> possibleMoves = new ArrayList();
ArrayList<PVector> possibleAttacks = new ArrayList();
ArrayList<PVector> allPossibleMoves = new ArrayList();
ArrayList<PVector> allPossibleAttacks = new ArrayList();
ArrayList<PVector> PosNotAllowedToMove = new ArrayList();
ArrayList<PVector> straightTrought = new ArrayList();
ArrayList<PVector> KingDeniedMoves = new ArrayList();
ArrayList<PVector> KingAttacksLeft = new ArrayList();
ArrayList<PVector> KingMovesLeft = new ArrayList();
ArrayList<PVector> PathToBlock = new ArrayList();

PImage BauerW, BauerS, TurmW, TurmS, PferdW, PferdS, LaeuferW, LaeuferS, DameW, DameS, KoenigW, KoenigS, Board;

///////////////////////////////////////////////////////////////////////////////

void loadImmages() {
  BauerW = loadImage("BauerW.png");
  BauerS = loadImage("BauerS.png");
  TurmW = loadImage("TurmW.png");
  TurmS = loadImage("TurmS.png");
  PferdW = loadImage("PferdW.png");
  PferdS = loadImage("PferdS.png");
  LaeuferW = loadImage("LaeuferW.png");
  LaeuferS = loadImage("LaeuferS.png");
  DameW = loadImage("DameW.png");
  DameS = loadImage("DameS.png");
  KoenigW = loadImage("KoenigW.png");
  KoenigS = loadImage("KoenigS.png");
  Board = loadImage("1Board.jpg");
}

///////////////////////////////////////////////////////////////////////////////

void SetOccupiedSpots() {
  for (Bauer B : Bauern) {
    PVector pos = changeCordinates(B.posStatic);
    Occupied.add(new PVector(pos.x, pos.y, int(B.teamN)));
  }
  for (Dame D : Damen) {
    PVector pos = changeCordinates(D.posStatic);
    Occupied.add(new PVector(pos.x, pos.y, int(D.teamN)));
  }
  for (Laeufer L : Laeufer) {
    PVector pos = changeCordinates(L.posStatic);
    Occupied.add(new PVector(pos.x, pos.y, int(L.teamN)));
  }
  for (Pferd P : Pferde) {
    PVector pos = changeCordinates(P.posStatic);
    Occupied.add(new PVector(pos.x, pos.y, int(P.teamN)));
  }
  for (Turm T : Tuerme) {
    PVector pos = changeCordinates(T.posStatic);
    Occupied.add(new PVector(pos.x, pos.y, int(T.teamN)));
  }
  for (Koenig K : Koenige) {
    PVector pos = changeCordinates(K.posStatic);
    Occupied.add(new PVector(pos.x, pos.y, int(K.teamN)));
  }
}

///////////////////////////////////////////////////////////////////////////////

void CalculatePossibleNexttMoves() {
  for (Bauer B : Bauern) {
    B.allPossibleMoves(false, B.teamN, false);
  }
  for (Dame D : Damen) {
    D.allPossibleMoves(false, D.teamN, false);
  }
  for (Laeufer L : Laeufer) {
    L.allPossibleMoves(false, L.teamN, false);
  }
  for (Pferd P : Pferde) {
    P.allPossibleMoves(false, P.teamN, false);
  }
  for (Turm T : Tuerme) {
    T.allPossibleMoves(false, T.teamN, false);
  }
  for (Koenig K : Koenige) {
    K.allPossibleMoves(false, K.teamN, false);
  }
}

///////////////////////////////////////////////////////////////////////////////

void ChessPieceFunctions() {
  //Damen
  for (int i=0; i <Damen.size(); i++) {
    if (allowMove) {
      Damen.get(i).move();
    }
    Damen.get(i).show();
  }
  //Pferde
  for (int i=0; i <Pferde.size(); i++) {
    if (allowMove) {
      Pferde.get(i).move();
    }
    Pferde.get(i).show();
  }
  //Läufer
  for (int i=0; i <Laeufer.size(); i++) {
    if (allowMove) {
      Laeufer.get(i).move();
    }
    Laeufer.get(i).show();
  }
  //Bauern
  for (int i=0; i <Bauern.size(); i++) {
    if (allowMove) {
      Bauern.get(i).move();
    }
    Bauern.get(i).show();
  }
  //Könige
  for (int i=0; i <Koenige.size(); i++) {
    if (allowMove) {
      Koenige.get(i).move();
    }
    Koenige.get(i).show();
  }
  //Türme
  for (int i=0; i <Tuerme.size(); i++) {
    if (allowMove) {
      Tuerme.get(i).move();
    }
    Tuerme.get(i).show();
  }
}

///////////////////////////////////////////////////////////////////////////////

void Board() {
  background(255);
  image(Board, width/2, height/2);
  noStroke();
  for (float i=len/2; i < width+len/2; i+=len) {
    for (float j=len/2; j < width+len/2; j+=len) {
      if ((changeCordinates(new PVector(i, j)).x+changeCordinates(new PVector(i, j)).y)%2==1 ) {
        fill(0, 60);
        rect(i, j, len, len);
      }
    }
  }
  stroke(60, 200);
  strokeWeight(2);
  for (int i=0; i < width; i+=len) {
    line(i, 0, i, height);
    line(0, i, width, i);
  }
}

///////////////////////////////////////////////////////////////////////////

void mousePos() {
  mousePos.set(new PVector(mouseX, mouseY));
  mouseGridPos.set(changeCordinates(mousePos));
}

///////////////////////////////////////////////////////////////////////////

PVector changeCordinates(PVector in) {
  if (in.x<8 && in.x>=0 && in.y<8 && in.y>=0 ) {
    return new PVector(len*(in.x+0.5), len*(in.y+0.5));
  } else {
    return new PVector(floor(map(in.x, 0, width, 0, 8)), floor(map(in.y, 0, width, 0, 8)));
  }
}

///////////////////////////////////////////////////////////////////////////

void initialize() {
  len = width/8;
  rectMode(CENTER);
  imageMode(CENTER);
  textAlign(CENTER, CENTER);
  playerTurn=false;
  chesstime = -2000; 
  for (int i=0; i < 8; i++) {
    //Bauern
    PVector posBauerA = changeCordinates(new PVector(i, 1));
    PVector posBauerB = changeCordinates(new PVector(i, 6));
    Bauern.add(new Bauer(posBauerA, 'A'));
    Bauern.add(new Bauer(posBauerB, 'B'));  
    //Türme
    if (i==0 || i==7) {
      PVector posTurmA = changeCordinates(new PVector(i, 0));
      PVector posTurmB = changeCordinates(new PVector(i, 7));
      Tuerme.add(new Turm(posTurmA, 'A'));
      Tuerme.add(new Turm(posTurmB, 'B'));
    }
    //Pferd
    if (i==1 || i==6) {
      PVector posPferdA = changeCordinates(new PVector(i, 0));
      PVector posPferdB = changeCordinates(new PVector(i, 7));
      Pferde.add(new Pferd(posPferdA, 'A'));
      Pferde.add(new Pferd(posPferdB, 'B'));
    }
    //Läufer
    if (i==2 || i==5) {
      PVector posLaeuferA = changeCordinates(new PVector(i, 0));
      PVector posLaeuferB = changeCordinates(new PVector(i, 7));
      Laeufer.add(new Laeufer(posLaeuferA, 'A'));
      Laeufer.add(new Laeufer(posLaeuferB, 'B'));
    }
    //Dame
    if (i==3) {
      PVector posDameA = changeCordinates(new PVector(i, 0));
      PVector posDameB = changeCordinates(new PVector(i, 7));
      Damen.add(new Dame(posDameA, 'A'));
      Damen.add(new Dame(posDameB, 'B'));
    }
    //Könige
    if (i==4) {
      PVector posKoenigA = changeCordinates(new PVector(i, 0));
      PVector posKoenigB = changeCordinates(new PVector(i, 7));
      Koenige.add(new Koenig(posKoenigA, 'A'));
      Koenige.add(new Koenig(posKoenigB, 'B'));
    }
  }
}

///////////////////////////////////////////////////////////////////////////////

boolean bevore;
boolean Now;
long tchange = 0;
float size = 0;
char teamCheat = 'A';

void showHud() {
  fill(0, 0, 255);
  strokeWeight(2);
  bevore = Now;
  Now = playerTurn;
  if (Now != bevore) {
    tchange=millis();
  }
  if (millis()-tchange<1000) {
    size=40+len/2*(sin((millis()-tchange)/350.0));
  }
  if (playerTurn==false) {
    fill(255, 0, 0);
    rect(width, height*(3/4.0), size, size);
  } else {
    rect(width, height/4, size, size);
  }
  strokeWeight(1);
  BauernUmWandlung(new PVector(BauernUmwandlungData.x, BauernUmwandlungData.y), boolean(int(BauernUmwandlungData.z)));


  if (showCheatMenu) {
    PVector gridPos = changeCordinates(changeCordinates(CheatMenuPos));
    float sideL=CheatMenuPos.x+10;
    float sideR=CheatMenuPos.x+100;
    float top=CheatMenuPos.y;
    int Button=-1;
    float off = 50;
    fill(255, 0, 0, 100);
    rect(gridPos.x, gridPos.y, len, len);
    fill(0, 230);
    rectMode(CORNER);
    rect(CheatMenuPos.x+10, CheatMenuPos.y-25, 100, 200);
    rect(CheatMenuPos.x-110, CheatMenuPos.y-25, 100, 200);
    rectMode(CENTER);

    for (int i=0; i < 4; i++) {
      if ((mousePos.x > sideL && mousePos.x < sideR) && (mousePos.y> top-15+i*off && mousePos.y < top+15+i*off)) {
        fill(0, 255, 0);
        rect(CheatMenuPos.x+60, i*off+CheatMenuPos.y, 80, 30);
        if (mousePressed) {
          Button = i;
          showCheatMenu=false;
        }
      }
    }

    float sideL2=CheatMenuPos.x-100;
    float sideR2=CheatMenuPos.x-10;
    for (int i=0; i < 4; i++) {
      if ((mousePos.x > sideL2 && mousePos.x < sideR2) && (mousePos.y> top-15+i*off && mousePos.y < top+15+i*off)) {
        fill(0, 255, 0);
        rect(CheatMenuPos.x-60, i*off+CheatMenuPos.y, 80, 30);
        if (flankeMaus(mousePressed)) {
          Button = 4+i;
          if (Button!=6) {
            showCheatMenu=false;
          }
        }
      }
    }

    if (flankeMaus(mousePressed)) {
      if (mouseButton==RIGHT) {
        showCheatMenu=false;
      }
    }

    if (!Occupied.contains(changeCordinates(gridPos)) && !Occupied.contains(new PVector(changeCordinates(gridPos).x, changeCordinates(gridPos).y, 1))) {
      if (Button ==0) {
        Bauern.add(new Bauer(gridPos, teamCheat));
      }
      if (Button ==1) {
        Tuerme.add(new Turm(gridPos, teamCheat));
      }
      if (Button ==2) {
        Laeufer.add(new Laeufer(gridPos, teamCheat));
      }
      if (Button ==3) {
        Damen.add(new Dame(gridPos, teamCheat));
      }
      if (Button ==4) {
        Koenige.add(new Koenig(gridPos, teamCheat));
      }
      if (Button ==5) {
        Pferde.add(new Pferd(gridPos, teamCheat));
      }
    }
    if (Button ==6) {
      if (teamCheat == 'A') {
        teamCheat = 'B';
      } else {
        teamCheat = 'A';
      }
    }
    if (Button ==7) {
      Damen.clear();
      Tuerme.clear();
      Bauern.clear();
      Pferde.clear();
      Koenige.clear();
      Laeufer.clear();
      Occupied.clear();
      possibleMoves.clear();
      possibleAttacks.clear();
      allPossibleMoves.clear();
      allPossibleAttacks.clear();
      KingDeniedMoves.clear();
      KingAttacksLeft.clear();
      KingMovesLeft.clear();
      PathToBlock.clear();
      straightTrought.clear();
      PosNotAllowedToMove.clear();
      GivenUP = false;
      check = false;
      allowMove=true;
      showPopUp = false;
      kingSelected = false;
      allowMove=true;
      developerMode=false;
      showCheatMenu=false;
    }

    if (teamCheat == 'B') {
      fill(255);
      rect(CheatMenuPos.x-50, 2*off+CheatMenuPos.y, 80, 30);
      fill(0);
    } else {
      fill(0);
      rect(CheatMenuPos.x-50, 2*off+CheatMenuPos.y, 80, 30);
      fill(255);
    }
    text("Team", CheatMenuPos.x-50, CheatMenuPos.y+2*off);
    textSize(20);
    fill(255);
    text("Bauer", CheatMenuPos.x+50, CheatMenuPos.y);
    text("Turm", CheatMenuPos.x+50, CheatMenuPos.y+off);
    text("Läufer", CheatMenuPos.x+50, CheatMenuPos.y+2*off);
    text("Queen", CheatMenuPos.x+50, CheatMenuPos.y+3*off);
    text("König", CheatMenuPos.x-50, CheatMenuPos.y);
    text("Pferd", CheatMenuPos.x-50, CheatMenuPos.y+off);
    text("Clear", CheatMenuPos.x+-50, CheatMenuPos.y+3*off);
  }
}

boolean mouseNow = false;
boolean flankeMaus(boolean in) {
  boolean mouseBevore = mouseNow;
  mouseNow = in;
  attackedFromRight = false;
  attackedFromLeft = false;
  attackedFromTop=true;
  attackedFromBottom=true;
  attackedFromRight2 = false;
  attackedFromLeft2 = false;
  attackedFromTop2=true;
  attackedFromBottom2=true;
  return (!mouseBevore && mouseNow);
}

///////////////////////////////////////////////////////////////////////////////

void setPathToBlock() {
  if (check) {
    for (PVector p : allPossibleMoves) {
      int N = int(!boolean(int(p.z))); 
      PVector PsubKingS= new PVector(kingPosS.x-p.x, kingPosS.y-p.y); 
      PVector PsubKingW= new PVector(kingPosW.x-p.x, kingPosW.y-p.y); 
      if (N==1) {

        for (float i=-180; i <= 180; i+=22.5) {     
          if (degrees(PsubKingS.heading()) == i) {
            PathToBlock.add(new PVector(p.x, p.y, N));
          }
        }
      } else {
        for (float i=-180; i <= 180; i+=22.5) {
          if (degrees(PsubKingW.heading()) == i) {
            PathToBlock.add(new PVector(p.x, p.y, N));
          }
        }
      }
    }
    if (mousePressed && !kingSelected) {
      boolean add = false;
      PVector addPos = new PVector();

      for (PVector p : PathToBlock) {
        if (possibleMoves.contains(new PVector(p.x, p.y))) {
          addPos=new PVector(p.x, p.y);
          add=true;
        }
      }
      if (!possibleAttacks.contains(new PVector(AttackerPos.x, AttackerPos.y)) && !possibleAttacks.contains(new PVector(AttackerPosN.x, AttackerPosN.y))) {
        possibleAttacks.clear();
      }
      possibleMoves.clear();

      if (!kingSelected) {
        if (add) {
          possibleMoves.add(addPos);
        }
      }
    }
  }
  if (mousePressed) {
    if (playerTurn == true) {
      if (PosNotAllowedToMove.contains(SelectedPiece)) {
        //println(SelectedPiece);
        PVector headingVectorSW = new PVector(kingPosS.x-AttackerW.x, kingPosS.y-AttackerW.y);
        for (int i = possibleMoves.size()-1; i>=0; i--) {
          PVector D = new PVector(possibleMoves.get(i).x-AttackerW.x, possibleMoves.get(i).y-AttackerW.y);
          if (degrees(D.heading())!=degrees(headingVectorSW.heading())) {
            possibleMoves.remove(i);
          }
        }
        for (int i = possibleAttacks.size()-1; i>=0; i--) {
          PVector D = new PVector(possibleAttacks.get(i).x-kingPosS.x, possibleAttacks.get(i).y-kingPosS.y);
          if (degrees(D.heading())!=180+degrees(headingVectorSW.heading()) && degrees(D.heading())+180!=degrees(headingVectorSW.heading())) {
            possibleAttacks.remove(i);
          }
        }
      }
    } else {
      if (PosNotAllowedToMove.contains(SelectedPiece)) {
        PVector headingVectorWS = new PVector(kingPosW.x-AttackerS.x, kingPosW.y-AttackerS.y);
        for (int i = possibleMoves.size()-1; i>=0; i--) {
          PVector D = new PVector(possibleMoves.get(i).x-AttackerS.x, possibleMoves.get(i).y-AttackerS.y);
          if (degrees(D.heading())!=degrees(headingVectorWS.heading())) {
            possibleMoves.remove(i);
          }
        }
        for (int i = possibleAttacks.size()-1; i>=0; i--) {
          PVector D = new PVector(possibleAttacks.get(i).x-kingPosW.x, possibleAttacks.get(i).y-kingPosW.y);
          if (degrees(D.heading())!=180+degrees(headingVectorWS.heading()) && degrees(D.heading())+180!=degrees(headingVectorWS.heading())) {
            possibleAttacks.remove(i);
          }
        }
      }
    }
  }
}

///////////////////////////////////////////////////////////////////////////////

int teamG; 
boolean bevore1; 
boolean Now1; 
long chesstime = -2000; 
boolean GivenUP = false;
void detectStates() {
  check = false; 
  for (Koenig k : Koenige) {
    for ( PVector p : allPossibleAttacks) {
      if (p.x==changeCordinates(k.pos).x && p.y==changeCordinates(k.pos).y && k.teamN !=boolean(int(p.z))) {
        fill(255, 255, 0); 
        teamG = int(p.z); 
        check=true;
      }
    }
  }
  bevore1 = Now1; 
  Now1 = check; 
  if (Now1 ==true && !bevore1==true) {
    chesstime=millis();
  }
  if (millis()-chesstime<2000) {
    textSize(200); 
    fill(0); 

    text("Check", width/2, height/2);
  }
  if (check) {
    for (Koenig K : Koenige) {
      K.allPossibleMoves(false, (K.teamN), true);
    }
    for (PVector p : KingDeniedMoves) {
      KingAttacksLeft.remove(new PVector(p.x, p.y, p.z));
    }
    if (!GivenUP && KingMovesLeft.size()==0 &&KingAttacksLeft.size()==0) {
      GiveUpButton(playerTurn);
    }
    if (GivenUP) {
      fill(0); 
      String Team;
      if (playerTurn==true) {
        Team = "White";
      } else {
        Team = "Black";
      }
      textSize(100);
      text("Check Mate", width/2, height/3);
      text(Team +"  won", width/2, 2*height/3);
      allowMove=false;
    }
  } else {
    AttackerPos.mult(0);
  }
}

///////////////////////////////////////////////////////////////////////////////

boolean now;
boolean justClicked() {
  boolean Bevore = now;
  now = mousePressed;

  if (!Bevore && now) {
    SelectedPiece.set(mouseGridPos);
    return true;
  } else {
    return false;
  }
}

///////////////////////////////////////////////////////////////////////////

boolean clickedOn(PVector pos) {
  if (mouseGridPos.equals(changeCordinates(pos))) {
    return true;
  } else {
    return false;
  }
}

///////////////////////////////////////////////////////////////////////////

boolean insideField(PVector in) {
  return (in.x>=0 && in.y>=0 && in.x<=7 && in.y<=7);
}

///////////////////////////////////////////////////////////////////////////

void showPossibleMoves() {
  if (helpEnabled) {
    for (PVector M : possibleMoves) {
      fill(0, 255, 0, 100);
      if ((M.x+M.y)%2==0) {
        fill(0, 110, 0, 160);
      }
      rect(changeCordinates(M).x, changeCordinates(M).y, len, len);
    }
    for (PVector A : possibleAttacks) {
      fill(255, 0, 0, 120);
      if ((A.x+A.y)%2==0) {
        fill(180, 0, 0, 160);
      }
      rect(changeCordinates(A).x, changeCordinates(A).y, len, len);
    }
  }
}

///////////////////////////////////////////////////////////////////////////

void keyPressed() {
  if (key == 'r') {
    Damen.clear();
    Tuerme.clear();
    Bauern.clear();
    Pferde.clear();
    Koenige.clear();
    Laeufer.clear();
    Occupied.clear();
    possibleMoves.clear();
    possibleAttacks.clear();
    allPossibleMoves.clear();
    allPossibleAttacks.clear();
    KingDeniedMoves.clear();
    KingAttacksLeft.clear();
    KingMovesLeft.clear();
    PathToBlock.clear();
    straightTrought.clear();
    PosNotAllowedToMove.clear();

    GivenUP = false;
    check = false;
    allowMove=true;
    showPopUp = false;
    kingSelected = false;
    allowMove=true;
    developerMode=false;
    showCheatMenu=false;
    initialize();
  }
  if (key == 'd') {
    developerMode=true;
  }
}

void mousePressed() {
  if (mouseButton == RIGHT && developerMode && !showCheatMenu) {
    showCheatMenu=true;
    CheatMenuPos.set(mousePos);
  }
}

///////////////////////////////////////////////////////////////////////////

void clearLists() {
  PathToBlock.clear(); 
  Occupied.clear(); 
  PathToBlock.clear(); 
  allPossibleAttacks.clear(); 
  allPossibleMoves.clear(); 
  KingDeniedMoves.clear(); 
  KingMovesLeft.clear();
  PosNotAllowedToMove.clear();
  KingAttacksLeft.clear();
}
