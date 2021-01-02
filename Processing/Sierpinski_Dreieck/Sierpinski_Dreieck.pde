float px;
float py;
float s = 1;
float r;
int c =0;

Curve curves;

void setup() {
  size(600, 600);
  background(100);
  noFill();
  frameRate(100);
  curves = new Curve();

  //Startpunkt
  px = random(50, width-50);
  py = random( height-50-sqrt(3)/2*(height-100), height-50);
  while ((-1.732*px+1.05*height<py && +1.732*px-0.666*height < py && py < height-50)==false) {
    px = random(50, width-50);
    py = random( height-50-sqrt(3)/2*(width-100), height-50);
  }
}

void draw() {
  background(50);
  triangle(50, height-50, width-50, height-50, width/2, height-50-(sqrt(3)/2)*((height-100)));


  for (int i=0; i < 100; i++) {
    curves.setX(px);
    curves.setY(py);
    curves.addPoint();
    neuerPunkt();
    c++; 
  }
    curves.show();
  
  if(mousePressed){
    curves.reset();
    stroke(255,0,0);
    strokeWeight(3);
    c=0;
  }
   
   
    text("FrameRate:  " +round(frameRate) +"  Fps",50,50);
     text("Punkte:  " +c ,50,70);
  
}
