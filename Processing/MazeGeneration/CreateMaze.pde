void pickPossibleMoves() {
  if (mazeGenPos.x != 0) {
    if ( Walls[int(mazeGenPos.x-1)][int(mazeGenPos.y)].visited == false) {
      mazeGenNeighbours.add(new PVector(mazeGenPos.x-1, mazeGenPos.y));
    }
  }
  if (mazeGenPos.x!=gridDimensions.x-1) {
    if ( Walls[int(mazeGenPos.x+1)][int(mazeGenPos.y)].visited == false) {
      mazeGenNeighbours.add(new PVector(mazeGenPos.x+1, mazeGenPos.y));
    }
  }
  if (mazeGenPos.y != 0) {
    if ( Walls[int(mazeGenPos.x)][int(mazeGenPos.y-1)].visited == false) {
      mazeGenNeighbours.add(new PVector(mazeGenPos.x, mazeGenPos.y-1));
    }
  }
  if (mazeGenPos.y !=gridDimensions.y-1) {
    if ( Walls[int(mazeGenPos.x)][int(mazeGenPos.y+1)].visited == false) {
      mazeGenNeighbours.add(new PVector(mazeGenPos.x, mazeGenPos.y+1));
    }
  }
}

void Algorithm() {
  if (FieldsLeft>0) {
    if (mazeGenNeighbours.size()!=0) {
      int r = floor(random(mazeGenNeighbours.size()));
      PVector p = mazeGenNeighbours.get(r);
      if (mazeGenPos.x>p.x) {
        Walls[int(mazeGenPos.x)][int(mazeGenPos.y)].showLeft =false;
        Walls[int(mazeGenPos.x)-1][int(mazeGenPos.y)].showRight =false;
      } else if (mazeGenPos.x<p.x) {
        Walls[int(mazeGenPos.x)][int(mazeGenPos.y)].showRight =false;
        Walls[int(mazeGenPos.x)+1][int(mazeGenPos.y)].showLeft =false;
      } else if (mazeGenPos.y<p.y) {
        Walls[int(mazeGenPos.x)][int(mazeGenPos.y)].showBot =false;
        Walls[int(mazeGenPos.x)][int(mazeGenPos.y)+1].showTop =false;
      } else {
        Walls[int(mazeGenPos.x)][int(mazeGenPos.y)].showTop =false;
        Walls[int(mazeGenPos.x)][int(mazeGenPos.y)-1].showBot =false;
      }
      Walls[round(p.x)][round(p.y)].visited=true;
      Walls[round(p.x)][round(p.y)].index=millis();
      visitedMazePositions.add(new PVector(mazeGenPos.x, mazeGenPos.y));
      mazeGenPos.set(p);
      FieldsLeft--;
    } else if (visitedMazePositions.size()!=0) {
      int r = floor(random(visitedMazePositions.size()));
      PVector p = visitedMazePositions.get(r);
      mazeGenPos.set(p);
      visitedMazePositions.remove(r);
    }
    fill(255, 0, 0, 150);
    rect(mazeGenPos.x*size, mazeGenPos.y*size, size, size);
  } else if (FieldsLeft!=-1) {
    visitedMazePositions.clear();
    println("Done!, press 'h' to solve\n");
    FieldsLeft=-1;
  }
  mazeGenNeighbours.clear();
}
