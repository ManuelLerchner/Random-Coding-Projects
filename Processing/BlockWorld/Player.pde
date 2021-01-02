ArrayList<PVector> botBlocks = new ArrayList();
ArrayList<PVector> topBlocks = new ArrayList();


class Player {
  float movingAcc=0.5;
  PVector maxSpeed = new PVector(7, 40);
  PVector size = new PVector(BlockSize, BlockSize);
  float JumpForceIn = -12;
  PVector JumpForce = new PVector();

  //Physic
  PVector pos = new PVector();
  PVector speed= new PVector();
  PVector acc=new PVector();
  PVector forces=new PVector();
  boolean onGround;
  String rotation = "UP";
  float angle = 0;
  float gunAngle;
  float kniveAngle;
  float newKniveAngle;
  boolean wallJumpPoss;
  boolean alive=true;
  float health = 100;

  long timeHitLast;
  boolean healing;

  ArrayList<Weapon> Inv = new ArrayList(9);
  int selectedInv;
  boolean RiffleEquipped;
  boolean KniveEquipped;


  Player(PVector SpawnPoint_) {
    pos=changeCordinates(SpawnPoint_);
  }


  void update() {
    if (alive) {
      move();
      attack();
    }
    inventory();
    collide();
    physics();
    MoveMap();
    show();
  }


  void show() {
    pushMatrix();
    translate(pos.x, pos.y);
    rot();
    showHealth();
    if (speed.x*Gravity.y<0) {
      image(PlayerLeft, 0, 0);
    } else {
      image(PlayerRight, 0, 0);
    }
    showWeapon();
    popMatrix();
  }


  void inventory() {
    fill(100, 100);
    stroke(0);
    strokeWeight(1);
    for (int i=-5; i < 5; i++) {
      rect(width/2+i*40, height-25, 40, 40);
    }
    fill(255, 100);
    rect(width/2+(selectedInv-5)*40, height-25, 40, 40);      
    for (int i=0; i < Inv.size(); i++) {
      if ( Inv.get(i).ranged==true) {
        image(PistoleLeftSmallImage, width/2+(Inv.get(i).slot-5)*40, height-20);
        fill(255);
        text(Inv.get(i).durability, width/2+15+(Inv.get(i).slot-5)*40, height-15);
      }
      if ( Inv.get(i).ranged==false) {
        image(SwordLeftSmallImage, width/2+(Inv.get(i).slot-5)*40, height-25);
        fill(255);
        text(Inv.get(i).durability, width/2+15+(Inv.get(i).slot-5)*40, height-15);
      }
    }
    RiffleEquipped=false;
    KniveEquipped=false;
    for (int i=0; i < Inv.size(); i++) {
      if (Inv.get(i).slot==selectedInv) {
        if (Inv.get(i).ranged==true) {
          RiffleEquipped=true;
        }
        if (Inv.get(i).ranged==false) {
          KniveEquipped=true;
        }
      }
    }
  }

  void showWeapon() {
    if (RiffleEquipped) {
      if (alive) {
        gunAngle=atan2(mouseY-pos.y, mouseX-pos.x);
      }
      pushMatrix();
      fill(0);
      rotate(gunAngle);

      if (round(abs(speed.x)/(speed.x))*Gravity.y>0) {
        if (Gravity.y<0) {
          rotate(PI);
        }
        image(PistoleLeftImage, 0, 0);
      } else {
        if (Gravity.y<0) {
          rotate(PI);
        }
        rotate(PI);
        image(PistoleRightImage, 0, 0);
      }
      popMatrix();
    }

    if (KniveEquipped) {
      if (Help==true) {
        noFill();
        stroke(0);
        if (round(abs(speed.x)/speed.x)*Gravity.y>0) {
          arc(0, 0, 6*BlockSize, 6*BlockSize, -PI/2, PI/2);
        } else {
          arc(0, 0, 6*BlockSize, 6*BlockSize, PI/2, 3*PI/2);
        }
        line(0, -3*BlockSize, 0, 3*BlockSize);
      }
      if (round(abs(speed.x)/(speed.x))*Gravity.y>0) {
        image(SwordLeftImage, 0, 0);
      } else {
        image(SwordRightImage, 0, 0);
      }
    }
  }

