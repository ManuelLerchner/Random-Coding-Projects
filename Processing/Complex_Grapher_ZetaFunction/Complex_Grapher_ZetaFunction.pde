float step = 0.5;
float x, y, i;
float a = 0.01;
float time=0;


////////////////////////////////////////
boolean PlotDestinctValues=false;
boolean GrapherEnabled=true;

int PartialSumZetaFunction=20000;
int iterMandelBrot=100;
float timeStep=0.005;

PVector rangeX = new PVector(-1.5, 0.5);
PVector rangeY = new PVector(-1, 1);
////////////////////////////////////////

void setup() {
  size(800, 800, P2D);
  i =rangeX.x;
  colorMode(HSB, TWO_PI, 1, 1);
}

void draw() {  
  //Grapher
  if (GrapherEnabled) {
    for (float j=rangeY.x; j < rangeY.y; j+=step) {
      PVector col = new PVector();
      // PVector fun = Zeta(i, j);
      // PVector fun = f3(i, j);
      PVector fun = MandelBrot(i, j, iterMandelBrot);
      col.set(col(fun));
      x = map(i, rangeX.x, rangeX.y, 0, width);
      y = map(j, rangeY.y, rangeY.x, 0, height);
      float radX=width/abs(rangeX.x-rangeX.y)*step;
      float radY=height/abs(rangeY.x-rangeY.y)*step;
      fill(col.x, col.y, col.z);
      stroke(col.x, col.y, col.z);
      ellipse(x, y, radX, radY);
    }
    i+=step;
    if (i>rangeX.y) {
      i=rangeX.x;
      step/=2;
    }
  }



  //Plot Destinct Values
  if (PlotDestinctValues) {
    PVector col = new PVector();
    PVector fun = Zeta(0.5, time);
    col.set(col(fun));

    PVector posBevore=new PVector(x, y);
    x = map(fun.x, rangeX.x, rangeX.y, 0, width);
    y = map(fun.y, rangeY.y, rangeY.x, 0, height);

    strokeWeight(3);
    stroke(col.x, col.y, col.z);
    if (frameCount>1) {
      line(posBevore.x, posBevore.y, x, y);
    }

    float dist = dist(posBevore.x, posBevore.y, x, y);
    if (dist>6) {
      timeStep*=0.9;
    } else {
      timeStep/=0.9;
    }

    time+=timeStep;
  }


  //Kordinates
  stroke(0, 0, 0);
  strokeWeight(1);
  float lineX=map(0, rangeX.x, rangeX.y, 0, width);
  float lineY=map(0, rangeY.x, rangeY.y, height, 0);
  line(lineX, 0, lineX, height);
  line(0, lineY, width, lineY);
  noStroke();
  fill(0, 0, 0);
  ellipse(x, height, 10, 10);
  fill(0, 0, 100);
  ellipse(x+10, height, 15, 15);
  ellipse(x-10, height, 15, 15);
}


///////////////////////////////////////////////////////////////////////
////////////////////Operations/////////////////////////////////////////
///////////////////////////////////////////////////////////////////////

PVector ComplexExp(float b, float Re, float Im) {
  PVector out = new PVector();
  float theta = Im*log(b);

  out.x=cos(theta);
  out.y=sin(theta);
  out.mult(pow(b, Re));

  return out;
}

PVector ComplexMult(PVector Z1, PVector Z2) {
  PVector out = new PVector();
  float Re = Z1.x*Z2.x-Z1.y*Z2.y;
  float Im = Z1.x*Z2.y+Z1.y*Z2.x;
  out.set(Re, Im);
  return out;
}

PVector ComplexPower(PVector Z, float exp) {
  PVector out = new PVector();

  float len = pow(Z.mag(), exp);
  float angle = Z.heading()*exp;

  float Re = len*cos(angle);
  float Im = len*sin(angle);

  out.set(Re, Im);
  return out;
}

PVector Reciprocal(float Re, float Im) {
  PVector out=new PVector();

  out.x = Re/(Re*Re+Im*Im);
  out.y = -Im/(Re*Re+Im*Im);

  return out;
}



///////////////////////////////////////////////////////////////////////
//////////////////Color////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////

PVector col(PVector in) {
  PVector HSL = new PVector();
  HSL.x=in.heading();
  if (HSL.x<0) {
    HSL.x=TWO_PI+HSL.x;
  }
  HSL.y=1-pow(a, in.mag());
  HSL.z=HSL.y;

  if (Float.isNaN(in.mag())) {
    HSL.y=0;
    HSL.z=1;
  }  
  return HSL;
}



void mouseWheel(MouseEvent event) {
  PartialSumZetaFunction-= event.getCount();
  i=-1;
  step = 0.5;
  iterMandelBrot-=event.getCount();
  println("MandelBrot Iter: " +iterMandelBrot);
}
