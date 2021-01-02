int n = 100;

float rad;
ArrayList<Particle> P = new ArrayList<Particle>();

void setup() {
  size(800, 800, P2D);
  colorMode(HSB, 360, 100, 100, 250);

  for (int i=0; i < n; i++) {
    P.add(new Particle(random(0, 1000)));
  }
}

void draw() {
  background(54, 20, 30);

  rad = map(mouseX, 0, width, 0, 250);

  for (Particle p : P) {
    p.showlines();
    p.move();
  }
  for (Particle p : P) {
    p.show();
  }
}
