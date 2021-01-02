
ArrayList<PVector> spots = new ArrayList();

ArrayList<Piece> Pieces = new ArrayList();
boolean globalSelected=false;
boolean movingPhase,skipChecking;

void setup() {
  size(600, 600);
  rectMode(CENTER);
  addPiece();
}

void draw() {
  background(51);
  translate(width/2, height/2);
  drawBoard();

  fill(255, 0, 0);
  for (PVector p : spots) {
    ellipse(p.x, p.y, 10, 10);
  }

  movingPhase=true;
  if (!skipChecking) {
    for (Piece P : Pieces) {
      if (!P.locked) {
        movingPhase=false;
      }
    }
  }
  if (movingPhase) {
    skipChecking=true;
  }

  for (Piece P : Pieces) {
    P.show();
    P.move();
  }
}


void drawBoard() {
  stroke(255);
  int k =-6;
  for (float i=-3/8.0*width; i <= 3/8.0*width; i+=width/8.0) {
    for (float j=-3/8.0*width; j <= 3/8.0*width; j+=width/8.0) {
      if (abs(i)>width/16.0 || abs(j)>width/16.0) {
        if (abs(i)==abs(j) || abs(i*j)==0) {
          if (abs(i)==abs(j)) {
            if (j<0) {
              line(i, j, i, j+abs(k)*width/8);
            }
            if (i<0) {
              line(i, j, i+abs(k)*width/8, j);
            }
          }
          if (abs(i*j)==0) {
            if (j==0) {
              if ((i<3/8.0*width && i>0) || i<-1/8.0*width) {
                line(i, j, i+width/8.0, j);
              }
            }
            if (i==0) {
              if ((j<3/8.0*width && j>0) || j<-1/8.0*width) {
                line(i, j, i, j+width/8.0);
              }
            }
          }
          if (frameCount==1) {
            spots.add(new PVector(i, j));
          }
        }
      }
    }
    k+=2;
  }
}

void addPiece() {
  float hei = height/2-30;
  boolean col =false;
  for (int j=1; j <= 2; j++) {
    for (int i=1; i <= 2; i++) {
      PVector pos = new PVector(width/10*i-width/2, hei);
      Pieces.add(new Piece(pos, col));
    }
    hei=-hei;
    col=!col;
  }
}
