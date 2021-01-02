void transformation() {
  float nx, ny; 
  float z = random(1);

  if (z<0.01) {
    ////1
    nx = 0;
    ny =0.18*y;
  } else if (z<0.86) {
    //2
    nx = 0.85*x + 0.04*y;
    ny = -0.04*x + 0.85*y + 1.6;
  } else if (z<0.93) {
    //3
    nx = 0.20*x - 0.26*y;
    ny = 0.23*x + 0.22*y+1.6;
  } else {
  //  //4
    nx = -0.15*x + 0.28*y;
    ny = 0.26*x + 0.24*y + 0.44;

  }

  x=nx;
  y=ny;
}


void drawPoint() {
  strokeWeight(s);
  stroke(23, 124, 18,100);
  float px = map(x, -2.1820, 2.6558, 0, width);
  float py = map(y, 0, 10, height, 0);


  point(px, py);
}
