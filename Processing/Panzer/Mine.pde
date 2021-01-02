class Mine {
  float x, y;
  long time;
  float size;
  boolean exploded, deleted;
  float theta;



  Mine(float x_, float y_, long time_, float theta_) {
    x=x_;
    y=y_;
    time=time_;
    theta=theta_;
  }


  void show() {
    pushMatrix();
    translate(x, y);
    rotate(theta);
    strokeWeight(1);
    fill(100, 100, 60);
    rectMode(CENTER);
    rect(0, 0, 20, 20);
    popMatrix();
  }


  void explode() {
    if (millis()-time>1500 && millis()-time<1800) {
      fill(255, 0, 0);
      size+=90/(time/(millis()/10)+1);
      size=constrain(size, 0, 210);
      ellipse(x, y, size, size);
      exploded=true;
    }
  }
}
