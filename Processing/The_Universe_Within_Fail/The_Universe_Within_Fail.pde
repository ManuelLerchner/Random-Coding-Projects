int n = 10;
float[][] Grid;
float t;

void setup() {
  size(600, 600);
  //fullScreen();


  Grid = new float[n+4][n+4];
  for (int i=0; i <= n; i++) {
    for (int j=0; j <= n; j++) {


      Grid[i][j] = random(-1, 1);
    }
  }
}

void draw() {

  background(85);


  for (float i=0; i <= width; i+=width/n) {
    for (float j=0; j <= width; j+=width/n) {
      //Grid
      //line(0, i, width, i);
      //line(i, 0, i, height);
    }
  }




  for (int i=0; i < n; i++) {
    for (int j=0; j < n; j++) {

      fill(255);

      float mx = sin(t*(Grid[i][j]+0.7))*(18+Grid[i][j]);
      float my = cos(t*(Grid[i][j]-1))*(18-Grid[i][j]);


      float px =i*width/n+width/n/2+mx;
      float  py = j*width/n+width/n/2+my;

      //text(i+j*n+1, px+10, py-5);
      //text(Grid[i][j],px+Grid[i][j]*20,py-Grid[i][j]*20);

      if (i != n-1 && j != n-1) {
        //Diag
        line(px, py, (i+1)*width/n+width/n/2+     sin(t*(Grid[i+1][j+1]+0.7))*(18+Grid[i+1][j+1]), (j+1)*width/n+width/n/2+    cos(t*(Grid[i+1][j+1]-1))*(18-Grid[i+1][j+1]));
      }
      if (i != n-1) {
        //Horizontal
        line(px, py, (i+1)*width/n+width/n/2+     sin(t*(Grid[i+1][j]+0.7))*(18+Grid[i][j+1]), (j)*width/n+width/n/2+    cos(t*(Grid[i+1][j]-1))*(18-Grid[i][j+1]));
      }
      if (j != n-1) {
        //Vertical
        line(px, py, (i)*width/n+width/n/2+     sin(t*(Grid[i][j+1]+0.7))*(18+Grid[i][j+1]), (j+1)*width/n+width/n/2+    cos(t*(Grid[i][j+1]-1))*(18-Grid[i][j+1]));
      }


      fill(dist(px, py, (i+1)*width/n+width/n/2+     sin(t*(Grid[i+1][j]+0.7))*(18+Grid[i][j+1]), (j)*width/n+width/n/2+    cos(t*(Grid[i+1][j]-1))*(18-Grid[i][j+1])));
      ellipse(px, py, dist(px, py, (i+1)*width/n+width/n/2+     sin(t*(Grid[i+1][j]+0.7))*(18+Grid[i][j+1]), (j)*width/n+width/n/2+    cos(t*(Grid[i+1][j]-1))*(18-Grid[i][j+1]))/5, dist(px, py, (i+1)*width/n+width/n/2+     sin(t*(Grid[i+1][j]+0.7))*(18+Grid[i][j+1]), (j)*width/n+width/n/2+    cos(t*(Grid[i+1][j]-1))*(18-Grid[i][j+1]))/5);
    }
  }


  t+=map(mouseX, 0, width, -0.1, 0.1);

  fill(255);
  text("t= " +int(t) +" [s]", 50, 10);
}
