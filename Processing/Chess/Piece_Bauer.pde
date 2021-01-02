class Bauer {
  PVector pos;
  PVector posStatic;
  PVector target = new PVector();
  int moveCount;
  boolean moving;
  boolean teamN;
  boolean animating;
  char team;
  boolean ableToSwap;

  Bauer(PVector pos_, char team_) {
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
      playerTurn = !playerTurn;
    }
  }


  void showText() {
    if (!moving) {
      if (team == 'A') {
        image(BauerS, pos.x, pos.y);
      } else {
        image(BauerW, pos.x, pos.y);
      }
    } else {
      if (team == 'A') {
        image(BauerS, mousePos.x, mousePos.y);
      } else {
        image(BauerW, mousePos.x, mousePos.y);
      }
    }
  }


  void allPossibleMoves(boolean active, boolean team, boolean AddToPath) {
    updatePossibleMoves(false, false, 0, new PVector(0, 1), team, true, true, moveCount, posStatic, false, active, AddToPath);
  }


  void move() {
    if ( playerTurn == teamN && clickedOn(pos) && justClicked()) {
      moving= true;
      allPossibleMoves(true, teamN, false);
    }
    if (moving) {
      showText();
      if ((possibleMoves.contains(mouseGridPos)||possibleAttacks.contains(mouseGridPos)) && !mousePressed ) {
        animating = true;
        allowMove=false;
        target.set(changeCordinates(mouseGridPos));
        posStatic=(changeCordinates(mouseGridPos));
        moveCount++;
        AttackerPosN = changeCordinates(target);
      }
      if (!mousePressed) {
        possibleMoves.clear();
        possibleAttacks.clear();
        moving = false;
      }
    }
    if (!ableToSwap && changeCordinates(pos).y == 7*int(teamN)) {
      ableToSwap=true;
      showPopUp=true;
      BauernUmwandlungData= new PVector(pos.x, pos.y, int(teamN));
    }
  }
}
