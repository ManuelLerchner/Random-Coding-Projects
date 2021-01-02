import peasy.*;
PeasyCam cam;

ArrayList<PVector> points = new ArrayList<PVector>();

float x, y, z;
float rx, ry, rz;
float hu = 0;

float a=10;
float b=28;
float c=8.0/3.0;

float dt=0.005;



void setup() {

  size(800, 800, P3D);
  colorMode(HSB);
  smooth(2);

  cam=new PeasyCam(this, 400, 400, 0, 1200);
  cam.setMinimumDistance(80);
  cam.setMaximumDistance(5000);

  x=0.0001;
}



void draw() {

  background(0);
  translate(width/2, height/2, 0);
  scale(10);
  rotateZ(hu/100);


  for (int i=0; i < 5; i++) {

    float dx= (a*(y-x))*dt;
    float dy= (x*(b-z)-y)*dt;
    float dz= (x*y-c*z)*dt;

    x+=dx;
    y+=dy;
    z+=dz;

    points.add(new PVector(x, y, z));
    hu=0;

    beginShape();

    noFill();
    for (PVector v : points) {
      strokeWeight(0.1);
      stroke(hu, 255, 255);

      vertex(v.x, v.y, v.z);

      hu+=0.05;
      if (hu>255) {
        hu=0;
      };
    }

    if (keyPressed ) {
      if (key ==  'r') {
        points.clear();

        x=0.001;
        y=0;
        z=0;
      }
    }
    endShape();
  }
}
