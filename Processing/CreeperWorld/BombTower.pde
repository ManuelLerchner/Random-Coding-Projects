class BombTower {
  Object BT;
  PVector pos;
  boolean explode;
  long tExpl;
  float rad=0;
  int storedOrbs;
  int target;
  int speed=50;

  BombTower(PVector pos) {
    this.pos=pos;
  }

  void update() {
    show();
  }

  void show() {
    fill(50);
    rect(pos.x, pos.y, 50, 50);
    explode();
  }

  void explode() {
    if (!explode) {
      if (storedOrbs>0) {
        if ((frameCount+int(pos.x))%speed==0) {
          explode=true;
          storedOrbs--;
          tExpl=millis();
        }
      }
    } else {
      fill(255, 0, 0);
      ellipse(pos.x, pos.y, rad, rad);
      rad+=1.5;
      if (millis()-tExpl>500) { 
        explode=false;
        rad=0;
      }
    }
    for (int i=-1; i < storedOrbs-1; i++) {
      fill(0, 255, 100);
      ellipse(pos.x+10*i, pos.y, 8, 8);
    }
  }

  void consumeOrb(Object BT_in) {
    if (BT_in.currentOrb!=null) {
      if (storedOrbs<3) {
        BT_in.currentOrb.finished=true;
        BT_in.currentOrb=null;
        BT_in.reserved=false;
        storedOrbs++;
      }
    }
  }
}
