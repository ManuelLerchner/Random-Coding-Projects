




ArrayList<Object> Objects=new ArrayList();

PVector mouse=new PVector();

Player P1;
ChildApplet child;  

int SceneSize=600;

void settings() {
  size(SceneSize, SceneSize);
}

void setup() {

  rectMode(CENTER);

  P1= new Player();
  child = new ChildApplet();


  Objects.add(new Circle(new PVector(100, 340), 40, new Color(0.8, 0.1, 0.2, 1)));
  Objects.add(new Circle(new PVector(300, 540), 40, new Color(0.3, 0.8, 0.5, 0.8)));

  Objects.add(new Circle(new PVector(350, 540), 20, new Color(0.3, 0.4, 0.8, 0.8)));
  Objects.add(new Circle(new PVector(350, 540), 30, new Color(0.3, 0.4, 1, 0.9)));

  Objects.add(new Square(new PVector(600, 440), 40, new Color(1, 1, 0, 0.2)));
}

void draw() {

  background(51);
  mouse.set(mouseX, mouseY);


  P1.show();
  P1.move();
  P1.see();



  for (Object O : Objects) {
    O.show();
  }
}


void mousePressed() {

  for (Object O : Objects) {
    O.interact();
  }
}
