ArrayList<Guess> Guesses = new ArrayList();
boolean lost = false;
class Guess {

  PVector gridPos;
  PVector absPos;

  Guess(PVector gridPos_) {
    gridPos=gridPos_;
    absPos = new PVector(gridLen*(gridPos.x+0.5), gridLen*(gridPos.y+0.5));
  }


  void show() {
    fill(255);
    noStroke();
    rect(absPos.x, absPos.y, gridLen, gridLen);

    if (neighbours(gridPos)!=0 || !floodFillEnabled) {
      textSize(gridLen*3/8.0);
      fill(0);
      text(neighbours(gridPos), absPos.x, absPos.y);
    }
  }


  void detectLost() {
    for (int i = 0; i<Bombs.size(); i++) {
      float dist = Bombs.get(i).gridPos.dist(gridPos);
      if (dist==0) {
        if (turn==1) {
          Bombs.remove(i);
          PlaceBombs();
        } else {
          lost=true;
        }
      }
    }
  }


  int neighbours(PVector gridPos) {
    int val = 0;
    for (Bomb p : Bombs) {
      float dist = p.gridPos.dist(gridPos);
      if (dist <= sqrt(2)) {
        val++;
      }
    }
    return val;
  }


  void ShowHelp() {
    fill(0, map(neighbours(gridPos), 0, 8, 50, 255), 0);
    for (int i=-gridLen; i <= gridLen; i+=gridLen) {
      for (int j=-gridLen; j <= gridLen; j+=gridLen) {
        rect(absPos.x+i, absPos.y+j, gridLen, gridLen);
      }
    }
  }
}


/////////////////////////////////////////////////////////////////////


void mousePressed() {
  PVector gridPos = new PVector(floor(map(mouseX, 0, width, 0, gridSize.x)), floor(map(mouseY, 0, height, 0, gridSize.y)));
  boolean overlapp = false;


  if (mouseButton ==LEFT) {
    for (Guess g : Guesses) {
      float dist = g.gridPos.dist(gridPos);
      if (dist ==0) {
        overlapp = true;
      }
    }

    for (Flag f : Flags) {
      float dist = f.gridPos.dist(gridPos);
      if (dist ==0) {
        overlapp = true;
      }
    }

    if (!overlapp) {
      Guesses.add(new Guess(gridPos));
      if (floodFillEnabled) {
        if ( Guesses.get(Guesses.size()-1).neighbours(Guesses.get(Guesses.size()-1).gridPos) == 0) {
          floodFill(gridPos);
        }
      }
    }
  }


  if (mouseButton ==RIGHT) {
    for (int i = Flags.size() - 1; i >= 0; i--) {
      float dist = Flags.get(i).gridPos.dist(gridPos);
      if (dist == 0) {
        overlapp = true;
        Flags.remove(i);
      }
    }

    for (Guess g : Guesses) {
      float dist = g.gridPos.dist(gridPos);
      if (dist == 0) {
        overlapp = true;
      }
    }

    if (!overlapp) {
      Flags.add(new Flag(gridPos));
    }
  }
  turn++;
}


void keyPressed() {
  if (key== 'r') {
    turn=0;
    Guesses.clear();
    Bombs.clear();
    Flags.clear();

    won = false;
    lost = false;

    PlaceBombs();
  }
}


void floodFill(PVector grid) {
  for (int i=-1; i <= 1; i++) {
    for (int j=-1; j <= 1; j++) {

      PVector temp = new PVector(grid.x, grid.y);
      temp.add(new PVector(i, j));

      if ((i!=0 || j!=0) && (temp.x>=0 && temp.x<gridSize.x) && (temp.y>=0 && temp.y<gridSize.y)) {
        boolean overlapp = false;

        for (Guess G : Guesses) {
          float dist = G.gridPos.dist(temp);
          if (dist == 0) {
            overlapp = true;
          }
        }

        if (!overlapp) {
          Guesses.add(new Guess(temp));

          if ( Guesses.get(Guesses.size()-1).neighbours(Guesses.get(Guesses.size()-1).gridPos) == 0) {
            floodFill(temp);
          }
        }
      }
    }
  }
}
