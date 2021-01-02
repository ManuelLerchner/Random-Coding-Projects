int raster = 1;
Curve [][] curves;



int timeSteps = 1000;

/////////////////
float x, y;
int r = 20;
int c;
int h;
float t;
boolean Start = false;
float col;
int time = 15;


void setup() {
  // size(800, 800,P2D);
  fullScreen(P2D);
  background(0);

  curves = new Curve[raster][raster];
  for (int i=0; i < raster; i++) {
    for (int j=0; j < raster; j++) {

      curves[i][j] = new Curve();
    }
  }

  /////////////////////////////////////
  x= random(width);
  y= random(height);
}

void draw() {

  background(10);

  for (int i=0; i < raster; i++) {
    for (int j=0; j < raster; j++) {
      curves[i][j].setX(mouseX);//+//j*15);
      curves[i][j].setY(mouseY);

      curves[i][j].addPoint();
      curves[i][j].show();
      if (mousePressed) {
        curves[i][j].reset();
      }
    }
  }




  ////////////////////////////////////////////////////



  noFill();
  strokeWeight(7);
  stroke(255);
  ellipse(x, y, 2*r, 2*r);
  
  textSize(25);
  fill(255,0,255);
  text("Highscore: " +h,50,100);

  fill(255, 0, 0);
  textSize(15);
  text(c, x-6, y+5);
  
  textSize(10);
  fill(0,255,0);
  text("t: "+round(time-t), x-15, y+45);


  if (mousePressed &&( mouseX-35< width/2 && mouseX+35>width/2)  && ( mouseY-35< height/2 && mouseY+35>height/2)) {
    for (int i=0; i < raster; i++) {
      for (int j=0; j < raster; j++) {
        curves[i][j].reset();
      }
    }
    t=0;
    c=0;
    Start = true;
  } 



  if (Start) {

    col = map(t, 0, time, 10, 255);

for(int i=0; i < timeSteps; i++){
   


    if (   ( mouseX-r-5< x && mouseX+r+5>x)  && ( mouseY-r-5< y && mouseY+r+5>y)  ) {
      x= constrain(map(randomGaussian(),-2,2,0,width),0,width);
      y= constrain(map(randomGaussian(),-2,2,0,height),0,height);
     

      c++;
    }

    if (t<time) {
      t+=1/frameRate/timeSteps;
    } else {



      if (c>h) {
        h=c;
      }

      Start = false;
    }
}
  } else {
    stroke(255, 0, 0);
    noFill();
    ellipse(width/ 2, height/2, 70, 70);
  }
}
