class Pferd {
  PVector pos;
  PVector posStatic;
  PVector target = new PVector();
  boolean moving;
  boolean teamN;
  boolean animating;
  char team;


  Pferd(PVector pos_, char team_) {
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
        image(PferdS, pos.x, pos.y);
      } else {
        image(PferdW, pos.x, pos.y);
      }
    } else {
      if (team == 'A') {
        image(PferdS, mousePos.x, mousePos.y);
      } else {
        image(PferdW, mousePos.x, mousePos.y);
      }
    }
  }


  void allPossibleMoves(boolean active, boolean team, boolean AddToPath) {
    updatePossibleMoves(false, false, 0, new PVector(-1, 2), team, false, false, 0, posStatic, true, active, AddToPath);
  }


  void move() {
    if ( playerTurn == teamN && clickedOn(pos) && justClicked()) {
      moving= true;
        allPossibleMoves(true, teamN, false);
      
    }
    if (moving) {
      showText();
      if ((possibleMoves.contains(mouseGridPos)||possibleAttacks.contains(mouseGridPos)) &&!mousePressed ) {
        animating = true;
        allowMove=false;
        target.set(changeCordinates(mouseGridPos));
        posStatic=(changeCordinates(mouseGridPos));
        AttackerPosN = changeCordinates(target);
      }
      if (!mousePressed) {
        possibleMoves.clear();
        possibleAttacks.clear();
        moving = false;
      }
    }
  }
}
