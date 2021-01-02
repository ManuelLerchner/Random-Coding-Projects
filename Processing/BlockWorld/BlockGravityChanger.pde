long tGravChangeLast=-4000;
class GravityBlock {
  PVector GridPos;
  PVector pos;
  int timeleft;

  GravityBlock(PVector GridPos_) {
    GridPos=GridPos_;
    pos=changeCordinates(GridPos);
  }


  void update() {
   if (pos.x<width+BlockSize && pos.x>-BlockSize && pos.y<2*height+BlockSize && pos.y>-height-BlockSize) {
      show();
      detectPlayer();
      addToHitableBlocks();
    }
  }


  void show() {
    float col = map(timeleft, 0, 4000, 20, 200);
    fill(col, 255-col, 0);
    strokeWeight(1);
    rect(pos.x, pos.y, BlockSize, BlockSize);
    fill(0);
    text(timeleft, pos.x, pos.y);
  }

  void detectPlayer() {    
    boolean exit =false;
    timeleft=round(4000-constrain(-tGravChangeLast+millis(), 0, 4000));
    if (pos.dist(P1.pos)<BlockSize+10 && millis()-tGravChangeLast>4000) {
      if (P1.rotation == "UP") {
        P1.rotation= "DOWN";
        Gravity.y*=-1;
        P1.onGround=false;
        tGravChangeLast=millis();
        exit=true;
      }
      if (P1.rotation == "DOWN" &&!exit) {
        P1.rotation= "UP";
        Gravity.y*=-1;
        P1.onGround=false;
        tGravChangeLast=millis();
        exit=true;
      }
    }
  }

  void addToHitableBlocks() {
    HitableBlocks.add(new PVector(pos.x, pos.y));
  }

  void move(float wid, float hei) {
    pos.x+=wid;
    pos.y+=hei;
  }
}
