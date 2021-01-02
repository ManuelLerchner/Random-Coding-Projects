class Cell {
  PVector absPos;
  PVector pos;
  float size=width/n;
  boolean wall;
  boolean start;
  boolean end;
  boolean visited;
  boolean isPath;
  int hCost;
  int fCost;
  int gCost;
  Cell parent;
  Cell child;


  Cell(PVector absPos) {
    this.absPos=absPos;
    this.pos=absPos.copy().mult(width/n);
    if (absPos.x*absPos.y==0) {
      wall=true;
    }
    if (absPos.x==n-1||absPos.y==n-1) {
      wall=true;
    }
  }

  void show() {
    stroke(100);
    fill(255);
    if (wall) {
      fill(0);
    } 
    //if (visited) {
    //  fill(255, 125, 125);
    //}
    //if (isPath) {
    //  fill(135, 189, 54);
    //}
    if (start) {
      fill(255, 0, 0);
    }
    if (end) {
      fill(0, 0, 255);
    }
    
    rect(pos.x, pos.y, size, size);
  }
  void reset() {
    visited=false;
    isPath=false;
  }

  void calcCost(Cell end) {
    hCost=Metric(this, end);
    fCost=hCost+gCost;
  }
}

int Metric(Cell curr, Cell end) {
  float dx=curr.absPos.x-end.absPos.x;
  float dy=curr.absPos.y-end.absPos.y;
  return floor(10*((abs(dx))+abs((dy))));
  //return floor(10*pow( pow(dx, 20)+pow(dy, 20), 1/20));
  //return floor(10*dist(curr.absPos.x,curr.absPos.y,end.absPos.x,end.absPos.y));
}

Cell cellAtPos(float i, float j) {
  return Cells.get(int(i)+int(j)*n);
}
