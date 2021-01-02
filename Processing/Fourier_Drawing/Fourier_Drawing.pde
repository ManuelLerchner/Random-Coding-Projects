ArrayList<PVector> path=new ArrayList();
boolean completedARound;
double[][] pathData;
double time=0;
double dx;
double x, y;

int N;
Complex[] fourier;

int accuracy=1000;
int skipPathPoints=5;
float scale=1;


void setup() {
  size(800, 800);
  loadJson();

  accuracy=N;
  println("Points: "+N+ "\nmillis: "+millis());
  dx=TWO_PI/N;
  Complex[] temp=new Complex[N];
  for (int i=0; i < N; i++) {
    temp[i]=new Complex(scale*pathData[0][i], scale*pathData[1][i]);
  }
  //  N=myPathDoublePendulum.length;
  //for (int i=0; i < N; i++) {
  //  temp[i]=new Complex(scale*myPathDoublePendulum[i].x, scale*myPathDoublePendulum[i].y);
  //}


  fourier=dft(temp);
  Sort(fourier);
  println("millis: "+millis());
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
  for (int i=0; i < constrain(accuracy, 0, N); i++) {
    double mag= fourier[i].mag;
    double freq= fourier[i].freq;
    double phase= fourier[i].phase;
    pX=x;
    pY=y;

    x+=mag*Math.cos(freq*time+phase);
    y+=mag*Math.sin(freq*time+phase);

    if (mag>1) {
      stroke(255, 30);
      noFill();
      circle((float)pX, (float)pY, 2*(float)mag);
      fill(255, 100);
      circle((float)pX, (float)pY, constrain((float)mag*0.1, 0, 10));
      stroke(255, 50);
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
}