  void attack() {
    if (RiffleEquipped) {
      if (mousePressed && millis()-tShotLast>500) {
        for (int i=0; i < Inv.size(); i++) {
          if (Inv.get(i).slot==selectedInv) {
            Inv.get(i).durability--;
          }
        }
        Bullets.add(new Bullet(new PVector(pos.x, pos.y), gunAngle));
        tShotLast=millis();
      }
    }
    if (KniveEquipped) {
      if (mousePressed && millis()-tHitLast>200) {
        for (int i=0; i < Inv.size(); i++) {
          if (Inv.get(i).slot==selectedInv) {
            Inv.get(i).durability--;
          }
        }
        newKniveAngle =kniveAngle+PI;
        for (int j=Feen.size()-1; j >=0; j--) {
          if ((Feen.get(j).pos).dist(pos)<3*BlockSize) {
            float side = pos.x-Feen.get(j).pos.x;
            if (side*round(abs(speed.x)/(speed.x+0.01))<0) {
              Feen.get(j).health-=50;
              if (Feen.get(j).health<=0) {
                Feen.remove(j);
              }
            }
          }
        }
        for (int j=Koopas.size()-1; j >=0; j--) {
          if ((Koopas.get(j).pos).dist(pos)<3*BlockSize) {
            float side = pos.x-Koopas.get(j).pos.x;
            if (side*round(abs(speed.x)/(speed.x+0.01))<0) {
              Koopas.get(j).health-=50;
              if (Koopas.get(j).health<=0) {
                Koopas.remove(j);
              }
            }
          }
        }
        tHitLast=millis();
      }
    }
    for (int i=Inv.size()-1; i >= 0; i--) {
      if (Inv.get(i).durability==0) {
        Inv.remove(i);
      }
    }
  }


  void showHealth() {
    strokeWeight(0.5);
    stroke(255);
    fill(255, 0, 0);
    if (healing) {
      fill(200, 104, 250);
    }
    rect(0, -0.7*size.y, map(health, 0, 100, 0, BlockSize*0.8), 5);
    if (health<0) {
      rotation="LEFT";
      alive=false;
    }
    health=constrain(health, 0, 100);
    if (health<100 && alive && millis()-timeHitLast>5000) {
      health+=0.1;      
      healing = true;
    } else {
      healing=false;
    }
  }


  void physics() {
    //Acc
    acc.add(forces);
    if (!onGround) {
      acc.add(Gravity);
    }
    //Speed
    speed.add(acc);
    speed.x=constrain(speed.x, -maxSpeed.x, maxSpeed.x);
    speed.y=constrain(speed.y, -maxSpeed.y, maxSpeed.y);
    //Pos
    speed.x*=0.95;
    pos.add(speed);

    //Reset
    forces.mult(0);
    acc.mult(0);
  }

  void collide() {
    botBlocks.clear();
    topBlocks.clear();

    //Add Top/Bot Blocks
    for (PVector G : HitableBlocks) {
      //Find Blocks Beneath the PLayer
      if (abs(G.x-pos.x)<BlockSize-1) {
        if (G.y-pos.y>size.y/2-BlockSize && G.y-pos.y<size.y/2+BlockSize) {   
          botBlocks.add(G);
        }
      }
      //Find Blocks Above the PLayer
      if (abs(G.x-pos.x)<BlockSize-1) {
        if (G.y-pos.y<size.y/2-BlockSize && pos.y-G.y<size.y/2+BlockSize) {   
          topBlocks.add(G);
        }
      }
      if (G.dist(pos)<BlockSize*2/3) {
        pos.y-=BlockSize*round(Gravity.y/abs(Gravity.y+0.01));
      }
    }

    if (botBlocks.size()==0 && rotation=="UP") {
      onGround=false;
    }
    if (topBlocks.size()==0 && rotation=="DOWN") {
      onGround=false;
    }


    wallJumpPoss=false;
    for (PVector G : HitableBlocks) {
      //Links
      if (abs(G.x-pos.x)<size.x/2+BlockSize/2 && pos.x<G.x && abs(G.y-pos.y)<BlockSize/2) {
        wallJumpPoss=true;
        speed.x*=0;
        pos.x=(G.x-size.x/2-BlockSize/2);
        botBlocks.remove(G);
        topBlocks.remove(G);
      }
      //Rechts
      if (abs(G.x-pos.x)<size.x/2+BlockSize/2 && pos.x>G.x && abs(G.y-pos.y)<BlockSize/2) {
        wallJumpPoss=true;
        speed.x*=0;
        pos.x=(G.x+size.x/2+BlockSize/2);
        botBlocks.remove(G);
        topBlocks.remove(G);
      }
    }

    //Oben
    for (PVector P : botBlocks) {
      if (abs(P.y-pos.y)<BlockSize/2+size.y/2 && pos.y<P.y && abs(P.x-pos.x)<BlockSize/2+size.x/2-10) {
        if (rotation=="UP") {
          onGround=true;
        }
        wallJumpPoss=false;
        speed.y*=0;
        pos.y=(P.y-size.y/2-BlockSize/2);
      }
    }
    //Unten
    for (PVector P : topBlocks) {
      if (abs(P.y-pos.y)<BlockSize/2+size.y/2 && pos.y>P.y && abs(P.x-pos.x)<BlockSize/2+size.x/2-10) {
        if (rotation=="DOWN") {
          onGround=true;
        }
        wallJumpPoss=false;
        speed.y*=0;
        pos.y=(P.y+size.y/2+BlockSize/2);
      }
    }
  }


