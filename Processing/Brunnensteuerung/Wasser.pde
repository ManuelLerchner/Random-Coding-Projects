class WaterParticle {
  Duese Parent;

  PVector pos;
  PVector vel;
  float rad=10;

  color col;
  boolean streamDisconected;
  long tStart;

  WaterParticle(Duese Parent, PVector posStart, PVector vel) {
    this.pos=posStart.copy();
    this.vel=vel;
    this.Parent=Parent;
    tStart=millis();
  }


  void update() {
    pos.add(vel);
    vel.add(0, 0.2); //gravity
  }


  void show() {
    fill(getCol());
    noStroke();
    ellipse(pos.x, pos.y, rad, rad);
  }


  color getCol() {
    if (Parent.ventilState==false) {
      streamDisconected=true;
    }

    if (!streamDisconected) {
      col=Parent.RGBCol;
      return col;
    } else {

      if (tStart==0) {
        tStart=millis();
      }

      float deltaT=(float)millis()-tStart;
      float t=deltaT/1000;
      float darkening=atan(t)/t;  //Smooth decay function
      return color(red(col)*darkening, green(col)*darkening, blue(col)*darkening, darkening*255);
    }
  }
}
