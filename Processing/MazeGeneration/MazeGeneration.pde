////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////
PVector gridDimensions = new PVector(30, 30);
float size = 30;
int speedCreateMaze = 10;
int speedSolveMaze=1;
int Heuristic=0; //0:=Taxicab Dist ; 1:=Eucliedean Dist
////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////

//MazeGenertation
PVector mazeGenPos = new PVector(round(gridDimensions.x/2), round(gridDimensions.y/2));
ArrayList<PVector> mazeGenNeighbours = new ArrayList();
ArrayList<PVector> visitedMazePositions = new ArrayList();
int FieldsLeft;
//Player
PVector PlayerPos = new PVector();
boolean up, down, left, right, won;
PVector target = new PVector(int(random(gridDimensions.x)), int(random(gridDimensions.y)));
//MazeSolver
gridWall[][] Walls = new gridWall[int(gridDimensions.x)][int(gridDimensions.y)];
int[][] gVal = new int[int(gridDimensions.x)][int(gridDimensions.y)];
int[][] hVal = new int[int(gridDimensions.x)][int(gridDimensions.y)];
int[][] fVal  = new int[int(gridDimensions.x)][int(gridDimensions.y)];
PVector currentCheck= new PVector();
IntList PosValues = new IntList();
IntList hValues = new IntList();
ArrayList<PVector> nearby = new ArrayList();
ArrayList<PVector> Neighbours = new ArrayList();
ArrayList<PVector> explored = new ArrayList();
ArrayList<PVector> movingDirections = new ArrayList();
ArrayList<PVector> finalPath = new ArrayList();
ArrayList<PVector> allPossibleMoves = new ArrayList();
boolean found;
boolean help;
boolean stop;
boolean solving;



void settings() {
  size(round(size*gridDimensions.x), round(size*gridDimensions.y), P2D);
}

void setup() {
  FieldsLeft =int(gridDimensions.x*gridDimensions.y);
  for (int i=0; i < int(gridDimensions.x); i++) {
    for (int j=0; j < int(gridDimensions.y); j++) {
      Walls[i][j]= new gridWall(new PVector(size*i, size*j), 0);
    }
  }
  println("Creating The Maze at speed: " +speedCreateMaze);
}


void draw() {
  background(51);

  //ShowAndGenerateMaze
  for (int i=0; i < speedCreateMaze; i++) {
    pickPossibleMoves();
    Algorithm();
  }
  for (int i=0; i < int(gridDimensions.x); i++) {
    for (int j=0; j < int(gridDimensions.y); j++) {
      Walls[i][j].show();
    }
  }

  //ShowHelp
  if (help) {
    showSolution();
  }

  //MovePlayer
  if (FieldsLeft ==-1) {
    move();
    fill(0, 255, 255);
    noStroke();
    rectMode(CENTER);
    rect(size*(PlayerPos.x+0.5), size*(PlayerPos.y+0.5), size-5, size-5);
    if (!won && PlayerPos.equals(new PVector(target.x, target.y))) {
      println("WON");
      won = true;
    } else if (!won) {
      fill(255, 255, 0);
      rect(size*(target.x+0.5), size*(target.y+0.5), size-5, size-5);
    }
    rectMode(CORNER);
  }
}



void keyPressed() {
  if (FieldsLeft==-1) {
    if (key == 'r') {
      FieldsLeft=0;

      PlayerPos.set(0, 0);
      currentCheck.set(0, 0);
      target = new PVector(int(random(gridDimensions.x)), int(random(gridDimensions.y)));

      mazeGenNeighbours.clear();
      visitedMazePositions.clear();
      PosValues.clear();
      nearby.clear();
      Neighbours.clear();
      explored.clear();
      movingDirections.clear();
      finalPath.clear();
      solving = false;
      found=false;
      help=false;
      stop=false;
      won=false;


      for (int i=0; i < int(gridDimensions.x); i++) {
        for (int j=0; j < int(gridDimensions.y); j++) {
          Walls[i][j]= new gridWall(new PVector(size*i, size*j), 0);
          gVal[i][j]=0;
          hVal[i][j]=0;
          fVal[i][j]=0;
        }
      }
      println(" ");
      setup();
    }
    if (key == 'm' && !solving) {
      target = new PVector(int(random(gridDimensions.x)), int(random(gridDimensions.y)));
    }
    if (key == 'h') {
      if (!help) {
        help=true;
        currentCheck.set(round(PlayerPos.x), round(PlayerPos.y));
        if (finalPath.size()==0) {
          println("Solving The Maze at speed: " +speedSolveMaze);
          solving = true;
        }
      }
      if (stop) {
        help=false;
        stop=false;
      }
    }
    if (key == 'w') {
      if (!up && start.equals(new PVector(0, 0)) && PlayerPos.y != 0 && Walls[round(PlayerPos.x)][round(PlayerPos.y)].showTop == false) {
        start.set(PlayerPos);
        up=true;
      }
    } 
    if (key == 's') {
      if (!down && start.equals(new PVector(0, 0)) && PlayerPos.y != gridDimensions.y-1 && Walls[round(PlayerPos.x)][round(PlayerPos.y)].showBot == false) {
        start.set(PlayerPos);
        down=true;
      }
    }
    if (key == 'a') {
      if ( !left && start.equals(new PVector(0, 0)) && PlayerPos.x != 0 && Walls[round(PlayerPos.x)][round(PlayerPos.y)].showLeft == false) {
        start.set(PlayerPos);
        left=true;
      }
    }
    if (key == 'd') {
      if (!right && start.equals(new PVector(0, 0)) && PlayerPos.x != gridDimensions.x-1 && Walls[round(PlayerPos.x)][round(PlayerPos.y)].showRight == false) {
        start.set(PlayerPos);
        right=true;
      }
    }
  }
}


//MovePlayer
PVector start = new PVector();
void move() {
  if (up==true) {
    PlayerPos.y-=0.1;
    if (up && abs(start.y-(PlayerPos.y))>0.99) {
      PlayerPos.y=round(start.y)-1;
      up=false;
      start.mult(0);
    }
  }
  if (down==true) {
    PlayerPos.y+=0.1;
    if (down && abs(start.y-(PlayerPos.y))>0.99) {
      PlayerPos.y=round(start.y)+1;
      down=false;
      start.mult(0);
    }
  }
  if (left==true) {
    PlayerPos.x-=0.1;
    if (left && abs(start.x-(PlayerPos.x))>0.99) {
      PlayerPos.x=round(start.x)-1;
      left=false;
      start.mult(0);
    }
  }
  if (right==true) {
    PlayerPos.x+=0.1;
    if (right && abs(start.x-(PlayerPos.x))>0.99) {
      PlayerPos.x=round(start.x)+1;
      right=false;
      start.mult(0);
    }
  }
}
