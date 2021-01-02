ArrayList<Bomb> Bombs = new ArrayList();

class Bomb {

  PVector gridPos;
  PVector absPos;

  Bomb(PVector gridPos_) {
    gridPos=gridPos_;
    absPos = new PVector(gridLen*(gridPos.x+0.5), gridLen*(gridPos.y+0.5));
  }


  void show() {
    strokeWeight(3);
    stroke(0);
    line(absPos.x, absPos.y, absPos.x, absPos.y-(gridLen*3.2/8.0));

    strokeWeight(2);
    fill(255, 0, 0);
    rect(absPos.x, absPos.y, (gridLen*5/8.0), (gridLen*5/8.0));
    strokeWeight(1);

    fill(255);
    textSize(gridLen*2/8.0);
    text("TNT", absPos.x, absPos.y);
  }
}
