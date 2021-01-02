class Bullet {
  float x, y, theta;
  float sx, sy;
  float psx, psy;
  float speed;
  long n;
  float col;


  Bullet(float x_, float y_, float psx_, float psy_, long n_, float theta_, float speed_, float col_) {
    x=x_;
    y=y_;
    theta=theta_;
    psx=psx_;
    psy=psy_;
    n=n_;
    col=col_;
    speed=speed_;
  }


  void show() {
    strokeWeight(1);
    pushMatrix();
    translate(x, y);
    rotate(theta);
    fill(col);
    rectMode(CORNERS);
    rect(-9, -3, 9, 3);
    popMatrix();
  }

  void move() {
    for (int i=0; i < 10; i++) {
      x+=sx/10;
      y+=sy/10;

      sx=cos(theta)*speed+psx*0.5;
      sy=sin(theta)*speed+psy*0.5;

      for (Object O : Objects) {
        if (  (x-O.x < O.w && x>O.x) &&  (y-O.y < O.h && y>O.y) ) {
          speed = 0;
          psx = 0;
          psy = 0;
        }
      }
    }
  }
}

void deleteObjects() {
  if (Bullets.size()>100) {
    Bullets.remove(0);
  }
  if (EnemieBullets.size()>200) {
    EnemieBullets.remove(0);
  }
  if (Mines.size()>3) {
    Mines.remove(0);
  }
}
