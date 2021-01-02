class AStar {
  Node current;
  Node previous;
  Node closest;
  Node start, end;

  ArrayList<Way> possibleWays = new ArrayList();
  ArrayList<Node> Open = new ArrayList();
  ArrayList<Node> Closed = new ArrayList();
  ArrayList<Node> Path = new ArrayList();
  boolean foundPath;

  AStar(Node start, Node end, ArrayList<Way> possibleWays) {
    this.possibleWays=possibleWays;
    this.end=end;
    this.start=start;
    current=start;
    closest=start;
    Open.add(current);
    setNeighbours();
  }

  void setNeighbours() {
    for (Way W : possibleWays) {
      for (int i=1; i < W.Vertices.size(); i++) {
        Node N=W.Vertices.get(i);
        Node P =W.Vertices.get(i-1);
        if (!N.Neighbours.contains(P)) {
          N.Neighbours.add(P);
        }
        if (!P.Neighbours.contains(N)) {
          P.Neighbours.add(N);
        }
      }
    }
  }

  //////////////////////////////////////////////////////////////////////////////////////
  void Solve() {
    println("start solving");
    if (!start.equals(end)) {
      int tries=0;
      while (tries<100000) {
        if (!foundPath) {
          current=NodeWithLowestF(Open);
          if (current!=null) {
            Open.remove(current);
            Closed.add(current);
            if (current.equals(end)) {
              foundPath=true;
              Path.add(end);
              previous=end.parent;
              continue;
            }
            ArrayList<Node> nei=current.Neighbours;
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
          }
        } else {
          if (!previous.equals(start)) {
            Path.add(previous);
            closest=previous;
            previous=previous.parent;
          } else {
            Path.add(start);
            println("found Path\n");
            return;
          }
        }
        tries++;
      }
      println("No Path found");
    }
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


float Metric(Node curr, Node end) {
  return dist(curr.pos.x, curr.pos.y, end.pos.x, end.pos.y);
}
