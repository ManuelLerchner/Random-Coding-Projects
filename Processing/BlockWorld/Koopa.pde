class Koopa {
  ArrayList<PVector> botBlocks = new ArrayList();
  ArrayList<PVector> topBlocks = new ArrayList();
  PVector size = new PVector(BlockSize, BlockSize);

  //Physic
  PVector forces = new PVector();
  PVector acc = new PVector();
  PVector pos = new PVector();
  PVector speed= new PVector();

  boolean onGround;
  String rotation = "UP";
  float angle = 0;
  boolean wallJumpPoss;
  float r;
  float health = 100;
  float dist;
  boolean alive = true;
  boolean AttackMode=false;
  boolean dir;
  int count;
  long dirChangedLast;

  int jumpCount;

  Koopa(PVector SpawnPoint_) {
    pos=changeCordinates(SpawnPoint_);
    r=random(0, 10000);
    jumpCount=int(random(100, 500));
    dir=boolean(int(random(1)));
  }


  void update() {
    if (pos.x<width+BlockSize && pos.x>-BlockSize && pos.y<height+BlockSize && pos.y>-BlockSize) {
      move();
      collide();
      checkCollide();
      show();
    }
  }


  void show() {
    pushMatrix();
    translate(pos.x, pos.y);
    showHealth();
    if (speed.x<0) {
      image(KoopaLeftImage, 0, 0);
    } else {
      image(KoopaRightImage, 0, 0);
    }
    popMatrix();
  }



  void showHealth() {
    strokeWeight(0.5);
    stroke(255);
    if (AttackMode) {
      fill(255, 0, 0);
    } else {
      fill(0, 255, 0);
    }
    rect(0, -0.7*size.y, map(health, 0, 100, 0, BlockSize*0.8), 5);
    if (health<0) {
      rotation="LEFT";
      alive=false;
    }
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
        dir=!dir;
      }
      //Rechts
      if (abs(G.x-pos.x)<size.x/2+BlockSize/2 && pos.x>G.x && abs(G.y-pos.y)<BlockSize/2) {
        wallJumpPoss=true;
        speed.x*=0;
        pos.x=(G.x+size.x/2+BlockSize/2);
        botBlocks.remove(G);
        topBlocks.remove(G);
        dir=!dir;
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
    boolean walk=true;
    for (PVector G : HitableBlocks) {     
      if (abs(G.x-pos.x)<BlockSize/2) {
        if (abs(G.y-pos.y)<2*BlockSize) {
          walk=false;
        }
      }
    }


    if (count>jumpCount && onGround && walk==false) {
      forces.y=-10;
      onGround=false;
      count=0;
      jumpCount*=random(0.5, 1.5);
    } else {
      if (onGround) {
        if (walk&&millis()-dirChangedLast>1000) {
          dir=!dir;
          dirChangedLast=millis();
        }
        if (dir==false) {
          speed.x=2;
        } else {
          speed.x=-2;
        }
        count++;
      } else {
        speed.x*=0.8;
      }
    }


    acc.add(forces);
    if (!onGround) {
      acc.add(new PVector(Gravity.x,abs(Gravity.y)));
    }

    //Speed
    speed.add(acc);

    //Pos
    pos.add(speed);

    //Reset
    forces.mult(0);
    acc.mult(0);
  }

  void checkCollide() {
    if (pos.dist(P1.pos)<P1.size.x/2+BlockSize/2) {
      P1.health-=2;
      P1.timeHitLast=millis();     
    }
  }


  void move(float wid, float hei) {
    pos.x+=wid;
    pos.y+=hei;
  }
}
