int enemiesLeft = n;
int hitCount;
boolean started;
PVector tstarted=new PVector();

class Enemie {
  float x, y;
  boolean Turn = true;
  float sx=0.1, sy=-0.2;
  float sxDesired, syDesired;
  float speed = 0.15;
  float theta;
  float thetaDesired;
  float thetaPanzer;
  long tlast;
  int n = 0;
  boolean destroyed;
  float hp = 100;
  float bulletSpeed;

  Enemie(float x_, float y_, int n_) {
    x=x_;
    y=y_;
    n=n_;
  }

  void show() {
    strokeWeight(1);
    pushMatrix();
    translate(x, y);
    rotate(thetaPanzer);
    rectMode(CENTER);

    //Tires
    fill(0);
    rect(12, 10, 5, 3);
    rect(12, -10, 5, 3);
    rect(-12, 10, 5, 3);
    rect(-12, -10, 5, 3);

    //Car
    fill(255, 255, 0);
    rect(0, 0, 30, 16);
    popMatrix();

    //Gun
    pushMatrix();
    translate(x, y);
    rotate(theta);

    //Turret
    fill(0);
    rectMode(CORNERS);
    rect(0, -2, 25, 2);
    ellipse(0, 0, 8, 8);
    popMatrix();

    //Health
    fill(255, 0, 0);
    rectMode(CORNER);
    rect(x-100/6, y-25, hp/3, 5);
  }


  void move() {
    thetaDesired=atan2((P1.y-y), (P1.x-x));
    thetaPanzer = atan2(sy, sx);

    if (frameCount -tstarted.x > 10) {
      theta+=0.1*(pow(sin(n), 2)+0.1)*(tan(thetaDesired-theta));
      theta =theta%TWO_PI;
      thetaDesired =thetaDesired%TWO_PI;
    } else {
      theta=thetaDesired;
    }

    if (frameCount%15 ==0) {
      sx-=randomGaussian();
      sy+=randomGaussian();
    }
    sx=constrain(sx, -1, 1);
    sy=constrain(sy, -1, 1);

    float px = x;
    float py = y;

    x+=sx;
    y+=sy;

    float  extraxl = cos(thetaPanzer)*17+(sin(thetaPanzer)*10);
    float  extraxr = cos(thetaPanzer)*17-(sin(thetaPanzer)*10);
    float  extrayl = sin(thetaPanzer)*17-cos(thetaPanzer)*10;
    float  extrayr = sin(thetaPanzer)*17+(cos(thetaPanzer)*10);

    for (Object O : Objects) {
      if (  (((x+extraxr < (O.w+O.x))||(x+extraxl < (O.w+O.x))) && ((x+extraxl>O.x)||(x+extraxr>O.x))  ) && (   ((y+extrayr < (O.h+O.y))||(y+extrayl < (O.h+O.y))) && ((y+extrayl>O.y)||(y+extrayr>O.y)))) { 
        x=px;
        y=py;
      }
    }

    for (Enemie E : Enemies) {
      float dist = dist(x, y, E.x, E.y);
      if (dist< 30) {
        if (x<E.x) {
          x-=1;
          E.x+=1;
        } else {
          x+=1;
          E.x-=1;
        }
        if (y<E.y) {
          x-=1;
          E.x+=1;
        } else {
          y+=1;
          E.y-=1;
        }
      }
    }
    x=constrain(x, -cos(thetaPanzer)*17+abs(sin(thetaPanzer)*10), width-cos(thetaPanzer)*17-abs(sin(thetaPanzer)*10));
    y=constrain(y, -sin(thetaPanzer)*17+abs(cos(thetaPanzer)*10), height-80-sin(thetaPanzer)*17-abs(cos(thetaPanzer)*10));
  }


  void shoot() {

    bulletSpeed = (millis()-tlast)/400;
    bulletSpeed=constrain(bulletSpeed, 5, 10);

    if (frameCount%(WaitingTime+ShootingDelay*n)==0 && millis() >InitalDelay+tstarted.y) {
      EnemieBullets.add(new Bullet(x+cos(theta)*20, y+sin(theta)*20, sx, sy, n, theta, bulletSpeed, 100));
      tlast = millis();
    }
  }

  void isHit() {
    for (Bullet B : Bullets) {
      if ( (B.x -15 < x && B.x+30>x)&&(B.y -15 < y && B.y+30>y)&&B.speed!=0) {
        hp-=10*map(dist(x, y, P1.x, P1.y), 0, sqrt(width*width+height*height), 2.5, 0.5)+3*B.speed;
        B.x=-100;
        B.speed=0;
        B.psx=0;
        B.psy=0;
        hitCount++;
      }
    }
    for (Mine M : Mines) {
      if (M.exploded) {
        float dist=dist(M.x, M.y, x, y);
        if (dist<160) {
          hp-=10;
          hp=constrain(hp, 0, 1000);
        }
        if (millis()-M.time >2000) {
          M.x=-200;
        }
      }
    }
    if (hp<=0) {
      destroyed=true;
      enemiesLeft--;
    }
  }
}
