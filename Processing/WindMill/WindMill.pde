import processing.sound.*;
SoundFile KlickSound;

ArrayList <Point> Points = new ArrayList();
float cx = 300; 
float cy = 300;
int pNow=-1;
int pPrevious=-1;
float theta;

int timeSteps = 1000;
float speed = 5;
int n = 10;



void setup() {
  size(600, 600);
  KlickSound = new SoundFile(this, "Tick.mp3");
  addPoints(n);
}

void draw() {
  background(51, 60, 60);

  showLine();

  for (Point p : Points) {
    p.show();
  }

  for (int i=0; i < timeSteps; i++) {
    for (Point p : Points) {
      p.math();
      p.updateLine();
    }
    theta+=speed*(TWO_PI/frameRate/50/timeSteps);
    theta=theta % TWO_PI;
  }

  showPoint();
}


void mousePressed() {
  cx=mouseX;
  cy=mouseY;
}


void addPoints(int n) {
  for (int i=0; i < n; i++) {
    float x=random(50, width-50);
    float y=random(50, height-50);
    Points.add(new Point(x, y, i));
  }
}

void showLine() {
  pushMatrix();
  translate(cx, cy);
  rotate(theta);
  strokeWeight(1);
  line(-1000, 0, 1000, 0);
  popMatrix();
}

void showPoint() {
  fill(255, 211, 0);
  ellipse(cx, cy, 12, 12);
}
