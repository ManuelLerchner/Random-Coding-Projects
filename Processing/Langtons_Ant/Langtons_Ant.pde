int n = 100;
int dir =2;
int count;

PVector pos;
PVector temp;
boolean skip;

ArrayList<PVector> black = new ArrayList();
ArrayList<PVector> white = new ArrayList();


int steps = 0;


void setup() {
  size(800, 800, P2D);
  rectMode(CENTER);
  frameRate(500);
  pos = new PVector(floor(n/2)*width/n, floor(n/2)*width/n);

  for (int i=0; i < n; i++) {
    for (int j=0; j < n; j++) {
      PVector Start = new PVector(width/n*i, width/n*j);
      white.add(Start);
    }
  }
}

void draw() {
  background(255);


  fill(0);
  for (PVector p : black) {
    rect(p.x+width/n/2, p.y+height/n/2, width/n, height/n);
  }


  fill(255, 0, 0);
  rect(pos.x+width/n/2, pos.y+height/n/2, width/n, height/n);

  if (steps>count || steps ==0) {
    move();
  }
}



void move() {

  temp = new PVector(pos.x, pos.y);
  skip = false;


  if (white.contains(temp)) {
    black.add(temp);
    white.remove(white.indexOf(temp));
    skip=true;
    dir--;
  }


  if (black.contains(temp) && !skip) {
    white.add(temp);
    black.remove(black.indexOf(temp));
    skip=true;
    dir++;
  }


  if (dir <0) {
    dir=3;
  }
  if (dir >3) {
    dir=0;
  }


  if (!skip) {
    black.add(temp);
  }


  if (dir ==0) {
    pos.y-=width/n;
  }
  if (dir ==2) {
    pos.y+=width/n;
  }
  if (dir ==1) {
    pos.x-=width/n;
  }
  if (dir ==3) {
    pos.x+=width/n;
  }

  count++;
  println(count);
}
