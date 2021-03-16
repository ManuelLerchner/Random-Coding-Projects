
ArrayList<Arrow> Arrows=new ArrayList();
float scale=1;
PVector transOffset=new PVector(0, 0);

float range=20;
float stepSize=0.5;



ArrayList<EulerMethod> EulerMethods=new ArrayList();

void setup() {
  size(600, 600);
  colorMode(HSB, TWO_PI, 1, 1);


  for (float i=-range/2; i <=range/2; i+=stepSize) {
    for (float j=-range/2; j <=range/2; j+=stepSize) {
      Arrow A=new Arrow(new PVector(i, j));
      A.calcGradient();
      Arrows.add(A);
    }
  }

  for (float i=4.5; i <= 7; i+=0.25) {
    EulerMethods.add(new EulerMethod(new PVector(-7, i)));
  }



  getLineColors();
}

void draw() {

  background(0, 0, 0.25);
  translate(width/2, height/2);
  scale(scale);

  showAxis();


  for (Arrow A : Arrows) {
    A.show();
    A.drawArrow();
  }

  for ( EulerMethod E : EulerMethods) {
    for (int i=0; i < 10; i++) {
      E.update();
    }
    E.show();
  }
}
