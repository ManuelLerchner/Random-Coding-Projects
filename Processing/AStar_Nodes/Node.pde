class Node {
  PVector pos;
  ArrayList<Node> Neighbours=new ArrayList();
  boolean isPath;
  boolean current;
  float fCost, gCost, hCost;
  float rad=10;
  Node parent;
  float f;
  Node(PVector pos, float f) {
    this.pos=pos;
    this.f=f;
  }

  void show() {
    fill(255);
    stroke(0);
    rad=10;
    if (AStar.Closed.contains(this)) {
      fill(#C5F202);
      rad*=1.2;
    }
    if (isPath) {
      fill(#E102F2);
      rad*=1.5;
    }
    if (current) {
      rad*=1.5;
      fill(0);
    }
    if (AStar.Open.contains(this)) {
      rad*=1.2;
      fill(0, 125, 259);
    }
    ellipse(pos.x, pos.y, rad, rad);
    pos.x+=0.25*sin(millis()/1000.0+f);
    pos.y+=0.25*cos(millis()/1000.0+f*0.951);
  }

  void connect() {   
    stroke(0);
    for (Node N : Neighbours) {
      line(N.pos.x, N.pos.y, pos.x, pos.y);
    }
  }

  void calcCost(Node end) {
    hCost=Metric(this, end);
    fCost=hCost+gCost;
  }

  void reset() {
    isPath=false;
    current=false;
    fCost=0;
    gCost=0;
    hCost=0;
    rad=10;
  }
}


void resetNodes() {
  for (Node N : Nodes) {
    N.reset();
  }
}

float Metric(Node curr, Node end) {
  float dx=curr.pos.x-end.pos.x;
  float dy=curr.pos.y-end.pos.y;
 // return abs(dx)+abs(dy);
  return dist(curr.pos.x, curr.pos.y, end.pos.x, end.pos.y);
}


void findNeighbours(ArrayList<Node> in) {
  for (int i=0; i < 500; i++) {
    for (Node n : in) {
      if (n.Neighbours.size()<NodeConnections) {
        for (Node o : in) {
          if (!n.Neighbours.contains(o)) {
            if (!n.equals(o)) {
              if (n.pos.dist(o.pos)<i) {
                if (o.Neighbours.size()<NodeConnections) {
                  n.Neighbours.add(o);
                  o.Neighbours.add(n);
                }
              }
            }
          }
        }
      }
    }
  }
}




PVector[] positions={
  new PVector( 108.145164, 59.68727, 0.0 ), 
  new PVector( 153.87271, 259.57147, 0.0 ), 
  new PVector( 256.54327, 329.30713, 0.0 ), 
  new PVector( 292.83246, 340.19113, 0.0 ), 
  new PVector( 349.54523, 149.34378, 0.0 ), 
  new PVector( 286.1268, 323.60947, 0.0 ), 
  new PVector( 195.49973, 315.3183, 0.0 ), 
  new PVector( 57.772232, 51.486053, 0.0 ), 
  new PVector( 175.68011, 230.31572, 0.0 ), 
  new PVector( 151.07413, 192.05817, 0.0 ), 
  new PVector( 253.61603, 227.32635, 0.0 ), 
  new PVector( 179.4561, 65.10083, 0.0 ), 
  new PVector( 190.43333, 121.27651, 0.0 ), 
  new PVector( 361.8587, 103.529945, 0.0 ), 
  new PVector( 244.04874, 164.56602, 0.0 ), 
  new PVector( 53.308212, 224.89513, 0.0 ), 
  new PVector( 93.302315, 37.788567, 0.0 ), 
  new PVector( 265.6231, 79.331566, 0.0 ), 
  new PVector( 306.54218, 253.46646, 0.0 ), 
  new PVector( 276.3548, 145.68634, 0.0 )
};
