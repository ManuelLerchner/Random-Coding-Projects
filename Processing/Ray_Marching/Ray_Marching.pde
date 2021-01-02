ArrayList<Circle> Circles = new ArrayList();
ArrayList<Box> Boxes = new ArrayList();
float maxDist =400;

Player P1;
ChildApplet child;
int SceneSize=600;
public void settings() {
  size(SceneSize, SceneSize,P2D);
  smooth();
}

void setup() {
  rectMode(CENTER);
  P1= new Player();
  child = new ChildApplet();

  for (int i=0; i < 15; i++) {
    PVector pos = new PVector(random(width), random(height));
    float rad = random(10, 30);
    Circles.add(new Circle(pos, rad));
  }

  for (int i=0; i < 15; i++) {
    PVector pos = new PVector(random(width), random(height));
    PVector size = new PVector(random(10, 30), random(10, 30));
    Boxes.add(new Box(pos, size));
  }
}

void draw() {
  background(10);

  for (Circle c : Circles) {
    c.show();
  }
  for (Box b : Boxes) {
    b.show();
  }

  P1.see();
  P1.move();
  P1.show();
}
