class AStar {
  Node current;
  Node previous;
  Node closest;
  Node start, end;

  ArrayList<Node> Open = new ArrayList();
  ArrayList<Node> Closed = new ArrayList();
  boolean foundPath;

  AStar(Node start, Node end) {
    this.end=end;
    this.start=start;
    current=start;
    closest=start;
    Open.add(current);
  }

  //////////////////////////////////////////////////////////////////////////////////////
  void Solve(int speed) {
    for (int i=0; i < speed; i++) {
      if (!foundPath) {
        if (current!=null) {
          current.current=false;
        }
        current=NodeWithLowestF(Open);
        if (current!=null) {

          current.current=true;
          Open.remove(current);
          Closed.add(current);

          if (current.equals(end)) {
            foundPath=true;
            end.isPath=true;
            previous=end.parent;
            continue;
          }

          ArrayList<Node> nei=neighbours(current);
          current.calcCost(end);
          for (Node C : nei) {
            C.calcCost(end);
          }

          for (Node C : nei) {
            if (Closed.contains(C)) {
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
          if (autoTest) {
            delay(700);
            reset();
          }
        }
      } else {
        if (!previous.equals(start)) {
          previous.isPath=true;
          closest=previous;
          previous=previous.parent;
        } else {
          start.isPath=true;
          return;
        }
      }
    }
  }

  //////////////////////////////////////////////////////////////////////////////////////
  ArrayList<Node> neighbours(Node t) {
    ArrayList<Node> nei=new ArrayList();

    for (Node N : t.Neighbours) {
      //if (!N.visited) {
      nei.add(N);
      // }
    }

    return nei;
  }

  //////////////////////////////////////////////////////////////////////////////////////
  Node bestGCost(ArrayList<Node> List) {
    float lowestSoFar=1000000;
    Node Best=List.get(0);
    for (Node c : List) {
      if (c.gCost<lowestSoFar) {
        lowestSoFar=c.gCost;
        Best=c;
      }
    }
    return Best;
  }

  //////////////////////////////////////////////////////////////////////////////////////
  Node NodeWithLowestF(ArrayList<Node> List) {
    float lowestFSoFar=1000000;
    float lowesHSoFar=1000000;
    ArrayList<Node> BestF=new ArrayList();
    Node best=null;
    for (Node c : List) {
      if (c.fCost<=lowestFSoFar) {
        lowestFSoFar=c.fCost;
        BestF.add(c);
      }
    }
    if (BestF.size()>0) {
      for (Node c : BestF) {
        if (c.hCost<lowesHSoFar&&c.fCost==lowestFSoFar) {
          best=c;
          lowesHSoFar=c.hCost;
        }
      }
    }
    return best;
  }
}
