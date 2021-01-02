class Player {
  Cell Cell;

  Player(Cell c) {
    this.Cell=c;
  }

  void move() {
    Player.Cell.end=true;
    if (frameCount%playerMovementSpeed==0) {
      if (keys.hasValue("w")) {
        Cell temp=cellAtPos(Cell.absPos.x, Cell.absPos.y-1);
        if (!temp.wall) {
          Cell.end=false;
          Cell=temp;
        }
      }
      if (keys.hasValue("a")) {
        Cell temp=cellAtPos(Cell.absPos.x-1, Cell.absPos.y);
        if (!temp.wall) {
          Cell.end=false;
          Cell=temp;
        }
      }
      if (keys.hasValue("s")) {
        Cell temp=cellAtPos(Cell.absPos.x, Cell.absPos.y+1);
        if (!temp.wall) {
          Cell.end=false;
          Cell=temp;
        }
      }
      if (keys.hasValue("d")) {
        Cell temp=cellAtPos(Cell.absPos.x+1, Cell.absPos.y);
        if (!temp.wall) {
          Cell.end=false;
          Cell=temp;
        }
      }
    }
  }
}
