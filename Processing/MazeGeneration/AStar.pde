void AddAllLegalNeighbours(PVector pos) {
  if ( !explored.contains(new PVector(pos.x, pos.y))) {
    explored.add(new PVector(pos.x, pos.y));
  }
  if (pos.x != 0) {
    if ( Walls[int(pos.x)][int(pos.y)].showLeft == false) {
      nearby.add(new PVector(pos.x-1, pos.y));
      if ( !explored.contains(new PVector(pos.x-1, pos.y))) {
        movingDirections.add(new PVector(pos.x, pos.y, 1));
      }
    }
  }
  if (pos.x!=gridDimensions.x-1) {
    if ( Walls[int(pos.x)][int(pos.y)].showRight == false) {
      nearby.add(new PVector(pos.x+1, pos.y));
      if ( !explored.contains(new PVector(pos.x+1, pos.y))) {
        movingDirections.add(new PVector(pos.x, pos.y, 3));
      }
    }
  }
  if ( pos.y != 0) {
    if ( Walls[int(pos.x)][int(pos.y)].showTop == false) {
      nearby.add(new PVector(pos.x, pos.y-1));
      if ( !explored.contains(new PVector(pos.x, pos.y-1))) {
        movingDirections.add(new PVector(pos.x, pos.y, 0));
      }
    }
  }
  if (pos.y !=gridDimensions.y-1) {
    if ( Walls[int(pos.x)][int(pos.y)].showBot == false) {
      nearby.add(new PVector(pos.x, pos.y+1));
      if ( !explored.contains(new PVector(pos.x, pos.y+1))) {
        movingDirections.add(new PVector(pos.x, pos.y, 2));
      }
    }
  }
}


void CalcNeighbourValues() {
  for (PVector p : nearby) {
    int tempG = gVal[int(currentCheck.x)][int(currentCheck.y)]+1;
    if (explored.contains(p)) {
      if (tempG<gVal[int(p.x)][int(p.y)] ) {
        gVal[int(p.x)][int(p.y)] =  tempG;
      }
    } else {
      gVal[int(p.x)][int(p.y)] =  tempG;
    }

    if (Heuristic==0) {
      //Taxicab
      hVal[int(p.x)][int(p.y)]= floor(10*(abs(p.x-target.x)+abs(p.y-target.y)));
    } else if (Heuristic ==1) {
      //Euclidean
      hVal[int(p.x)][int(p.y)]= floor(10*dist(p.x, p.y, target.x, target.y));
    } 

    fVal[int(p.x)][int(p.y)]= gVal[int(p.x)][int(p.y)]+ hVal[int(p.x)][int(p.y)];

    if (!Neighbours.contains(new PVector(p.x, p.y))) {
      Neighbours.add(new PVector(p.x, p.y));
    }
  }
}

PVector bevore = new PVector();
PVector now = new PVector();

void showSolution() {

  if (!found && FieldsLeft ==-1) {
    for (int i=0; i < speedSolveMaze; i++) {
      //SelectNeightbours||CalcNeighbourValues
      AddAllLegalNeighbours(currentCheck);
      CalcNeighbourValues();

      //AddAllPosValsToArray
      for (PVector p : Neighbours) {
        if (!explored.contains(p)) {
          PosValues.append(int(fVal[int(p.x)][int(p.y)]));
        }
      }
      //SelectNextGuess
      for (PVector p : Neighbours) {
        if (!explored.contains(p)) {
          if ( fVal[int(p.x)][int(p.y)]==PosValues.min()) {
            allPossibleMoves.add(new PVector(p.x, p.y));
            hValues.append(hVal[int(p.x)][int(p.y)]);
          }
        }
      }
      for (PVector p : allPossibleMoves) {
        if ( hValues.min()==hVal[int(p.x)][int(p.y)]) {
          currentCheck.set(p.x, p.y);
        }
      }
      //CheckFound
      if (currentCheck.equals(new PVector(target.x, target.y))) {
        found=true;
        finalPath.add(new PVector(target.x, target.y));
        println("Solved!");
      }
      allPossibleMoves.clear();
      nearby.clear();
      PosValues.clear();
      hValues.clear();

      //Draw Searcher
      if (speedSolveMaze<100) {
        fill(0, 255, 0, 200);
        rect(currentCheck.x*size, currentCheck.y*size, size, size);
      }
      if (found) {
        break;
      }
    }
  }

  if (speedSolveMaze<100) {
    //ShowMarkers
    stroke(255, 100);
    fill(255, 100);
    strokeWeight(0.5);
    if (found) {
      noStroke();
      noFill();
    }
  }
  if (!stop) {
    for (PVector p : movingDirections) {
      PVector center = new PVector(p.x*size+size/2, p.y*size+size/2);
      if (p.z==0) {  
        if (speedSolveMaze<100) {
          line(center.x, center.y, center.x, center.y-size/3);
          ellipse(center.x, center.y-size/3, size/5, size/5);
        }
        if ( Walls[int(p.x)][int(p.y)].showTop ==false && finalPath.contains(new PVector(p.x, p.y-1))) {
          if (!finalPath.contains(new PVector(p.x, p.y))) {
            finalPath.add(new PVector(p.x, p.y));
          }
        }
      } 
      if (p.z==2) {
        if (speedSolveMaze<100) {
          line(center.x, center.y, center.x, center.y+size/3);
          ellipse(center.x, center.y+size/3, size/5, size/5);
        }
        if ( Walls[int(p.x)][int(p.y)].showBot ==false &&finalPath.contains(new PVector(p.x, p.y+1))) {
          if (!finalPath.contains(new PVector(p.x, p.y))) {
            finalPath.add(new PVector(p.x, p.y));
          }
        }
      } 
      if (p.z==1) {    
        if (speedSolveMaze<100) {
          line(center.x, center.y, center.x-size/3, center.y);
          ellipse(center.x-size/3, center.y, size/5, size/5);
        }
        if (Walls[int(p.x)][int(p.y)].showLeft ==false &&finalPath.contains(new PVector(p.x-1, p.y))) {
          if (!finalPath.contains(new PVector(p.x, p.y))) {
            finalPath.add(new PVector(p.x, p.y));
          }
        }
      } 
      if (p.z==3) {  
        if (speedSolveMaze<100) {
          line(center.x, center.y, center.x+size/3, center.y);
          ellipse(center.x+size/3, center.y, size/5, size/5);
        }
        if (Walls[int(p.x)][int(p.y)].showRight==false &&finalPath.contains(new PVector(p.x+1, p.y))) {
          if (!finalPath.contains(new PVector(p.x, p.y))) {
            finalPath.add(new PVector(p.x, p.y));
          }
        }
      }
    }
    if (finalPath.contains(PlayerPos)) {
      stop=true;
      movingDirections.clear();
    }
  }

  //Connect Winning Path
  if (found) {
    noFill();
    strokeWeight(3);
    stroke(0);
    beginShape();
    bevore.set(target);
    for (PVector p : finalPath) {
      now.set(p);
      if (bevore.dist(now)<=1) {
        vertex(p.x*size+size/2, p.y*size+size/2);
        bevore.set(now);
      }
    }
    endShape();
  }
}
