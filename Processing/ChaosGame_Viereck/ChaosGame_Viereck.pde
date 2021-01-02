float px;
float py;
float pv;

float s = 0.1;
int rc=255;
int gc=255;
int bc=255;


void setup() {
  size(600, 600);
  //fullScreen();
  background(10);
  noFill();
  frameRate(600);
  px=width/2;
  py=height/2;
}

void draw() {



  strokeWeight(s);
  for (int i=0; i < 1000; i++) {
    stroke(rc, gc, bc);
    point(px, py);
    NeuerPunkt();
  }
  if (mousePressed) {
    background(10);
  }
}
