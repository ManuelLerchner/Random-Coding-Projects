void setMap() {
  mapImage.loadPixels();

  for (int i=0; i < mapImage.width; i++) {
    for (int j=0; j < mapImage.height; j++) {
      int loc = i+j*mapImage.width;
      PVector curr=new PVector(i, j);

      if (mapImage.pixels[loc]==color(0, 0, 0)) {
        Map.put(curr, new Stone(curr, color(10)));
      }
      if (mapImage.pixels[loc]==color(185, 122, 87)) {
        Map.put(curr, new Mud(curr, color(152, 108, 48)));
      }
      if (mapImage.pixels[loc]==color(255, 242, 0)) {
        Map.put(curr, new SpeedBlock(curr, color(255, 242, 0)));
      }
      if (mapImage.pixels[loc]==color(0, 0, 255)) {
        spawnPoint=new PVector(i, j);
      }
    }
  }
}


interface MapType {
  void show();
  void handleCollision(Player P1);
}


class Stone implements MapType {
  PVector pos;
  int col;
  Stone(PVector pos, int col) {
    this.pos=pos;
    this.col=col;
  }
  void show() {
    fill(col);
    rect(toPixelCoordinate(pos), stepX, stepY);
  }

  void handleCollision(Player P) {
    P.punishedRounds=round(max(abs(P.speed.x), abs(P.speed.y)));
    P.pos.set(P.prev);
    P.speed.set(0, 0);
    P.i=P.steps;
  }
}


class Mud implements MapType {
  PVector pos;
  int col;
  Mud(PVector pos, int col) {
    this.pos=pos;
    this.col=col;
  }
  void show() {
    fill(col);
    rect(toPixelCoordinate(pos), stepX, stepY);
  }

  void handleCollision(Player P) {
    P.speed.set(round(P.speed.x/3), round(P.speed.y/3));
    float r=10.0/P.steps*P.animationSpeed.mag();
    P.animationSpeed.add(random(-r, r), random(-r, r));
    P.pos.add(round(random(-P.speed.x, P.speed.x)), round(random(-P.speed.y, P.speed.y)));
  }
}


class SpeedBlock implements MapType {
  PVector pos;
  int col;
  SpeedBlock(PVector pos, int col) {
    this.pos=pos;
    this.col=col;
  }
  void show() {
    fill(col);
    rect(toPixelCoordinate(pos), stepX, stepY);
  }

  void handleCollision(Player P) {
    if (!P.oneTimeEffect) {
      P.animationSpeed.mult(1.2);
      P.speed.mult(1.2);
      P.speed=new PVector(round(P.speed.x), round(P.speed.y));
      P.oneTimeEffect=true;
    }
  }
}
