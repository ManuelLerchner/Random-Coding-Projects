class Object {
  ArrayList<Object> connected = new ArrayList();
  PVector pos=new PVector();
  PVector transPos;
  boolean reserved;
  Orb currentOrb;
  Reactor Re;
  Tower To;
  BombTower BT;

  //////////////////////////////////////////////////////
  Object(Reactor Re) {
    this.Re=Re;
    this.pos.set(Re.pos);
    transPos=pos.copy().add(camOffset);
    reserved=true;
  }
  Object(Tower To) {
    this.To=To;
    this.pos.set(To.pos);
    transPos=pos.copy().add(camOffset);
  }
  Object(BombTower BT) {
    this.BT=BT;
    this.pos.set(BT.pos);
    transPos=pos.copy().add(camOffset);
  }

  //////////////////////////////////////////////////////
  void update() {
    transPos=pos.copy().add(camOffset);
    if (Re!=null) {
      Re.pos=transPos;
      Re.update();
      Re.produceOrb(this, connected);
    }
    if (To!=null) {
      To.pos=transPos;
      To.update();
      To.moveOrb(this, connected);
    }
    if (BT!=null) {
      BT.pos=transPos;
      BT.update();
      BT.consumeOrb(this);
    }
  }
  //////////////////////////////////////////////////////
  void connect() {
    for (Object O : connected) {
      line(transPos.x, transPos.y, O.transPos.x, O.transPos.y);
    }
  }
}


////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
void updateConnections() {
  for (Object t : Buildings) {
    for (Object o : Buildings) {
      if (t.BT==null || o.BT==null) {
        if (t.Re==null || o.Re==null) {
          PVector diff=t.pos.copy().sub(o.pos);
          if (t.connected.size()<2) {
            if (diff.mag()!=0 && diff.mag()<100) {
              t.connected.add(o);
              o.connected.add(t);
            }
          }
        }
      }
    }
  }
}


boolean spotIsValid() {
  loadPixels(); 
  color t = pixels[mouseX+width*mouseY];
  if (t!=color(0, 126, 192) && t!=  color(24, 154, 208) && t!= color(58, 168, 214) && t!= color(94, 186, 220)  ) {
    return true;
  }
  return false;
}

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
void mousePressed() {
  if (spotIsValid()) {
    if (mouseButton==RIGHT) {
      Buildings.add(new Object(new Reactor(mousePos.copy().sub(camOffset))));
    }
    if (mouseButton==LEFT) {
      Buildings.add(new Object(new Tower(mousePos.copy().sub(camOffset))));
    }
    if (mouseButton==CENTER) {
      Buildings.add(new Object(new BombTower(mousePos.copy().sub(camOffset))));
    }
    updateConnections();
  }
}

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
void mouseWheel(MouseEvent event) {
  float e = event.getCount();
  scaleFactor*=1-e/10;
}

IntList keysPressed = new IntList();
void keyPressed() {
  if (!keysPressed.hasValue(keyCode)) {
    keysPressed.append(keyCode);
  }
}

void keyReleased() {
  keysPressed.removeValue(keyCode);
}


void moveCam() {
  if (keysPressed.hasValue(87)) {
    camOffset.y+=5/scaleFactor;
  }
  if (keysPressed.hasValue(83)) {
    camOffset.y-=5/scaleFactor;
  }
  if (keysPressed.hasValue(65)) {
    camOffset.x+=5/scaleFactor;
  }
  if (keysPressed.hasValue(68)) {
    camOffset.x-=5/scaleFactor;
  }
}
