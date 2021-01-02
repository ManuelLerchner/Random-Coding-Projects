class Region {
  PVector pos=new PVector(), absPos=new PVector(), size, dim=new PVector();
  boolean found;
  float speed;
  int count;
  
  Region(PVector size, float speed) {
    this.size=size;
    this.speed=speed;
    dim.x=width/4*size.x;
    dim.y=height/4*size.y;
  }

  void show() {
    stroke(0);
    noFill();
    if (found) {
      fill(map(BabyRegions.size(),0,Iter,0,TWO_PI), 1, 0.7, 40+BabyRegions.size()*10);
    }
    rect(pos.x, pos.y, dim.x, dim.y);
  }

  void solveRegion() {
    found=solve(this);
  }

  void addRegions() {
    if (found) {
      if (BabyRegions.size()<Iter) {
        if (size.y<=size.x) {
          Region Left =new Region(new PVector(size.x/2, size.y), speed*0.7);
          Left.absPos=new PVector(absPos.x-size.x/4, absPos.y);
          Left.pos=mapCoordtoPixel(Left.absPos);
          Left.solveRegion();
          BabyRegions.add(Left);
          Region Right =new Region(new PVector(size.x/2, size.y), speed*0.7);
          Right.absPos=new PVector(absPos.x+size.x/4, absPos.y);
          Right.pos=mapCoordtoPixel(Right.absPos);
          Right.solveRegion();
          BabyRegions.add(Right);
        } else {
          Region Top =new Region(new PVector(size.x, size.y/2), speed*0.7);
          Top.absPos=new PVector(absPos.x, absPos.y-size.y/4);
          Top.pos=mapCoordtoPixel(Top.absPos);
          Top.solveRegion();
          BabyRegions.add(Top);
          Region Bot =new Region(new PVector(size.x, size.y/2), speed*0.7);
          Bot.absPos=new PVector(absPos.x, absPos.y+size.y/4);
          Bot.pos=mapCoordtoPixel(Bot.absPos);
          Bot.solveRegion();
          BabyRegions.add(Bot);
        }
      } else {
        solutions.add(absPos);
      }
    }
  }
}

PVector testPos=new PVector();
int movingDir;
float angleBevore;
int turns;

boolean solve(Region R) {
  boolean done=false;
  turns=0;
  testPos.set(R.absPos.x-R.size.x/2, R.absPos.y+R.size.y/2);
  startAngle=angle(f(testPos));
  movingDir=0;

  while (!done) {
    if (movingDir==0) {
      testPos.y-=R.speed;
    }
    if (movingDir==1) {
      testPos.x+=R.speed;
    }
    if (movingDir==2) {
      testPos.y+=R.speed;
    }
    if (movingDir==3) {
      testPos.x-=R.speed;
    }

    if (movingDir==0 &&testPos.y<R.absPos.y-R.size.y/2) {
      movingDir=1;
      testPos.y=R.absPos.y-R.size.y/2;
    }
    if (movingDir==1 && testPos.x>R.absPos.x+R.size.x/2) {
      movingDir=2;
      testPos.x=R.absPos.x+R.size.x/2;
    }
    if (movingDir==2 && testPos.y>R.absPos.y+R.size.y/2) {
      movingDir=3;
      testPos.y=R.absPos.y+R.size.y/2;
    }
    if (movingDir==3 && testPos.x<R.absPos.x-R.size.x/2) {
      movingDir=4;
      testPos.x=R.absPos.x-R.size.x/2;
      testPos.y-=2*R.speed;
      done=true;
    }

    float angleNow= angle(f(testPos));
    float b =angleBevore;
    angleBevore=angleNow-startAngle;

    if (abs(angleBevore-b)>4) {
      if (angleBevore>b) {
        turns++;
      } else {
        turns--;
      }
    }
    if (done) {
      break;
    }
  }
  if (turns!=0) {
    return true;
  } else {
    return false;
  }
}
