//Calculates Zeros inside the Region

float lookAtX=0;
float lookAtY=0;
float scale=1;
float colorFactor = 0.01;
PVector movement=new PVector();
float startAngle;
float stepSize=0.05;

int Iter =40;


ArrayList<PVector> solutions=new ArrayList();
ArrayList<Region> BabyRegions = new ArrayList();
Region MainRegion;

void setup() {
  size(800, 800);
  colorMode(HSB, TWO_PI, 1, 1);
  rectMode(CENTER);
  MainRegion=new Region(new PVector(1, 1), 0.005);
}

void draw() {
  background(0, 0.1, 0.3);
  mousePos= mapPixeltoCoord(new PVector(mouseX-width/2, mouseY-height/2));
  BabyRegions.clear();
  solutions.clear();
  translate(width/2, height/2);
  scale(scale);

  //Background
  float step=stepSize/(scale);
  PVector Left=mapPixeltoCoord(new PVector(-width/2, -height/2));
  PVector Right=mapPixeltoCoord(new PVector(width/2, height/2));
  for (float i=Left.x; i <= Right.x; i+=step) {
    for (float j=Right.y; j <= Left.y; j+=step) {
      PVector t=  mapCoordtoPixel(new PVector(i, j));
      PVector C = col(f(new PVector(i, j)));
      fill(C.x, C.y, C.z);
      stroke(C.x, C.y, C.z);
      rect(t.x, t.y, width*step/4, height*step/4);
    }
  }

  //Search
  MainRegion.absPos=mousePos;
  MainRegion.pos=mapCoordtoPixel(mousePos);
  MainRegion.show();
  MainRegion.solveRegion();
  MainRegion.addRegions();

  //Show BabyRegions
  for (int i=0; i<BabyRegions.size(); i++) {
    Region R= BabyRegions.get(i);
    R.addRegions();
    R.show();
  }

  if (solutions.size()!=0) {
    printArray(solutions);
    println("");
  }
  Axes();
}
