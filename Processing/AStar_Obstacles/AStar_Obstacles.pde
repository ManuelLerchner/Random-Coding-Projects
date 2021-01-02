int n=20;
int AStar_solvingSpeed=1000;
int EnemieReactionTime=50;
int playerMovementSpeed=4;
boolean allowDiag=false;
ArrayList<Cell> Cells =new ArrayList();
ArrayList<Creature> Enemies= new ArrayList();
ArrayList<PVector> Occupied=new ArrayList();

Player Player;
AStar AStar;

void setup() {
  size(800, 800);
  textAlign(LEFT, TOP);

  for (int j=0; j < n; j++) {
    for (int i=0; i < n; i++) {
      Cells.add(new Cell(new PVector(i, j)));
    }
  }

  Player=new Player(cellAtPos(n-2, n-2));
  for (int i=1; i <= 5; i++) {
    Creature E =new Creature(cellAtPos(1, i));
    E.updatePath();
    Enemies.add(E);
  }
  AStar=new AStar(Player.Cell, Player.Cell);
}

void draw() {

  clear();
  for (Creature E : Enemies) {
    E.Cell.start=true;
    E.updatePath();
    E.hunt();
  }


  Player.move();

  for (Cell C : Cells) {
    C.show();
  }
}
