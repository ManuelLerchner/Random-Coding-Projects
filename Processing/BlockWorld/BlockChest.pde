class ChestBlock {
  PVector GridPos;
  PVector pos;
  int count;
  boolean opening;
  boolean wait;


  ChestBlock(PVector GridPos_) {
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
    image(ChestImage, pos.x, pos.y);
  }

  void detectPlayer() {    
    if (pos.dist(P1.pos)<BlockSize+10) {  
      count++;
    } else {
      count=0;
    }
    if (count>10) {
      opening=true;
    }
    if (opening) {
      int durability = round(random(4, 8));
      IntList occupied = new IntList();
      for (int i=0; i < P1.Inv.size(); i++) {       
        occupied.append(P1.Inv.get(i).slot);
      }
      for (int j=0; j < 10; j++) {
        if (!occupied.hasValue(j)) {
          boolean r = boolean(round(random(0, 1)));
          P1.Inv.add(new Weapon(j, r, durability));
          j=20;
        }
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
