class circle {
  float x;
  float y;
  float r;
  PVector speed;
  float hue = 200;
  float sat;

  //Constructor
  circle(float x_, float y_, float r_, float sx_, float sy_) {
    x=x_;
    y=y_;
    r=r_;
    speed = new PVector(sx_,sy_);
  }

  ////////////////////////////////////////////////////
  void show() {
    noFill();
    stroke(hue, sat, 255);
    strokeWeight(1);

    ellipse(x, y, r, r);
  }

  ////////////////////////////////////////////////////
  void update() {
    float px =x;
    float py =y;

    //Movement
    x+=speed.x;
    y+=speed.y;

    //Borders
    if (x<=r/2 || x>=width-r/2) {
      speed.x*=-1;
    }
    if (y<=r/2 || y>=height-r/2) {
      speed.y*=-1;
    }
    x=constrain(x, r/2, width-r/2);
    y=constrain(y, r/2, height-r/2);


    //Collision
    for (circle c : circles) {
      float d = dist(x, y, c.x, c.y);
      if (d != 0) {
        if (d<=r/2+c.r/2) {

          //Undo Movement that let into circle
          x=px;
          y=py;          

          //CollissionMath
          float dist = sqrt(pow(x - c.x, 2) + pow(y - c.y, 2)); 
          float cosA = (c.x - x) / dist; 
          float sinA = (c.y - y) / dist; 
          float p =  cosA*(speed.x-c.speed.x)+sinA*(speed.y-c.speed.y);

          //Speedchange
          speed.x = speed.x - p * cosA; 
          speed.y = speed.y - p *  sinA; 
          c.speed.x = c.speed.x + p * cosA; 
          c.speed.y = c.speed.y + p  * sinA;

          //Collission = gain speed
          speed.x*=1.05;
          speed.y*=1.05;

          //MaxSpeed
          speed.x=constrain(speed.x, -7, 7);
          speed.y=constrain(speed.y, -7, 7);

          //PlaySound
          sound();

          //Colorchange
          hue = random(0, 255);
          sat=255;
          c.hue=random(0, 255);
          c.sat = 255;
        }
      }
    }
  }
}

void sound() {
  if (Sound_ON) {
    if (GlobalTime-LastSoundTime >=SoundBetween) {
      KlickSound.play(1, SoundAmplitude);
      LastSoundTime=GlobalTime;
    }
  }
}
