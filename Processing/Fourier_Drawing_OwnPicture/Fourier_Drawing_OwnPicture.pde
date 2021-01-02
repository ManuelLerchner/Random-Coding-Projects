ArrayList<PVector> path=new ArrayList();
ArrayList<PVector> mousePath=new ArrayList();
boolean completedARound;
double time;
double dx;
double x, y;
int N;
Complex[] fourier;

int sampleEveryXFrames=2;

void setup() {
  size(800, 800);
}

void draw() {
  background(51);
  translate(width/2, height/2);

  showPath();
  showCircles();

  time+=dx;
  if (time>TWO_PI) {
    time=dx;
    completedARound=true;
  }
}


//////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////
void showCircles() {
  x=0;
  y=0;
  double pX=0;
  double pY=0;
  for (int i=0; i < N; i++) {
    double mag= fourier[i].mag;
    double freq= fourier[i].freq;
    double phase= fourier[i].phase;
    pX=x;
    pY=y;

    x+=mag*Math.cos(freq*time+phase);
    y+=mag*Math.sin(freq*time+phase);

    if (mag>0.5) {
      stroke(255, 30);
      noFill();
      circle((float)pX, (float)pY, 2*(float)mag);
      fill(255, 100);
      circle((float)pX, (float)pY, constrain((float)mag*0.1, 0, 10));
      stroke(255, 80);
      line((float)pX, (float)pY, (float)x, (float)y);
    }
  }
  path.add(new PVector((float)x, (float)y));
}


//////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////
void showPath() {
  noFill();
  stroke(225, 135, 120);
  beginShape();
  for (PVector p : path) {
    vertex(p.x, p.y);
  }
  endShape();
  stroke(255, 0, 0);
  beginShape();
  for (PVector p : mousePath) {
    vertex(p.x, p.y);
  }
  endShape();
}