  void move() {
    boolean prohibit = false;
    if (botBlocks.size()!=0 && rotation=="DOWN") {
      prohibit=true;
    }
    if (topBlocks.size()!=0 && rotation=="UP") {
      prohibit=true;
    }
    if (keyUp&!prohibit) {
      if ((P1.onGround==true)&&millis()-tWallJumpLast>100) {
        P1.forces.add(JumpForce);
        wallJumpPoss=false;
      } else
        if (wallJumpPoss&&!stop) {
          if (millis()-tWallJumpLast>300) {
            tWallJumpLast=millis();
            int dir=round(speed.x/abs(speed.x+0.01)); 
            P1.speed.y*=0.2;
            P1.speed.x*=0.2;
            P1.forces.add(new PVector(-7*dir, JumpForce.y));
          }
        }
      stop=true;
      onGround=false;
    }
    if (keyLeft) {
      P1.forces.x-=movingAcc;
    }
    if (keyRight) {
      P1.forces.x+=movingAcc;
    }
    if (keyDown) {
      P1.speed.x*=(0.7);
    }
  }


  void rot() {
    float angleNew=0;
    if (rotation=="UP") {    
      angleNew = 0;
    }
    if (rotation=="DOWN") {    
      angleNew = PI;
    }
    if (rotation=="LEFT") {    
      angleNew = PI/2;
    }
    if (rotation=="RIGHT") {    
      angleNew = 3*PI/2;
    } 
    angle=lerp(angle, angleNew, 0.1);
    rotate(angle);
    JumpForce.x=cos(angle+PI/2)*JumpForceIn;
    JumpForce.y=sin(angle+PI/2)*JumpForceIn;
  }
}
long tWallJumpLast;
long tShotLast;
long tHitLast;
boolean stop;



void keyPressed() {
  setMove(keyCode, true);
  if (key=='m') {
    mapEnabled=!mapEnabled;
  }
  if (key=='h') {
    Help=!Help;
  }
  if (key=='r') {
    reset();
  }


  if (key=='1') {
    P1.selectedInv=0;
  }
  if (key=='2') {
    P1.selectedInv=1;
  }
  if (key=='3') {
    P1.selectedInv=2;
  }
  if (key=='4') {
    P1.selectedInv=3;
  }
  if (key=='5') {
    P1.selectedInv=4;
  }
  if (key=='6') {
    P1.selectedInv=5;
  }
  if (key=='7') {
    P1.selectedInv=6;
  }
  if (key=='8') {
    P1.selectedInv=7;
  }
  if (key=='9') {
    P1.selectedInv=8;
  }
  if (key=='0') {
    P1.selectedInv=9;
  }
}
void keyReleased() {
  setMove(keyCode, false);
  stop=false;
}


void reset() {
  Grass.clear();
  Finish.clear();
  Stone.clear();
  Chest.clear();
  Bullets.clear();
  GravityChanger.clear();
  Feen.clear();
  Koopas.clear();
  HitableBlocks.clear();
  Gravity.set(0, 0.5);
  setup();
}

void mouseWheel(MouseEvent event) {
  float e = event.getCount();
  P1.selectedInv-=e;
  P1.selectedInv=P1.selectedInv%10;
  if (P1.selectedInv<0) {
    P1.selectedInv=9;
  }
}

boolean keyLeft, keyRight, keyUp, keyDown; 
boolean setMove(int k, boolean b) {
  switch (k) {
  case 87:
    return keyUp = b;
  case 83:
    return keyDown = b;
  case 65:
    return keyLeft = b;
  case 68:
    return keyRight = b;
  default:
    return b;
  }
}
