class Bullet {
  PVector pos;
  float angle;
  float speed = 10;
  boolean collided =false;

  Bullet(PVector pos_, float angle_) {
    pos=pos_;
    angle=angle_;
  }



  void update() {
    if (pos.x<width+BlockSize && pos.x>-BlockSize && pos.y<height+BlockSize && pos.y>-BlockSize) {
      move();
      show();
    }
  }


  void show() {
    pushMatrix();
    translate(pos.x, pos.y);
    rotate(angle);
    image(BulletImage, 0, 0);
    popMatrix();
  }

  void move() {
    if (!collided) {
      for (PVector H : HitableBlocks) {
        if (H.dist(pos)<BlockSize) {
          collided =true;
        }
      }
      for (int j=Feen.size()-1; j >=0; j--) {
        if ((Feen.get(j).pos).dist(pos)<BlockSize) {
          Feen.get(j).health-=10;
          if (Feen.get(j).health<0) {
            Feen.remove(j);
          }
        }
      }
      for (int j=Koopas.size()-1; j >=0; j--) {
        if ((Koopas.get(j).pos).dist(pos)<BlockSize) {
          Koopas.get(j).health-=10;
          if (Koopas.get(j).health<0) {
            Koopas.remove(j);
          }
        }
      }
      pos.x+=cos(angle)*speed; 
      pos.y+=sin(angle)*speed;
    }
  }


  void move(float wid, float hei) {
    pos.x+=wid;
    pos.y+=hei;
  }
}
