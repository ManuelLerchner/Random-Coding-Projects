ArrayList<Node> Nodes = new ArrayList();
int AStar_solvingSpeed=1;
int frameCountModulo=1;
int NodeConnections=5;

boolean autoTest=false;
int n=1000;

AStar AStar;
void setup() {
  size(800, 800, P2D);
  // fullScreen();

  PVector smallest=new PVector(100000, 100000);
  PVector biggest=new PVector(100000, -100000);
  Node smallestNode=new Node(smallest, 0);
  Node biggestNode=new Node(smallest, 0);  
  for (int i=0; i < n; i++) {
    PVector p = new PVector(random(30, width-30), random(30, height-30));
    float f=random(1000);
    Node temp=new Node(p, f);
    if (p.x*p.y<smallest.y*smallest.y) {
      smallest=p;
      smallestNode=temp;
    }
    if (p.x*p.y>biggest.x*biggest.y) {
      biggest=p;
      biggestNode=temp;
    }
    Nodes.add(temp);
  }

  Node End=biggestNode;
  Node Start=smallestNode;
  findNeighbours(Nodes);
  AStar=new AStar(Start, End);
}

void draw() {
  background(51);

  if (mousePressed||autoTest) {
    if (mouseButton==LEFT||autoTest) {
      if (frameCount%frameCountModulo==0) {
        resetNodes();
        AStar=new AStar(AStar.start, AStar.end);
        AStar.Solve(AStar_solvingSpeed);
        AStar_solvingSpeed++;
      }
    }
  }

  for (Node N : Nodes) {
    N.connect();
  }
  winnigPath();
  for (Node N : Nodes) {
    N.show();
  }
  specialNodes();
}


///////////////////////////////////////////////////////////////////
void winnigPath() {
  stroke(#E59900);
  strokeWeight(4);
  for (Node N : AStar.Closed) {
    if (N.isPath) {
      Node par=N.parent;
      if (par!=null) {
        line(N.pos.x, N.pos.y, par.pos.x, par.pos.y);
      } else {
        if (autoTest) {
          //delay(1000);
          //reset();
        }
      }
    }
  }
  strokeWeight(1);
}

void specialNodes() {
  PVector startPos=AStar.start.pos;
  PVector endPos=AStar.end.pos;
  fill(255, 0, 0);
  ellipse(startPos.x, startPos.y, 20, 20);
  fill(0, 255, 0);
  ellipse(endPos.x, endPos.y, 20, 20);
  fill(255);
  text("Start", startPos.x+8, startPos.y+15);
  text("End", endPos.x+8, endPos.y+15);
}

void mousePressed() {
  if (mouseButton==RIGHT) {
    AStar.Solve(AStar_solvingSpeed);
  }
}
