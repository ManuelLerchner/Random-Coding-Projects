PVector gridSize = new PVector(12, 10);
int gridLen = 80;

float PercentBombs=16;

int AmountBombs  = round((PercentBombs*gridSize.x*gridSize.y)/100);
boolean floodFillEnabled = true;
PFont HUD, normal;
int turn = 0;


void settings() {
  size(round(gridLen*gridSize.x), round(gridLen*gridSize.y));
  HUD= loadFont("GANGBANGCRIME-200.vlw");
  normal=loadFont("SansSerif.plain-20.vlw");
}

void setup() {
  rectMode(CENTER);
  textAlign(CENTER, CENTER);
  PlaceBombs();
}


void draw() {
  background(51,62,54);

  showHelp();

  for (int i = 0; i < Guesses.size(); i++) {
    Guesses.get(i).show();
    Guesses.get(i).detectLost();
  }

  for (Flag f : Flags) {
    f.show();
    f.detectWon();
  }

  grid();
  HUD();
}


/////////////////////////////////////////////////////////////////////


void PlaceBombs() {
  while (Bombs.size() <AmountBombs) {
    PVector gridPos = new PVector(floor(random(gridSize.x)), floor(random(gridSize.y)));
    boolean overlapp = false;

    for (Bomb b : Bombs) {
      float dist = b.gridPos.dist(gridPos);
      if (dist == 0) {
        overlapp = true;
      }
    }
    for (Guess g : Guesses) {
      float dist = g.gridPos.dist(gridPos);
      if (dist == 0) {
        overlapp = true;
      }
    }
    if (!overlapp) {
      Bombs.add(new Bomb(gridPos));
    }
  }
}


void showHelp() {
  if (keyPressed) {
    if (key == 'h') {
      for (Guess g : Guesses) {
        g.ShowHelp();
      }
      for (Flag f : Flags) {
        f.ShowHelp();
      }
    }
  }
}

void grid() {
  stroke(0);
  for (int i=gridLen; i < width; i+=gridLen) {
    line(i, 0, i, height);
    for (int j=gridLen; j < height; j+=gridLen) {
      line(0, j, width, j);
    }
  }
}

void HUD() {
  if (lost) {
    for (Bomb b : Bombs) {
      b.show();
    }
  }

  if (!keyPressed) {
    pushMatrix();
    translate(width/2, height/2+height/40);
    noStroke();
    if (won || lost) {
      fill(30, 190);
      rect(0, -height/40, width, height);
    }
    rotate(0.2*sin(millis()/1000.0)*cos(millis()/1000.0));
    colorMode(HSB, 70, 100, 100);

    textFont(HUD, 48);
    if (lost) {
      won = false;

      textSize(min(width, height)/5+min(width, height)/20*abs(sin(millis()/1000.0)));
      fill(frameCount%70, 100, 100);
      text("Lost", 0, 5+min(width, height)/8*sin(millis()/1000.0));

      fill(0, 0, 0);
      textSize(min(width, height)/5.333+min(width, height)/26.666*abs(sin(millis()/1000.0)));
      text("Lost", 0, min(width, height)/8*sin(millis()/1000.0));
    }

    if (won) {
      textSize(min(width, height)/5+min(width, height)/20*abs(sin(millis()/1000.0)));
      fill(frameCount%70, 100, 100);
      text("Won", 0, 5+min(width, height)/8*sin(millis()/1000.0));

      fill(0, 0, 0);
      textSize(min(width, height)/5.333+min(width, height)/26.666*abs(sin(millis()/1000.0)));
      text("Won", 0, min(width, height)/8*sin(millis()/1000.0));
    }
    textFont(normal, 12);

    colorMode(RGB, 255, 255, 255);
    popMatrix();
  }


  fill(#14B4A8, 200);
  stroke(0);
  rectMode(CORNERS);
  rect(width-126, height-40, width, height);
  rect(width-165, height-40, width-126, height);
  rectMode(CENTER);
  textSize(12);
  textAlign(LEFT);

  fill(0);
  text("Bombs Remaining:\n" + (AmountBombs-Flags.size()), width-120, height-25);
  text("Turn:\n" + turn, width-160, height-25);
  textAlign(CENTER);
}
