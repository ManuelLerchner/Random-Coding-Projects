class Bullet {
  PVector pos = new PVector();
  PVector ThisTargetPos=new PVector();
  PVector speed=new PVector();
  float angle;
  float TargetAngle;

  float BulletTargetAngle;
  boolean remove;

  int targetID;  Bullet(float angle_, PVector targetPos_) {
    pos.x=50;
    pos.y=height/2;
    angle=angle_;
    ThisTargetPos=targetPos_;
    speed.x=random(8, 15);
    speed.y=23-speed.y;
  }



  void show() {

    TargetAngle = atan2(ThisTargetPos.y-pos.y, ThisTargetPos.x-pos.x);
    angle=lerp(TargetAngle, TargetAngle, 0.1);

    pos.y+=sin(TargetAngle)*speed.y;
    pos.x+=cos(TargetAngle)*speed.x;


    if (pos.dist(ThisTargetPos)<10) {
         remove = true;
    }

    pushMatrix();
    translate(pos.x, pos.y);
    rotate(angle);
    fill(200);
    stroke(200);
    rect(0, 0, 6, 3);
    popMatrix();
  }
}
