class Piece {
  PImage image;
  boolean col;
  PVector pos=new PVector();
  boolean selected;

  PVector[] movingVector;
  boolean attackDifferently;
  PVector attackVector[];

  boolean rotate;
  boolean extendOut;
  boolean movedOnce;


  void show() {
    PVector gamePos=toPixelCoordinates(pos);
    if (!selected) {
      image(image, gamePos.x, gamePos.y);
    }
  }

  void move() {

    if (selected) {
      image(image, mouse.x, mouse.y);

      for (PVector P : LegalMoves) {
        PVector pos=toPixelCoordinates(P);
        fill(255, 0, 0, 150);
        rect(pos.x, pos.y, width/8.0, width/8.0);
      }

      for (PVector P : LegalAttacks) {
        PVector pos=toPixelCoordinates(P);
        fill(0, 255, 0, 150);
        rect(pos.x, pos.y, width/8.0, width/8.0);
      }
    }
  }


  void calcPossibilitys() {
    calcLegalMoves();
    if (attackDifferently) {
      calcLegalAttacks();
    }
  }

  ArrayList<PVector> LegalMoves=new ArrayList();
  void calcLegalMoves() {
    LegalMoves.clear();
    ArrayList<PVector> possibleDirections=new ArrayList();


    for (PVector curr : movingVector) {
      if (insideBoard(pos.copy().add(curr))) {
        Piece other= Board.getPieceAt(pos.copy().add(curr));
        if (other!=null) {
          if (this.getClass() == Pawn.class) {
            return;
          }

          if (other.col==col) {
            continue;
          } else {
            LegalMoves.add(pos.copy().add(curr));
          }
        }
        possibleDirections.add(curr);
        LegalMoves.add(pos.copy().add(curr));
      }
    }

    if (rotate) {
      for (PVector curr : movingVector) {
        for (int rotate=1; rotate < 4; rotate++) {
          PVector rotated=curr.copy().rotate(rotate*HALF_PI);

          if (insideBoard(pos.copy().add(rotated))) {

            Piece other= Board.getPieceAt(pos.copy().add(rotated));

            if (other!=null) {
              if (other.col==col) {
                continue;
              }
            }

            LegalMoves.add(pos.copy().add(rotated));
          }
        }
      }
    }


    if (extendOut && LegalMoves.size()>0) {
      for (PVector curr : possibleDirections) {
        PVector temp=curr.copy().mult(2);
        while (insideBoard(pos.copy().add(temp))) {

          Piece other= Board.getPieceAt(pos.copy().add(temp));

          if (other!=null) {
            if (other.col==col) {
              break;
            } else {
              LegalMoves.add(pos.copy().add(temp));
              break;
            }
          }

          LegalMoves.add(pos.copy().add(temp));
          temp.add(curr);
        }
      }
    }
  }

  ArrayList<PVector> LegalAttacks=new ArrayList();
  void calcLegalAttacks() {
    LegalAttacks.clear();

    for (PVector curr : attackVector) {
      if (insideBoard(pos.copy().add(curr))) {
        Piece other= Board.getPieceAt(pos.copy().add(curr));

        if (other!=null) {
          if (other.col==col) {
            continue;
          } else {
            LegalAttacks.add(pos.copy().add(curr));
            continue;
          }
        }
      }
    }
  }
}





//////////////////////////////////////////////////
//////////////////////////////////////////////////
//////////////////////////////////////////////////
class Pawn extends Piece {
  boolean white;

  Pawn(boolean white, PVector pos) {
    super.pos=pos;
    this.white=white;
    super.image=white?BauerW:BauerS;
    super.attackDifferently=true;
    super.col=white;

    super.movingVector=new PVector[]{
      new PVector(0, 1*(int(!white)*2-1)), 
      new PVector(0, 2*(int(!white)*2-1)), 
    };

    super.attackVector=new PVector[]{
      new PVector(1, 1*(int(!white)*2-1)), 
      new PVector(-1, 1*(int(!white)*2-1)), 
    };
  }

  void calcPossibilitys() {
    if (super.movedOnce) {
      super.movingVector=new PVector[]{
        new PVector(0, 1*(int(!white)*2-1)), 
      };
    }
    super.calcPossibilitys();
  }
}

//////////////////////////////////////////////////
//////////////////////////////////////////////////
//////////////////////////////////////////////////
class Knight extends Piece {


  Knight(boolean white, PVector pos) {
    super.pos=pos;
    super.image=white?PferdW:PferdS;
    super.col=white;
    super.movingVector=new PVector[]{
      new PVector(1, 2*(int(!white)*2-1)), 
      new PVector(-1, 2*(int(!white)*2-1)), 
    };
    super.rotate=true;
  }
}

//////////////////////////////////////////////////
//////////////////////////////////////////////////
//////////////////////////////////////////////////
class Bishop extends Piece {


  Bishop(boolean white, PVector pos) {
    super.pos=pos;
    super.image=white?LaeuferW:LaeuferS;
    super.col=white;
    super.movingVector=new PVector[]{
      new PVector(-1, 1), 
      new PVector(-1, -1), 
      new PVector(1, 1), 
      new PVector(1, -1), 
    };
    super.extendOut=true;
  }
}

//////////////////////////////////////////////////
//////////////////////////////////////////////////
//////////////////////////////////////////////////
class Rook extends Piece {

  Rook(boolean white, PVector pos) {
    super.pos=pos;
    super.image=white?TurmW:TurmS;
    super.col=white;
    super.movingVector=new PVector[]{
      new PVector(1, 0), 
      new PVector(-1, 0), 
      new PVector(0, 1), 
      new PVector(0, -1), 
    };
    super.extendOut=true;
  }
}

//////////////////////////////////////////////////
//////////////////////////////////////////////////
//////////////////////////////////////////////////
class Queen extends Piece {

  Queen(boolean white, PVector pos) {
    super.pos=pos;
    super.image=white?DameW:DameS;  
    super.col=white;
    super.movingVector=new PVector[]{
      new PVector(1, 0), 
      new PVector(-1, 0), 
      new PVector(0, 1), 
      new PVector(0, -1), 
      new PVector(-1, 1), 
      new PVector(-1, -1), 
      new PVector(1, 1), 
      new PVector(1, -1), 
    };
    super.extendOut=true;
  }
}

//////////////////////////////////////////////////
//////////////////////////////////////////////////
//////////////////////////////////////////////////
class King extends Piece {

  King(boolean white, PVector pos) {
    super.pos=pos;
    super.image=white?KoenigW:KoenigS;
    super.col=white;
    super.movingVector=new PVector[]{
      new PVector(1, 0), 
      new PVector(-1, 0), 
      new PVector(0, 1), 
      new PVector(0, -1), 
      new PVector(-1, 1), 
      new PVector(-1, -1), 
      new PVector(1, 1), 
      new PVector(1, -1), 
    };
  }
}
