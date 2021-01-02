class Ball {
  PVector pos = new PVector();
  PVector pPos = new PVector();
  PVector speed = new PVector();
  PVector acc = new PVector();
  PVector force = new PVector();

  float rad;
  boolean collided;
  boolean selected;
  float colorHSB;
  float mass;


  Ball(PVector pos_) {
    pos=pos_;
    colorHSB=random(100);
    rad = random(10, 20);
    mass=rad;
    speed.y=-5;
  }


  void show() {
    //ShowBall
    stroke(0, 100, 0);
    strokeWeight(1.5);
    fill(colorHSB, 100, 100, 150);
    if (selected) {
      fill(255, 125, 100, 150);
    }
    ellipse(pos.x, pos.y, 2*rad, 2*rad);
  }


  void move() {
    speed.add(force);
    speed.add(grav);
    pPos=pos;
    pos.add(speed);
    force.mult(0);
  }


  void collide() {
    //BounceOffFloor
    collided=false;
    int k=0;
    PVector average = new PVector();
    for (PVector p : samplePoints) {
      if (pos.dist(p)<rad) {
        int index = floor(p.x*detail/width);
        PVector P1 = floor.get(index);
        PVector P2 = floor.get(index+1);
        float angle = atan2(P1.y-P2.y, P1.x-P2.x);
        PVector NormalLine = new PVector(sin(-angle), cos(angle));
        average.add(NormalLine.mult(speed.mag()));
        k++;
        collided=true;
      }
    }
    if (collided) {
      average.div(k);
      speed=average;
      speed.mult(damping);
    }

    //CollideWithEachother
    float dist;
    for (Ball b : balls) {
      dist = pos.dist(b.pos);
      if (dist != 0) {
        if (dist<=rad+b.rad) {
          //Undo Movement that let into circle
          float angle = atan2(pos.y-b.pos.y, pos.x-b.pos.x);
          pos= new PVector(b.pos.x+(rad+b.rad)*cos(angle), b.pos.y+(rad+b.rad)*sin(angle));

          //CollissionMath
          float cosA = (b.pos.x - pos.x) / dist; 
          float sinA = (b.pos.y - pos.y) / dist; 
          float p = (2/(mass+b.mass))*(cosA*(speed.x-b.speed.x)+sinA*(speed.y-b.speed.y));

          //Speedchange
          speed.x = speed.x - p * cosA*b.mass; 
          speed.y = speed.y - p *  sinA*b.mass; 
          b.speed.x = b.speed.x + p * cosA*mass; 
          b.speed.y = b.speed.y + p  * sinA*mass;

          //Limit/Damp
          speed.limit(15);
          speed.mult(damping);
          b.speed.limit(15);
          b.speed.mult(damping);
        }
      }
    }

    //DontFallThroughFloor
    int n=0;
    PVector sum = new PVector();
    for (PVector p : samplePoints) {
      if (pos.dist(p)<rad) {
        PVector displacement=new PVector(p.x-pos.x, p.y-pos.y);  
        displacement.limit(rad-displacement.mag());
        sum.add(displacement);
        n++;
      }
    }
    if (n!=0) {
      sum.div(n);
      pos.sub(sum);
    }

    //Walls
    if (pos.y<rad) {
      speed.y*=-0.5;
      pos.y=rad;
    }
    if (pos.y>height+100+rad) {
      speed.y*=0.5;
      pos.y=rad;
    }
    if (pos.x<rad) {
      speed.x*=-1;
      pos.x=rad;
    }
    if (pos.x>width-rad) {
      speed.x*=-1;
      pos.x=width-rad;
    }
  }


  void Shoot() {
    if (selected) {
      float angle= atan2(pos.y-mouseY, mouseX-pos.x);
      float len = dist(pos.x, pos.y, mouseX, mouseY)/2;
      stroke(0, 100, 0);
      strokeWeight(0.5);
      line(pos.x, pos.y, pos.x-cos(angle)*len, pos.y+sin(angle)*len);
      if (!mousePressed) {
        force.add(-cos(angle)*len/6, sin(angle)*len/6*1/(1+pow(3, sin(angle))));
      }
    }
    if (mousePressed) {
      if (mouseButton==LEFT) {
        if (dist(mouseX, mouseY, pos.x, pos.y)<rad*2) {
          selected=true;
        }
      }
    } else {
      selected=false;
    }
  }
}

boolean KeyPressedBevore;
boolean FlankeKey(boolean in) {
  boolean out = false;
  boolean now = KeyPressedBevore;
  KeyPressedBevore = in;
  if (!KeyPressedBevore && now) {
    out = true;
  }
  return out;
}


void addBall() {
  if (FlankeKey(keyPressed)) {
    if (key=='n') {
      PVector posN = new PVector(random(100, width-100), height/3);
      balls.add(new Ball(posN));
    }
  }
}

void keyPressed() {
  if (key == 'r') {
    floor.clear();
    samplePoints.clear();
    balls.clear();
    setWalls();
    setBalls();
  }
}

void mousePressed() {
  if (mouseButton==RIGHT) {
    damping=round(map(mouseX, 0, width, 0, 120))/100.0;
  }
}
