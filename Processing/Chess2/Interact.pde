Piece pieceSelected=null;

void mousePressed() {
  PVector mouseGamePos=toGameCoordinates(mouse);


  Piece P=Board.getPieceAt(mouseGamePos);

  if (P!=null) { //Pick Up
    if (pieceSelected==null) {
      P.selected=true;
      pieceSelected=P;
      P.calcPossibilitys();
      return;
    }
  } 

  if (P==null) { //Drop at Empty Field
    if (pieceSelected!=null) {
      Board.MovePiece(pieceSelected.pos, toGameCoordinates(mouse));
      pieceSelected.selected=false;
      pieceSelected=null;
      return;
    }
  }

  if (P!=null) { //Drop at Same Field
    if (P.pos.equals(pieceSelected.pos)) {
      if (pieceSelected!=null) {
        pieceSelected.selected=false;
        pieceSelected=null;
        return;
      }
    }
  }

  if (P!=null) { //Attack
    if (pieceSelected!=null) {
      println("Attack");
      pieceSelected.selected=false;
      pieceSelected=null;
      return;
    }
  }
}
