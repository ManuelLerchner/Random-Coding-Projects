class Tower {
  PVector pos;
  int index=0;

  Tower(PVector pos) {
    this.pos=pos;
  }

  void update() {
    show();
  }

  void show() {
    fill(150);
    rect(pos.x, pos.y, 10, 10);
  }

  void moveOrb(Object Tu, ArrayList<Object> connected) {
    if (Tu.currentOrb!=null) {
      if (connected.size()>1) {
        int r = floor(random(connected.size()));
        if (connected.get(r).currentOrb==null) {
          if (connected.get(r).reserved==false) {
            if (Tu.currentOrb.lastPlace!=connected.get(r)) {
              Tu.currentOrb.start=Tu;
              Tu.currentOrb.end=connected.get(r);
              Tu.currentOrb.endMoving=false;
              Tu.reserved=false;
              connected.get(r).reserved=true;
              Tu.currentOrb.lastPlace=Tu;
              Tu.currentOrb=null;
              index++;
            }
          }
        }
      }
    }
  }
}
