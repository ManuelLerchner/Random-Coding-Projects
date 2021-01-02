int grid = 25;
int moveEveryXFrames = 5;

PVector velocity = new PVector();
PVector squarepos = new PVector();
PVector applepos  = new PVector();
float gridsize;
int totalEaten;
int previousdir;
float keyspressed;
boolean delaynext = false;

ArrayList <PVector> tail = new ArrayList<PVector>();

void setup() {
  size(800, 800);
  rectMode(CENTER);

  gridsize = width/grid;
  createsquare();
  createapple();
}

void draw() {
  background(51);


  drawgrid();
  move();
  eat();

  showapple();
  showsnake();


  fill(255);
  textSize(12);
  text("Speed: " +round(frameRate), width-70, height-20);
  text("Length: " +tail.size(), width-70, height-40);
}


//////////////////////////////////////////////////////////////////////////////////////////////////////////////
void drawgrid() {
  fill(70);
  rect( applepos.x, applepos.y, gridsize, 2*height);
  rect( applepos.x, applepos.y, 2*height, gridsize);

  for (float i=gridsize; i <= width; i+= gridsize) {
    stroke(0);
    line(i, 0, i, height);
    line(0, i, width, i);
  }
}

void keyPressed() {

  if (keyspressed<1) {
    if (key == 'a' && previousdir != 2) {
      velocity.set(-gridsize, 0);
      previousdir = 1;
    } else if (key == 'd' && previousdir != 1) {
      velocity.set(gridsize, 0);
      previousdir = 2;
    } else if (key == 'w' && previousdir != 4) {
      velocity.set(0, -gridsize);
      previousdir = 3;
    } else if (key == 's' && previousdir != 3) {
      velocity.set(0, gridsize);
      previousdir = 4;
    } else if (key == ' ' ) {
      delay(2000);
    }

    keyspressed += 1;
  }
}

void move() {


  if (frameCount %moveEveryXFrames ==0) {
    keyspressed = 0;
    squarepos.x+=velocity.x;
    squarepos.y+=velocity.y;
  }

  if (squarepos.x > width-gridsize/2) {
    squarepos.x = gridsize/2;
  }
  if (squarepos.x < gridsize/2) {
    squarepos.x = width-gridsize/2;
  }
  if (squarepos.y > height-gridsize/2) {
    squarepos.y = gridsize/2;
  }
  if (squarepos.y < gridsize/2) {
    squarepos.y  = height-gridsize/2;
  }
}

void createsquare() {
  squarepos.x= gridsize*(floor(random(grid))+0.5); 
  squarepos.y= gridsize*(floor(random(grid))+0.5);
}
void createapple() {
  applepos.x= gridsize*(floor(random(grid))+0.5); 
  applepos.y= gridsize*(floor(random(grid))+0.5);
}

void showapple() {

  fill(0, 255, 0);
  pushMatrix();
  translate(applepos.x, applepos.y-gridsize/2);
  rotate(radians(20));
  rect(0, 0, gridsize/5, gridsize);
  popMatrix();
  fill(255, 0, 0);
  ellipse(applepos.x, applepos.y, gridsize/1.1, gridsize);
}

void eat() {
  if (dist(applepos.x, applepos.y, squarepos.x, squarepos.y)<1) {
    createapple();
    totalEaten++;
  }

  //Tail

  if (frameCount %moveEveryXFrames ==0) {
    boolean eaten = false;

    //Eaten
    if (tail.contains(squarepos) && tail.size() != 1) {
      eaten = true;
    }

    //add
    tail.add(new PVector(squarepos.x, squarepos.y));

    //Eaten
    if (tail.contains(squarepos) && tail.indexOf(squarepos) != tail.size()-1) {
      eaten = true;
    }

    //remove if eaten
    if (eaten) {
      totalEaten = tail.size()-tail.indexOf(squarepos)-1;
      for (int i=tail.indexOf(squarepos); i>0; i-=1) {
        tail.remove(i);
      }
    }
    if ((totalEaten == tail.size()-1)) {
      tail.remove(0);
    }
  }
}


void showsnake() {
  for (int i=0; i < tail.size(); i++) {

    fill( map(i, 0, tail.size(), 125, 20), map(i, 0, tail.size(), 255, 120), map(i, 0, tail.size(), 195, 40));
    rect(tail.get(i).x, tail.get(i).y, gridsize, gridsize);
  }

  //Down
  if (velocity.x == 0 && velocity.y == gridsize) {

    fill(250, 80, 150);
    triangle(squarepos.x-gridsize/4, squarepos.y+gridsize/3, squarepos.x+gridsize/4, squarepos.y+gridsize/3, squarepos.x, squarepos.y+gridsize);

    fill(8, 100, 80);
    ellipse(squarepos.x, squarepos.y, gridsize, gridsize);

    fill(0);
    ellipse(squarepos.x-gridsize/6, squarepos.y+gridsize/4, gridsize/4, gridsize/4);
    ellipse(squarepos.x+gridsize/6, squarepos.y+gridsize/4, gridsize/4, gridsize/4);
  }
  //UP
  if ((velocity.x == 0 && velocity.y == -gridsize )||(velocity.x == 0 && velocity.y == 0)) {

    fill(250, 80, 150);
    triangle(squarepos.x-gridsize/4, squarepos.y-gridsize/3, squarepos.x+gridsize/4, squarepos.y-gridsize/3, squarepos.x, squarepos.y-gridsize);

    fill(8, 100, 80);
    ellipse(squarepos.x, squarepos.y, gridsize, gridsize);

    fill(0);
    ellipse(squarepos.x-gridsize/6, squarepos.y-gridsize/4, gridsize/4, gridsize/4);
    ellipse(squarepos.x+gridsize/6, squarepos.y-gridsize/4, gridsize/4, gridsize/4);
  }
  //Left
  if (velocity.x == -gridsize && velocity.y == 0) {

    fill(250, 80, 150);
    triangle(squarepos.x-gridsize/3, squarepos.y-gridsize/4, squarepos.x-gridsize/3, squarepos.y+gridsize/4, squarepos.x-gridsize, squarepos.y);

    fill(8, 100, 80);
    ellipse(squarepos.x, squarepos.y, gridsize, gridsize);

    fill(0);
    ellipse(squarepos.x-gridsize/4, squarepos.y-gridsize/6, gridsize/4, gridsize/4);
    ellipse(squarepos.x-gridsize/4, squarepos.y+gridsize/6, gridsize/4, gridsize/4);
  }
  //Right
  if (velocity.x == gridsize && velocity.y == 0) {

    fill(250, 80, 150);
    triangle(squarepos.x+gridsize/3, squarepos.y-gridsize/4, squarepos.x+gridsize/3, squarepos.y+gridsize/4, squarepos.x+gridsize, squarepos.y);

    fill(8, 100, 80);
    ellipse(squarepos.x, squarepos.y, gridsize, gridsize);

    fill(0);
    ellipse(squarepos.x+gridsize/4, squarepos.y-gridsize/6, gridsize/4, gridsize/4);
    ellipse(squarepos.x+gridsize/4, squarepos.y+gridsize/6, gridsize/4, gridsize/4);
  }
}
