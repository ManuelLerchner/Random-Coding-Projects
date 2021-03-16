

Point[] Points=new Point[5];
Plotter Plotter=new Plotter();

PVector center=new PVector(0, 0);
float range=5;

double[] values;
void setup() {
  size(400, 400);



  Points[0]=new Point(new PVector(1, -2));
  Points[1]=new Point(new PVector(0, -1));
  Points[2]=new Point(new PVector(2, 0));
  Points[3]=new Point(new PVector(-2, 0));
  Points[4]=new Point(new PVector(3, 1));
}



void draw() {
  background(51);
  translate(width/2, height/2);



  setMatrix();
  showFunction();

  for (int i=0; i < 5; i++) {
    Points[i].update();
  }
}




void showFunction() {

  Plotter.clear();

  for (float i=-range; i < range; i+=range/5000) {

    float x=center.x+i;
    float[] val=getVal(x);


    Plotter.top.add(new PVector(x, val[0]));
    Plotter.bot.add(new PVector(x, val[1]));
  }

  Plotter.plot();
}


float[] getVal(float x) {
  float A=1;
  float B=(float)values[0];
  float C=(float)values[1];
  float D=(float)values[2];
  float E=(float)values[3];
  float F=(float)values[4];

  float radikant=sq(B*x+E)-4*C*(A*sq(x)+D*x+F);

  float first=-(B*x+E);
  float denom=2*C;


  float[] out=new float[2];
  out[0]=(first+sqrt(radikant))/denom;
  out[1]=(first-sqrt(radikant))/denom;
  return out;
}






void setMatrix() {
  double[][] Mat=new double[5][5];
  double[][] Vec=new double[5][1];

  for (int i=0; i < 5; i++) {
    Mat[i][0] = Points[i].pos.x*Points[i].pos.y;
    Mat[i][1] = Points[i].pos.y*Points[i].pos.y;
    Mat[i][2] = Points[i].pos.x;
    Mat[i][3] = Points[i].pos.y;
    Mat[i][4] = 1;
  }

  for (int i=0; i < 5; i++) {
    Vec[i][0]=-Points[i].pos.x*Points[i].pos.x;
  }

  Matrix M=new Matrix(Mat);
  Matrix V=new Matrix(Vec);
  Matrix res=M.solve(V).transpose();

  values=res.data[0];
}
