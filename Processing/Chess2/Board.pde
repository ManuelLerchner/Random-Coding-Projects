class ChessBoard {

  Piece[][] Board=new Piece[8][8];

  ChessBoard() {
  }


  Piece getPieceAt(PVector pos) {
    Piece P= Board[round(pos.x-1)][round(pos.y-1)];
    return P;
  }

  void setPieceAt(PVector pos, Piece P) {
    Board[round(pos.x-1)][round(pos.y-1)]=P;
    P.pos=pos;
    P.movedOnce=true;
  }

  void MovePiece(PVector start, PVector end) {
    Piece P=getPieceAt(start);
    setPieceAt(end, P);
    Board[round(start.x-1)][round(start.y-1)]=null;
  }
}
