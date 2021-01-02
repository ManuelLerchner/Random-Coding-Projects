class AStar {
  Cell current;
  Cell previous;
  Cell closest;
  Cell start, end;

  ArrayList<Cell> Open = new ArrayList();
  ArrayList<Cell> Closed = new ArrayList();
  boolean foundPath;

  AStar(Cell start, Cell end) {
    this.end=end;
    this.start=start;
    current=start;
    closest=start;
    Open.add(current);
  }

  //////////////////////////////////////////////////////////////////////////////////////
  void Solve() {
    for (Cell C : Cells) {
      C.reset();
    }
    for (int i=0; i < AStar_solvingSpeed; i++) {
      if (Open.size()>0) {
        if (!foundPath) {
          current=CellWithLowestF(Open);
          Open.remove(current);
          Closed.add(current);

          if (current.equals(end)) {
            foundPath=true;
            previous=end.parent;
            continue;
          }

          ArrayList<Cell> nei=neighbours(current, allowDiag);
          current.calcCost(end);
          for (Cell C : nei) {
            C.calcCost(end);
            C.visited=true;
          }

          for (Cell C : nei) {
            if (Closed.contains(C)||C.wall==true) {
              continue;
            }
            if (current.gCost+Metric(current, C)<C.gCost||!Open.contains(C)) {
              C.gCost=current.gCost+Metric(current, C);
              C.fCost=C.gCost+C.hCost;
              C.parent=current;
              if (!Open.contains(C)) {
                Open.add(C);
              }
            }
          }
        } else {
          if (!previous.equals(start)) {
            previous.isPath=true;
            previous.parent.child=previous;
            closest=previous;
            previous=previous.parent;
          } else {
            return;
          }
        }
      }
    }
  }

  //////////////////////////////////////////////////////////////////////////////////////
  ArrayList<Cell> neighbours(Cell t, boolean allowDiag) {
    ArrayList<Cell> nei=new ArrayList();
    for (int i=-1; i <=1; i+=1) {
      for (int j=-1; j <=1; j+=1) {
        if (!(i==j&&i==0)) {
          if (abs(i*j)!=1||allowDiag) {
            Cell n=cellAtPos(int(t.absPos.x+i), int(t.absPos.y+j));
            if (n.wall==false) {
              if (n.start==false) {
                nei.add(n);
              }
            }
          }
        }
      }
    }
    return nei;
  }

  //////////////////////////////////////////////////////////////////////////////////////
  Cell bestGCost(ArrayList<Cell> List) {
    int lowestSoFar=1000000;
    Cell Best=List.get(0);
    for (Cell c : List) {
      if (c.gCost<lowestSoFar) {
        lowestSoFar=c.gCost;
        Best=c;
      }
    }
    return Best;
  }

  //////////////////////////////////////////////////////////////////////////////////////
  Cell CellWithLowestF(ArrayList<Cell> List) {
    int lowestFSoFar=1000000;
    int lowesHSoFar=1000000;
    ArrayList<Cell> BestF=new ArrayList();
    Cell best=List.get(0);
    for (Cell c : List) {
      if (c.fCost<=lowestFSoFar) {
        lowestFSoFar=c.fCost;
        BestF.add(c);
      }
    }
    if (BestF.size()>0) {
      for (Cell c : BestF) {
        if (c.hCost<lowesHSoFar&&c.fCost==lowestFSoFar) {
          best=c;
          lowesHSoFar=c.hCost;
        }
      }
    }
    return best;
  }
}
