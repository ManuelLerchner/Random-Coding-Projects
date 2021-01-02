class Player {
  PVector pos = new PVector(100, 100);
  float viewAngle;
  int FOV = 30; //°
  int res = 80;
  float speed=3;
  float angleSize = FOV/(float)res;

  Player() {
  }

  void show() {
    fill(255, 0, 0);
    ellipse(pos.x, pos.y, 10, 10);
  }

  void move() {
    if (keyPressed) {
    
      if (keys.hasValue(87)) {
        pos.y+=cos(viewAngle)*speed;
        pos.x+=sin(viewAngle)*speed;
      }
      if (keys.hasValue(83)) {
        pos.y-=cos(viewAngle)*speed;
        pos.x-=sin(viewAngle)*speed;
      }
      if (keys.hasValue(65)) {
        viewAngle+=0.05;
      }
      if (keys.hasValue(68)) {
        viewAngle-=0.05;
      }
    }
    if (mousePressed) {
      if (mouseButton==RIGHT) {
        pos.set(mouseX, mouseY);
      }
    }
  }

  void see() {
    loadPixels();
    for (int i=0; i < res; i++) {
      float angle = viewAngle+radians(map(i, 0, res, FOV, -FOV));
      float dist=shootRay(pos, angle).x;
      color col=round(shootRay(pos, angle).y);
      child.hei[i] =cos(angle-viewAngle)*dist;
      child.col[i] =col;
      if (i%10==0) {
        stroke(255, 50);
        line(pos.x, pos.y, pos.x+sin(angle)*dist, pos.y+cos(angle)*dist);
      }
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


float sgnDstToScene(PVector P) { 
  float dist = maxDist;
  for (Circle C : Circles) {
    float dstCircle=sgnDstToCirlce(P, C.pos, C.rad);
    dist=min(dstCircle, dist);
  }
  for (Box B : Boxes) {
    float dstBox=sgnDstToBox(P, B.pos, B.size);
    dist=min(dstBox, dist);
  }
  return dist;
}


PVector shootRay(PVector P, float angle) {
  PVector newStep=P.copy();
  color col=0;
  for (int i=0; i < 100; i++) {
    PVector prevPos = newStep.copy();
    float currDist=sgnDstToScene(prevPos);  
    newStep.add(currDist*sin(angle), currDist*cos(angle));
    if (abs(currDist)<0.1) {
      break;
    }
    if (abs(currDist)>SceneSize) {
      break;
    }
    if (newStep.x<0 || newStep.x>width) {
      newStep.add(10000,10000);
      break;
    }
    if (newStep.y<0 || newStep.y>height) {
      newStep.add(10000, 10000);
      break;
    }
  }
  int loc = constrain(round(newStep.x+2*sin(angle))+round(newStep.y+2*cos(angle))*height, 0, width*height-1);
  col=pixels[loc];
  return new PVector(P.dist(newStep), col);
}

void mouseWheel(MouseEvent event) {
  float e = event.getCount();
  P1.FOV+=e;
}
