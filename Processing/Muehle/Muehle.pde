
ArrayList<PVector> spots = new ArrayList();

void setup() {
  size(600, 600);
}

void draw() {
  background(51);
  translate(width/2, height/2);
  rectMode(CENTER);
  drawBoard();

  fill(255, 0, 0);
  for (PVector p : spots) {
    ellipse(p.x, p.y, 10, 10);
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
