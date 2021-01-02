float g = 0.25;
int n = 10;

int posX =300;
int posY =300;

boolean DrawEnabled = true;

Pendulum[] P = new Pendulum[n];

void setup() {
  size(600, 600,P2D);
  colorMode(HSB, 360, 100, 100);
  textSize(18);

  for (int i=0; i < n; i++) {
    P[i] = new Pendulum(150, 25, PI/2+radians(i*0/n), 75, 25, PI+radians(i*0.005/n), i);
  }
}

void draw() {
  background(202, 15, 21);

  for (int i=0; i < n; i++) {
    P[i].show();
    if (!P[i].pause) {
      P[i].move();
    } else {
      fill(0);
      text("PAUSE", width-70, height-20);
    }
  }


  fill(0);
  text(frameRate, 50, height-20);
}
