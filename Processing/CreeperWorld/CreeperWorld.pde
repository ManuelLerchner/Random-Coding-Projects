ArrayList<Object> Buildings = new ArrayList();
ArrayList<Orb> Orbs = new ArrayList();
PVector mousePos = new PVector();
PVector camOffset = new PVector();
float scaleFactor=1;


void setup() {
  size(600, 600, P2D);
  rectMode(CENTER);
  createMap();
}

void draw() {
  background(10);
  moveCam();
  
  pushMatrix();
  translate(width/2, height/2);
  scale(scaleFactor);
  mousePos.set((mouseX-width/2)/scaleFactor, (mouseY-height/2)/scaleFactor);
  image(map, -width+camOffset.x, -height+camOffset.y);

  for (Object O : Buildings) {
    O.connect();
  }
  for (Object O : Buildings) {
    O.update();
  }
  for (int i = Orbs.size()-1; i>=0; i--) {
    Orb O = Orbs.get(i);
    O.update();
    if (O.finished) {
      Orbs.remove(i);
    }
  }


  noFill();
  ellipse(mousePos.x, mousePos.y, 200, 200);
  popMatrix();
}
