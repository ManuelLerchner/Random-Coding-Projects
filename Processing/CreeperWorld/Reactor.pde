class Reactor {
  PVector pos;
  int speed=50;
  int pruducedOrbs;

  Reactor(PVector pos) {
    this.pos=pos;
  }

  void update() {
    show();
  }

  void show() {
    fill(100);
    rect(pos.x, pos.y, 30, 30);
  }

  void produceOrb(Object Re, ArrayList<Object> connected) {
    if (pruducedOrbs<3) {
      if ((frameCount+int(pos.x))%speed==0) {
        pruducedOrbs++;
      }
    }
    if (pruducedOrbs>0) {
      if (connected.size()>0) {
        int r = floor(random(connected.size()));
        if (connected.get(r).currentOrb==null) {
          if (connected.get(r).reserved==false) {
            Orb newOrb = new Orb(Re, connected.get(r));
            newOrb.lastPlace=Re;
            Orbs.add(newOrb);
            connected.get(r).reserved=true;
            pruducedOrbs--;
          }
        }
      }
    }
    for (int i=-1; i < pruducedOrbs-1; i++) {
      fill(0, 255, 100);
      ellipse(pos.x+10*i, pos.y, 8, 8);
    }
  }
}
