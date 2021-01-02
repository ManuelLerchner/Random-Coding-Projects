class Path {
  Tag A, B;
  Node Start, End;
  AStar AStar;

  ArrayList<Way> possibleWays=new ArrayList();
  float pathLen=0;

  Path(Tag A, Tag B) {
    this.A=A;
    this.B=B;
    this.Start=A.N;
    this.End=B.N;

    findPossibleWays();

    AStar=new AStar(Start, End, possibleWays);
    AStar.Solve();

    getPathLength();
  }


  //////////////////////////////////////////////////////////////////////////////////////////
  void show() {
    stroke(255);
    strokeWeight(2);
    noFill();

    //Path
    beginShape();
    for (Node N : AStar.Path) {
      vertex(N.screenPos.x, N.screenPos.y);
    }
    endShape();

    //Text: Pathlength
    if (AStar.Path.size()!=0) {
      Node middle=AStar.Path.get(AStar.Path.size()/2);
      fill(0);
      text(pathLen+"km", middle.screenPos.x+5, middle.screenPos.y+5);
    }
  }


  //////////////////////////////////////////////////////////////////////////////////////////
  void findPossibleWays() {
    println("start expanding");
    expandWay(A.W, B.W);
    for (Long key : Ways.keySet()) {
      Way W = Ways.get(key);
      W.explored=false;
    }
    println("Possible Ways expanded");
  }

  //////////////////////////////////////////////////////////////////////////////////////////
  void expandWay(Way startWay, Way endWay) {
    possibleWays.add(startWay);
    for ( Node S : startWay.Vertices) {
      for (Long key : Ways.keySet()) {
        Way W = Ways.get(key);
        if (!W.explored && (W.type.equals("highway")||W.type.equals("access")||W.type.equals("aerialway")||W.type.equals("bridge"))) {
          if (W.Vertices.contains(S)) {
            if (!startWay.equals(endWay)) {
              W.explored=true;
              expandWay(W, endWay);
            } else {
              return;
            }
          }
        }
      }
    }
  }

  //////////////////////////////////////////////////////////////////////////////////////////
  void getPathLength() {
    for (int i=1; i < AStar.Path.size(); i++) {
      Node C=AStar.Path.get(i);
      Node P=AStar.Path.get(i-1);
      double dx = 71.5 * (C.lon - P.lon);
      double dy = 111.3 * (C.lat - P.lat);
      pathLen+=Math.sqrt(dx * dx + dy * dy);
    }
    pathLen=roundToNPlaces(pathLen, 4);
  }
}
