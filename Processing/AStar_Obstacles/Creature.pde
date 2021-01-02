class Creature {
  Cell Cell;
  AStar Solver;

  Creature(Cell c) {
    this.Cell=c;
  }

  void updatePath() {
    if (frameCount%EnemieReactionTime==0) {
      Solver=new AStar(Cell, Player.Cell);
      Solver.Solve();
    }
  }

  void hunt() {
    if ((0.5*frameCount)%playerMovementSpeed==0) {
      boolean moved=false;
      if (Solver.closest!=null) {
        if (!Occupied.contains(Solver.closest.absPos)) {
          if (!Solver.closest.wall) { 
            if (Solver.closest.equals(Player.Cell)) {
              println("found");
            }
            Cell.start=false;
            Occupied.remove(Cell.absPos);
            Cell=Solver.closest;
            Solver.closest= Solver.closest.child;
            Occupied.add(Cell.absPos);
            moved=true;
          }
        }
      }
      if (!moved) {
        moveRandom();
      }
    }
  }

  void moveRandom() {
    ArrayList<Cell> nei = AStar.neighbours(Cell, allowDiag);
    int i = floor(random(nei.size()));
    if (nei.size()>0) {
      Cell next=nei.get(i);
      if (next.wall==false&&!Occupied.contains(next.absPos)) {
        Cell.start=false;
        Occupied.remove(Cell.absPos);
        Cell=next;
        Occupied.add(Cell.absPos);
      }
    }
  }
}
