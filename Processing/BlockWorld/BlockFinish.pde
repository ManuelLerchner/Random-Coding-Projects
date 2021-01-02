
class FinishBlock {
  PVector GridPos;
  PVector pos;
  int timeleft;

  FinishBlock(PVector GridPos_) {
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
    rect(pos.x, pos.y, BlockSize, BlockSize);
  }


  void detectPlayer() {    
    if (pos.dist(P1.pos)<BlockSize+10) {
      println("Finished");
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
