class SpaceShip {
  PVector pos = new PVector();
  float angle;
  float TargetAngle;


  SpaceShip() {
    Rocket= loadImage("Rocket.png");
    pos.x=50;
    pos.y=height/2;
  }



  void show() {

    if (keyPressed) {
      TargetAngle = atan2(targetPos.y-pos.y, targetPos.x-pos.x);
    }

    angle=lerp(angle, TargetAngle, 0.2);

    if (CharRemoved) {
      Bullets.add(new Bullet(angle, targetPos));
      CharRemoved=false;
    }



    pushMatrix();
    translate(pos.x, pos.y);
    rotate(angle);
    image(Rocket, 0, 0);
    popMatrix();
  }
}
