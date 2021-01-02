class Fee {
  ArrayList<PVector> botBlocks = new ArrayList();
  ArrayList<PVector> topBlocks = new ArrayList();
  PVector size = new PVector(BlockSize, BlockSize);

  //Physic
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

  Fee(PVector SpawnPoint_) {
    pos=changeCordinates(SpawnPoint_);
    r=random(0, 10000);
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
        image(FeeLeftImage, 0, 0);
      } else {
        image(FeeRightImage, 0, 0);
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
    dist = pos.dist(P1.pos);

    if (dist<5*BlockSize && P1.alive==true) {
      AttackMode=true;
    } else if (dist>15*BlockSize||P1.alive==false) {
      AttackMode=false;
    }

    if (AttackMode) {
      float angle = atan2(P1.pos.y-pos.y, P1.pos.x-pos.x);
      speed.x=cos(angle)*3;
      speed.y=sin(angle)*3;
    } else {
      speed.x=(noise(millis()/2000.0+r)-0.5)*5;
      speed.y=sin(millis()/(1000.0)+r)*2;
    }
    pos.add(speed);
  }

  void checkCollide() {
    if (dist<P1.size.x/2+BlockSize/2) {
      P1.health-=2;
      P1.timeHitLast=millis();
    }
  }


  void move(float wid, float hei) {
    pos.x+=wid;
    pos.y+=hei;
  }
}
