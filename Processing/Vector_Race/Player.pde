class Player {
  PVector pos;
  PVector speed=new PVector();

  ArrayList<PVector> trace=new ArrayList();
  ArrayList<PVector> possibleMoves=new ArrayList();

  float hue;
  int punishedRounds;

  boolean animate;
  boolean oneTimeEffect;

  Player(PVector pos) {
    this.pos=pos;
    hue=map(Players.size(), 0, players, 0, TWO_PI);
    trace.add(toPixelCoordinate(pos));
    getPossibleMoves();
  }


  void show() {
    showTrace();

    PVector screenPos=toPixelCoordinate(pos);
    PVector speedScreen=toPixelCoordinate(speed);

    //Speed
    stroke(hue, 1, 0.7);
    line(screenPos, screenPos.copy().add(speedScreen));

    //Circle
    fill(hue, 1, 1);
    stroke(0, 0, 0);
    ellipse(screenPos, gridLen*0.8); 

    if ( punishedRounds>0) {
      textSize(15);
      text("Punished:" +punishedRounds, screenPos.x, screenPos.y);
    }

    stroke(hue, 1, 0.7);
  }



  void showPossibleMoves() {
    stroke(hue, 0.5, 1);
    fill(hue, 0.2, 0.5);
    for (PVector pos : possibleMoves) {
      ellipse(toPixelCoordinate(pos), gridLen/2);
    }
    fill(hue, 1, 1);
  }

  void showTrace() {
    noFill();
    stroke(hue, 1, 0.8);
    beginShape();
    for (PVector P : trace) {
      vertex(P);
    }
    endShape();
    fill(hue, 1, 0.8);
    for (PVector P : trace) {
      ellipse(P, 5);
    }
  }


  void getPossibleMoves() {
    possibleMoves.clear();
    if (punishedRounds==0) {
      for (int i=-1; i <=1; i++) {
        for (int j=-1; j <=1; j++) {
          PVector possibleMove=pos.copy().add(speed.copy().add(i, j));
          possibleMoves.add(possibleMove);
        }
      }
    } else {
      possibleMoves.add(pos.copy());
      punishedRounds--;
    }
  }

  boolean isInside(PVector in) {
    if (in.x>=-1&&in.x<=n) {
      if (in.y>=-1&&in.y<=m) {
        return true;
      }
    }
    return false;
  }




  boolean interact() {

    //Outside
    if (!isInside(pos.copy().add(speed.copy()))) { //middle pos outside map
      punishedRounds=round(max(abs(speed.x), abs(speed.y)));
      speed.set(0, 0);  
      trace.add(toPixelCoordinate(pos));
      return true;
    }

    //Move
    for (int i=-1; i <=1; i++) {
      for (int j=-1; j <=1; j++) {
        PVector possibleMove=pos.copy().add(speed.copy().add(i, j));
        if (possibleMoves.contains(possibleMove)) {
          if (mouseGamePos.equals(possibleMove)) {
            speed.add(i, j);
            return true;
          }
        }
      }
    }
    return false;
  }

  PVector animationSpeed;
  PVector gamePos;
  PVector prev;
  PVector startAnimatePos;

  int steps=1000;
  int i=0;

  int playBackSpeed=40;

  void move() {
    for (int k=0; k < playBackSpeed; k++) {
      if (animate) {
        line(toPixelCoordinate(startAnimatePos), toPixelCoordinate(pos));

        if (!overlapps(pos)) {
          prev=gamePos;
        }

        pos.add(animationSpeed);
        gamePos=new PVector(round(pos.x), round(pos.y));

        if (!overlapps(pos)&&Map.containsKey(gamePos)) {
          Map.get(gamePos).handleCollision(this);
        }

        if (i>=steps) {
          animate=false;
          oneTimeEffect=false;
          pos=prev;
          i=0;
          getPossibleMoves();

          trace.add(toPixelCoordinate(pos));
        }
        i++;
      }
    }
  }
}
