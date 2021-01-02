ArrayList<Flag> Flags = new ArrayList();
boolean won = false;
class Flag {

  PVector gridPos;
  PVector absPos;

  Flag(PVector gridPos_) {
    gridPos=gridPos_;
    absPos = new PVector(gridLen*(gridPos.x+0.5), gridLen*(gridPos.y+0.5));
  }


  void show() {
    fill(200, 200, 0);
    strokeWeight(2);
    stroke(0);
    line(absPos.x-(gridLen*2.3/8.0), absPos.y, absPos.x-(gridLen*2.3/8.0), absPos.y+(gridLen*3/8.0));
    rect(absPos.x, absPos.y-(gridLen*1/8.0), (gridLen*4.6/8.0), (gridLen*4/8.0));
    strokeWeight(1);
  }


  void ShowHelp() {
    fill(255, 0, 0);
    rect(absPos.x, absPos.y, gridLen, gridLen);
  }


  void detectWon() {
    if (sum() == AmountBombs && Guesses.size()==gridSize.x*gridSize.y-AmountBombs && Flags.size()==Bombs.size()) {
      won = true;
    }
  }


  int sum() {
    int val = 0;
    for (Flag f : Flags) {
      for (Bomb b : Bombs) {
        float dist = b.gridPos.dist(f.gridPos);
        if (dist == 0) {
          val++;
        }
      }
    }
    return val;
  }
}
