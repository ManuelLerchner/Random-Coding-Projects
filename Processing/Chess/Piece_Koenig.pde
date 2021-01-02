class Koenig {
  PVector pos;
  PVector posStatic;
  PVector target = new PVector();
  boolean moving;
  boolean teamN;
  boolean animating;
  boolean rochadePossibilityL;
  boolean rochadePossibilityR;
  boolean rochade;
  char team;
  int moveCount;


  Koenig(PVector pos_, char team_ ) {
    pos=pos_;
    posStatic=pos_;
    team=team_;
    teamN = team=='A';
  }


  void show() {
    showText();
    if (!animate(animating, pos, target)) {
      animating=false;
      pos.set(target);
      kill(team, pos);
      if (!rochade) {
        playerTurn = !playerTurn;
      }
    }
  }


  void showText() {
    if (!moving) {
      if (team == 'A') {
        image(KoenigS, pos.x, pos.y);
      } else {
        image(KoenigW, pos.x, pos.y);
      }
    } else {
      if (team == 'A') {
        image(KoenigS, mousePos.x, mousePos.y);
      } else {
        image(KoenigW, mousePos.x, mousePos.y);
      }
    }
  }

  void allPossibleMoves(boolean active, boolean team, boolean AddToPath) {
    updatePossibleMoves(true, true, 1, new PVector(0, 0), team, false, false, 0, posStatic, false, active, AddToPath);
  }


  void move() {
    if ( playerTurn == teamN && clickedOn(pos) && justClicked()) {
      moving= true;
      kingSelected = true;
      allPossibleMoves(true, teamN, false);
      checkRochadePosibility();
    }
    if (moving) {
      showText();
      checkRochade();

      if (rochade && moveCount == 0) {
        if (possibleMoves.contains(mouseGridPos)||possibleAttacks.contains(mouseGridPos) && !mousePressed ) {
          carryOutRochade();
        }
      } else if ((possibleMoves.contains(mouseGridPos)||possibleAttacks.contains(mouseGridPos)) && !mousePressed ) {
        animating = true;
        allowMove=false;
        target.set(changeCordinates(mouseGridPos));
        posStatic=(changeCordinates(mouseGridPos));
        moveCount++;
      }
      if (moveCount==2) {
        rochade=false;
      }
      if (!mousePressed) {
        possibleMoves.clear();
        possibleAttacks.clear();
        moving = false;
        kingSelected=false;
      }
    }
  }


  void checkRochadePosibility() {
    if (moveCount == 0) {
      int[] TowerMoves = new int[2];
      int index = 0;
      boolean countLeft = false;
      boolean countRight = false;
      for (int k=0; k <Tuerme.size(); k++) {
        if (Tuerme.get(k).team == team) {
          TowerMoves[index]=Tuerme.get(k).moveCount;
          index++;
        }
      }
      for (int i=1; i < 4; i++) {
        if (Occupied.contains(new PVector(i, 7*int(!teamN), int(teamN)))) {
          countLeft=true;
        }
      }
      for (int i=5; i < 7; i++) {
        if (Occupied.contains(new PVector(i, 7*int(!teamN), int(teamN)))) {
          countRight=true;
        }
      }
      if (TowerMoves[0]==0) {
        if (!countLeft) {
          possibleMoves.add(new PVector(0, 7*int(!teamN)));
          rochadePossibilityL=true;
        }
      }
      if (TowerMoves[1]==0) {
        if (!countRight) {
          possibleMoves.add(new PVector(7, 7*int(!teamN)));
          rochadePossibilityR=true;
        }
      }
    }
  }


  void checkRochade() {
    if (helpEnabled && !rochade && moveCount == 0) {
      PVector TowerPos= new PVector();
      fill(255, 223, 0);
      if (rochadePossibilityL) {
        TowerPos= changeCordinates(new PVector(0, 7*int(!teamN)));
        rect(TowerPos.x, TowerPos.y, len, len);
      }
      if (rochadePossibilityR) {
        TowerPos= changeCordinates(new PVector(7, 7*int(!teamN)));
        rect(TowerPos.x, TowerPos.y, len, len);
      }
    }
    PVector Corner = new PVector(0, 7*int(!teamN));
    for (int i=0; i < 2; i++) {
      if (mouseGridPos.dist(Corner)==0 && !mousePressed && moveCount == 0) {
        rochade=true;
      }
      if (i==0) {
        Corner.set(7, 7*int(!teamN));
      }
    }
  }


  void carryOutRochade() {
    if (((possibleMoves.contains(new PVector(0, 7))||possibleMoves.contains(new PVector(7, 7))) || possibleMoves.contains(new PVector(0, 0)) || possibleMoves.contains(new PVector(7, 0)))&& !mousePressed ) {
      animating = true;
      PVector TargetKing= new PVector();
      PVector TargetTower= new PVector();
      if (mouseGridPos.x>3) {
        TargetKing.set(changeCordinates(new PVector(6, 7*int(!teamN))));
        TargetTower.set(changeCordinates(new PVector(5, 7*int(!teamN))));
      } else {
        TargetKing.set(changeCordinates(new PVector(2, 7*int(!teamN))));
        TargetTower.set(changeCordinates(new PVector(3, 7*int(!teamN))));
      }
      target.set(TargetKing);
      moveCount++;
      for (Turm t : Tuerme) {
        if (changeCordinates(t.pos).equals(mouseGridPos)) {
          t.target.set(TargetTower);
          t.animating=true;
        }
      }
    }
  }
}
