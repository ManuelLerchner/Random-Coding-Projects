class Tank {
  float x, y;
  boolean Turn = true;
  float sx, sy;
  float speed = 0.15;
  float theta;
  float thetaPanzer;
  long tlast, tlastM;
  float hp = 100;
  boolean destroyed;
  float bulletSpeed;
  int count, count2;


  Tank(float x_, float y_) {
    x=x_;
    y=y_;
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
    fill(180, 60, 0);
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
    textSize(15);
    fill(0, 255, 0);
    rectMode(CORNER);
    rect(x-100/6, y-35, hp/3, 5);
  }

  void move() {
    theta=atan2(mouseY-y, mouseX-x);
    thetaPanzer = atan2(sy, sx);

    if (Turn == true) {
      if (keys[0]) {
        sy-=speed;
      }  
      if (keys[1]) {
        sx-=speed;
      }  
      if (keys[2]) {
        sy+=speed;
      }  
      if (keys[3]) {
        sx+=speed;
      }
      sx*=0.99;
      sy*=0.99;
      sx=constrain(sx, -3, 3);
      sy=constrain(sy, -3, 3);

      float px = x;
      float py = y;

      x+=sx;
      y+=sy;

      float  extraxl = cos(thetaPanzer)*15+(sin(thetaPanzer)*8);
      float  extraxr = cos(thetaPanzer)*15-(sin(thetaPanzer)*8);
      float  extrayl = sin(thetaPanzer)*15-(cos(thetaPanzer)*8);
      float  extrayr = sin(thetaPanzer)*15+(cos(thetaPanzer)*8);

      for (Object O : Objects) {
        if (  (((x+extraxr < (O.w+O.x))||(x+extraxl < (O.w+O.x))) && ((x+extraxl>O.x)||(x+extraxr>O.x))  ) && (   ((y+extrayr < (O.h+O.y))||(y+extrayl < (O.h+O.y))) && ((y+extrayl>O.y)||(y+extrayr>O.y)))) { 
          x=px;
          y=py;
          sx*=0.1;
          sy*=0.1;
        }
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
    bulletSpeed = (millis()-tlast)/50;
    bulletSpeed=constrain(bulletSpeed, 5, 30);

    if (mousePressed && mouseButton == LEFT && millis()-tlast > 100) {
      Bullets.add(new Bullet(x+cos(theta)*20, y+sin(theta)*20, sx, sy, n, theta, bulletSpeed, 40));
      tlast = millis();
      count++;
    }
  }

  void mine() {
    if (mousePressed && mouseButton == RIGHT && millis()-tlastM > 1000) {
      Mines.add(new Mine(x, y, millis(), thetaPanzer));
      tlastM=millis();
      count2++;
    }
  }

  void isHit() {
    hp=constrain(hp, 0, 1000);
    for (Bullet B : EnemieBullets) {
      if ( (B.x -15 < x && B.x+30>x)&&(B.y -15 < y && B.y+30>y)&&B.speed!=0) {
        hp-=3*B.speed + random(5);      
        B.x=-100;
        B.speed=0;
        B.psx=0;
        B.psy=0;
      }
    }
    for (Mine M : Mines) {
      if (M.exploded) {
        float dist=dist(M.x, M.y, x, y);
        if (dist<M.size/2) {
          hp-=50/(2*dist);
          hp=constrain(hp, 0, 1000);
        }
        if (millis()-M.time >2000) {
          M.x=-200;
        }
      }
    }
    if (hp<=0) {
      destroyed=true;
    }
  }
}




boolean[] keys = new boolean[4];

void keyPressed() {
  if (key=='w')
    keys[0]=true;
  if (key=='a')
    keys[1]=true;
  if (key=='s')
    keys[2]=true;
  if (key=='d')
    keys[3]=true;

  if (key==' ') {
    P1.sx*=0.01;
    P1.sy*=0.01;
  }

  if (key == CODED) {
    if (keyCode == UP) {
      started = true;
      tstarted.x=frameCount;
      tstarted.y=millis();
      ;
    }
  }

  if (!started) {
    if (key=='r') {
      Objects.clear();
      for (int i=0; i < 6; i++) {
        Objects.add(new Object());
      }
    }
  } else if (key=='r') {

    Bullets.clear();
    EnemieBullets.clear();
    Mines.clear();
    Enemies.clear();
    Objects.clear();


    enemiesLeft = n;
    hitCount = 0;
    started = false;




    init();
  }
}

void keyReleased() {
  if (key=='w')
    keys[0]=false;
  if (key=='a')
    keys[1]=false;
  if (key=='s')
    keys[2]=false;
  if (key=='d')
    keys[3]=false;
}



void init() {
  size(800, 800);
  P1 = new Tank(400, 600);

  for (int i=0; i < 6; i++) {
    Objects.add(new Object());
  }

  for (int i=0; i < n; i++) {
    Enemies.add(new Enemie(random(50, width-50), random(50, height/2-50), i));
  }
}
