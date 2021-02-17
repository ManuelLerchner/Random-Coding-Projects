

PVector mouse;


ChessBoard Board=new ChessBoard();

void setup() {
  size(600, 600);
  rectMode(CENTER);
  imageMode(CENTER);
  loadImmages();


  FUNNotationtoGamePos("rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1");

  //Pieces.add(new Knight(true, new PVector(1, 1)));
}

void draw() {
  background(51);
  showGrid();


  for (Piece[] Row : Board.Board) {
    for (Piece P : Row) {
      if (P!=null) {
        P.show();
        P.move();
      }
    }
  }


  mouse=new PVector(mouseX, mouseY);


  if (pieceSelected!=null) {
    PVector gamePos=toPixelCoordinates(toGameCoordinates(mouse));
    ellipse(gamePos.x, gamePos.y, 10, 10);
  }
}
