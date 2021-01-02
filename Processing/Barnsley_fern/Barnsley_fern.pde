float x = 0;
float y=0;
float s = 0.1;


void setup() {
  // size(700, 700);
  fullScreen();
  background(0);
  blendMode(ADD);
}

void draw() {
  for (int i=0; i < 10000; i++) {
    drawPoint();
    transformation();
  }
  if (mousePressed) {
    background(0);
  };
}
