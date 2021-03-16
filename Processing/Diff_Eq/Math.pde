
PVector toScreenPos(PVector in) {



  float x=in.x*width/range+transOffset.x;
  float y=-in.y*width/range+transOffset.y;

  return new PVector(x, y);
}



void showAxis() {
  strokeWeight(2);
  stroke(0);
  line( transOffset.x, -height/2/scale, transOffset.x, height/2/scale);
  line( -height/2/scale, transOffset.y, height/2/scale, transOffset.y );
}



PVector functionPrime(PVector P) {

  float x=P.x;
  float y=P.y;

  float dxdt=1, dydt=0;

  //Pendulum
  dxdt=y;
  dydt= -0.3*y-2*sin(x);

  //float  dydt=y*log(y)/x;
  //float  dydt=-x/y;

  //volterra
  //dxdt=x*(0.1-0.2*y);
  //dydt= -y*(0.2-0.3*x);

  //dydt=x*x/(1-y*y);
  
 // dxdt=1;
  //dydt=2*abs(y)/y*sqrt(abs(y)/y);
  return new PVector(dxdt, dydt);
}


void getLineColors() {
  int n=EulerMethods.size();

  for (int i=0; i < n; i++) {
    float hue=map(i, 0, n, 0, TWO_PI);
    EulerMethods.get(i).hue=hue;
  }
}
