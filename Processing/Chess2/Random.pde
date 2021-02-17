void showGrid() {
  for (int file=0; file < 8; file++) {
    for (int rank=0; rank < 8; rank++) {
      fill(255);
      if ((file+rank+1)%2==0) {
        fill(150, 100, 50);
      }
      rect((file+0.5)*width/8.0, (rank+0.5)*height/8.0, width/8.0, height/8.0);
    }
  }
}

PImage BauerW, BauerS, TurmW, TurmS, PferdW, PferdS, LaeuferW, LaeuferS, DameW, DameS, KoenigW, KoenigS, BoardImage;

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
  BoardImage = loadImage("1Board.jpg");
}


PVector toPixelCoordinates(PVector in) {
  return in.copy().sub(0.5, 0.5).mult(width/8);
}

PVector toGameCoordinates(PVector in) {
  PVector temp=in.copy().div(width/8).add(1, 1);
  return  new PVector(floor(temp.x), floor(temp.y));
}

boolean insideBoard(PVector pos) {
  return (round(pos.x)>=1 && round(pos.x)<=8) && (round(pos.y)>=1 && round(pos.y)<=8);
}


void FUNNotationtoGamePos(String fen) {
  String fenBoard=fen.split(" ")[0];
  int file=0, rank=0;
  for (int i=0; i < fenBoard.length(); i++) {
    Character chr=fenBoard.charAt(i);

    if (chr=='/') {
      file=0;
      rank++;
    } else {

      if ("0123456789".indexOf(chr)>=0) {
        file+=int(chr);
      } else {
        boolean white=Character.isUpperCase(chr);

        PVector pos=new PVector(file+1, rank+1);

        Piece P=null;

        switch(Character.toLowerCase(chr)) {

        case 'k':
          P =new King(white, pos);
          break;
        case 'p':
          P =new Pawn(white, pos);
          break;
        case 'n':
          P =new Knight(white, pos);
          break;
        case 'b':
          P =new Bishop(white, pos);
          break;
        case 'r':
          P =new Rook(white, pos);
          break;
        case 'q':
          P =new Queen(white, pos);
          break;
        }

        Board.Board[file][rank]=P;

        file++;
      }
    }
  }
}
