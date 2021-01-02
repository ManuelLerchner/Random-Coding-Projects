import peasy.*;
PeasyCam cam;


int n = 3;
Planet[] Planets = new Planet[n];
float G = 1;
PVector[] ppos = new PVector[n];
int[] pmass = new int[n];


void setup() {
  size(800, 800,P3D);

  cam=new PeasyCam(this,400,400,100,900);

  for (int i=0; i < n; i++) {
    ppos[i] = new PVector(random(100,width-100),100,height-100);
  }
   for (int i=0; i < n; i++) {
    pmass[i] = round(random(10,100));
  }




  for (int i=0; i < n; i++) {

    PVector pos = ppos[i];
    PVector speed = PVector.random2D();
    speed.mult(0.1);
    float mass = pmass[i];

    Planets[i] = new Planet(pos, speed, mass);
  }
}

void draw() {
  background(51);









  for (int i=0; i < n; i++) {
    Planets[i].move();
    Planets[i].show();
  }
}
