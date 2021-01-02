class Player {
  PVector pos = new PVector(100, 100);
  float viewAngle;
  float FOV = 30; //°
  int res = 200;

  float speed=3;
  float angleSize = FOV/(float)res;

  ArrayList<Ray> Rays=new ArrayList();

  Player() {
  }

  void show() {
    fill(255, 0, 0);
    ellipse(pos.x, pos.y, 10, 10);
  }


  void move() {

    if (keys.hasValue(65)) {
      viewAngle+=0.03;
    }
    if (keys.hasValue(68)) {
      viewAngle-=0.03;
    }
    if (keys.hasValue(87)) {
      pos.y+=-sin(viewAngle)*speed;
      pos.x+=cos(viewAngle)*speed;
    }
    if (keys.hasValue(83)) {
      pos.y-=-sin(viewAngle)*speed;
      pos.x-=cos(viewAngle)*speed;
    }
  }


  void see() {

    Rays.clear();
    for (int i=0; i <= res; i++) {
      Rays.add(new Ray(pos, radians(i*FOV/res-FOV/2)+viewAngle, 3, null)) ;
    }

    for (int i=0; i <= res; i++) {
      Ray R = Rays.get(i);
      R.reset();
      R.show();

      Color col=null;
      if (!R.hitWall) {
        col=R.col;
      }
      float angle = R.angle;
      float dist=R.len;

      child.hei[res-i] =cos(angle-viewAngle)*dist;
      child.col[res-i] =col;
    }
  }
}


IntList keys=new IntList();
void keyPressed() {
  if (!keys.hasValue(keyCode)) {
    keys.append(keyCode);
  }
}
void keyReleased() {
  if (keys.hasValue(keyCode)) {
    for (int i=0; i<keys.size(); i++) {
      if (keys.get(i)==keyCode) {
        keys.remove(i);
      }
    }
  }
}

void mouseWheel(MouseEvent event) {
  float e = event.getCount();
  P1.FOV+=e;
}
