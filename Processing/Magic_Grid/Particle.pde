class Particle {
  float x;
  float y;
  float size;
  float r;

  Particle(float r_) {
    x= random(width);
    y=random(height);
    size = random(5, 20);
    r=r_;
  }


  void show() {
    fill(255);
    strokeWeight(0);
    stroke(255);
    ellipse(x, y, size, size);
  }


  void move() {
    x+=(noise(millis()/r)-0.5)+map(r,5,20,-0.03,0.03);
    y+=sqrt(noise(millis()/size/r))-0.5+size/4-r/300;

    if (x <-10) {
      x=width+10;
    };
    if (x >width+10) {
      x=-10;
    };
    if (y < -25) {
      y=height+25;
    };
    if (y >height+25) {
      y=-25;
      x=random(width);
      size=random(5, 20);
    };
  }


  void showlines() {
    for (Particle p : P) {
      float d= dist(x, y, p.x, p.y);

      if (d < rad && d!=0) {
        fill(map(d, 0, rad, 0, 360), 100, 100, rad-d);
        stroke(map(d, 0, rad, 0, 360), 100, 100, rad-d);
        strokeWeight(1);
        line(x, y, p.x, p.y);
      }
    }
  }
}
