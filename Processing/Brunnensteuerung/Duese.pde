class Duese {
  boolean ventilState;

  PVector pos;
  float diam=50;
  color RGBCol;

  Duese(PVector pos) {
    this.pos=pos;
  }


  void show() {
    RGBCol=ventilState==true?RGBCol: color(0);

    fill(RGBCol);

    stroke(1);
    rect(pos.x, pos.y, 30, 30, 5);
    rect(pos.x, height-50, 8, 100);
    
    noStroke();
    ellipse(pos.x, pos.y, diam/2, diam);
  }


  void produceWaterFountain() {
    if (ventilState==true) {
      for (int i=0; i < 3; i++) {
        PVector vel=new PVector(-(pos.x-width/2)/100+0.2, -12);  //upwards, slightly to the center
        vel.x+=random(-0.2, 0.2);
        vel.y+=random(-0.2, 0.2)+10/(pos.x-width+0.1);

        vel.y-=(150-abs(pos.x-width/2))/250;  //Center Düsen go higher

        WaterParticle W=new WaterParticle(this, pos.copy().sub(0, diam/3), vel);
        Water.add(W);
      }
    }
  }
}
