class GrassBlock {
  PVector GridPos;
  PVector pos;

  GrassBlock(PVector GridPos_) {
    GridPos=GridPos_;
    pos=changeCordinates(GridPos);
  }

  void update() {
     if (pos.x<width+BlockSize && pos.x>-BlockSize && pos.y<2*height+BlockSize && pos.y>-height-BlockSize) {
      show();
      addToHitableBlocks();
    }
  }

  void show() {
    image(GrassImage, pos.x, pos.y);
  }
  
  void addToHitableBlocks() {
    HitableBlocks.add(new PVector(pos.x, pos.y));
  }

  void move(float wid, float hei) {
    pos.x+=wid;
    pos.y+=hei;
  }
}
