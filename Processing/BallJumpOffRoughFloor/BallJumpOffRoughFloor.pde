ArrayList<PVector> floor = new ArrayList();
ArrayList<PVector> samplePoints = new ArrayList();
ArrayList<Ball> balls = new ArrayList();

int detail = 600;
int scale = 200;
PVector grav = new PVector(0, 0.1);
float damping = 0.9;
int n = 10;

float xoff, yoff;

void setup() {
  size(800, 600);
  colorMode(HSB, 100, 100, 100);

  setBalls();
}

void draw() {
  background(0, 15, 40);
  setWalls();
  showFloor();
  showHud();

  for (int i = balls.size()-1; i>=0; i--) {
    Ball B = balls.get(i);
    B.move();
    B.collide();
    B.Shoot();
    B.show();
  }
  addBall();
}



void showFloor() {
  noFill();
  stroke(255, 0, 100);
  strokeWeight(1);
  beginShape();
  for (PVector p : samplePoints) {
    vertex(p.x, p.y);
  }
  endShape();
}

void showHud() {
  fill(0, 0, 100);
  text("Damping: " +damping, width-90, height-30);
  text("#Balls: " +balls.size(), width-90, height-10);
}

void setWalls() {
  //SetWalls
  floor.clear();
  samplePoints.clear();
  float xoff=0;
  for (float i=0; i <= width; i+=width/ (float)detail) {
    PVector pos = new PVector(i, map(noise(xoff, yoff), 0, 1, height-30, height-300));
    floor.add(pos);
    xoff += 0.007;
  }

  yoff +=0.005;
  //InterPolateSamplePoints
  for (float i=0; i < width; i+=0.5) {
    int index = floor(i*detail/width);
    PVector P1 = floor.get(index);
    PVector P2 = floor.get(index+1);
    float hei =P1.y+(i-P1.x)*((P2.y-P1.y)/(P2.x-P1.x));
    samplePoints.add(new PVector(i, hei));
  }
}


void setBalls() {
  for (int i=0; i < n; i++) {
    PVector pos = new PVector((i+0.5)*width/(n), random(height/4, height/3));
    balls.add(new Ball(pos));
  }
}
