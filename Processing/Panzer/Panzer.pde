Tank P1;
ArrayList<Bullet> Bullets = new ArrayList<Bullet>();
ArrayList<Bullet> EnemieBullets = new ArrayList<Bullet>();
ArrayList<Mine> Mines = new ArrayList<Mine>();
ArrayList<Enemie> Enemies = new ArrayList<Enemie>();
ArrayList<Object> Objects = new ArrayList<Object>();


int n = 10;
float ShootingDelay = 20;
float WaitingTime = 50;
int InitalDelay = 2000;

void setup() {
  size(800, 800);
  P1 = new Tank(400, 600);

  for (int i=0; i < 6; i++) {
    Objects.add(new Object());
  }

  for (int i=0; i < n; i++) {
    Enemies.add(new Enemie(random(50, width-50), random(50, height/2-50), i));
  }
}

void draw() {
  background(70, 60, 80);

  //Wall
  for (Object O : Objects) {
    O.show();
  }

  if (started) {
    //Mine
    for (Mine M : Mines) {
      if (!M.exploded) {
        M.show();
      }
      M.explode();
    }

    //Bullets
    for (Bullet B : Bullets) {
      B.show();
      B.move();
    }
    for (Bullet B : EnemieBullets) {
      B.show();
      B.move();
    }

    //Enemies
    for (Enemie E : Enemies) {
      if (!E.destroyed) {
        E.show();
        E.isHit();
        E.move();
        E.shoot();
      }
    }
  }

  //Player
  if (!P1.destroyed) {
    P1.show();
    if (started) {
      P1.move();
      P1.shoot();
      P1.mine();
      P1.isHit();
    }
  }


  //Text
  else {
    fill(255, 0, 0);
    textSize(50);
    textAlign(CENTER);
    text("Game Over", width/2, height/2-200);
    textSize(15);
    fill(255);
    text("Press 'R' to restart", width/2, height/2);
  }

  if (enemiesLeft<=0 && n!= 0 ) {
    fill(255);
    textSize(50);
    textAlign(CENTER);
    if (!P1.destroyed) {
      text("Game Won", width/2, height/2-150);
      textSize(15);
      text("Press 'R' to restart", width/2, height/2);
    }
    textSize(20);
    text("You shot " + P1.count +" times", width/2, height/2+175);
    text("and hit " + nf(100.0*hitCount/P1.count, 0, 2) + "% of your Shots", width/2, height/2+200);
    text("You laid " + P1.count2 +" mines", width/2, height/2+240);
  }


  if (!started) {

    textSize(15);
    textAlign(LEFT);
    fill(255);

    text("Press ''R'' to reroll the Walls", 50, height-180); 
    text("Press ''UP Arrow'' to start the game \nand to summon " +n +" Enemies", 50, height-160);

    text("WASD: move\nLeft Mouse Button: Fire\nRight Mouse Button: Lay Mine", width-250, height-180);
  }




  deleteObjects();
  Hud();
}





void Hud() {
  textSize(15);
  textAlign(LEFT);
  noStroke();
  fill(200, 100);
  rectMode(CORNER);
  rect(0, height-80, width, height);
  strokeWeight(1);
  stroke(0);

  //Hud
  fill(0, 255, 0);
  text("Healt Points:\n" +round(P1.hp), width-300, height-60);
  rect(width-300, height-30, P1.hp, 15);

  fill(0, 255, 200);
  text("Bullet Speed:\n" +P1.bulletSpeed, width-150, height-60);
  rect(width-150, height-30, P1.bulletSpeed*10/3, 15);

  fill(255, 255, 0);
  text("Enemies Left:\n" +enemiesLeft, 30, height-60);

  for (int i=0; i < enemiesLeft; i++) {
    rect(30+200/(n+1)*i, height-30, 200/(n+1), 15);
  }
}
