import java.util.Map;

int n, m;
float stepX, stepY;
PVector mouseGamePos;


int players=2;
int currTurnNumber;
ArrayList<Player> Players=new ArrayList();


PImage mapImage;
PVector spawnPoint;
float gridLen;
HashMap<PVector, MapType> Map=new HashMap();


void settings() {
  initScreen();
  setMap();
}


void setup() {
  colorMode(HSB, TWO_PI, 1, 1);
  textAlign(RIGHT, BOTTOM);

  for (int i=0; i < players; i++) {
    Players.add(new Player(spawnPoint.copy()));
  }
}


void draw() {
  background(0, 0, 0.3);

  drawGrid();
  showMap();

  for (Player P : Players) {
    P.show();
    P.move();
  }
  Players.get(currTurnNumber).showPossibleMoves();

  //Mouse
  mouseGamePos=toGameCoordinate(new PVector(mouseX, mouseY));
  ellipse(toPixelCoordinate(mouseGamePos), gridLen*0.6);

  //Hud
  textSize(20);
  text("PlayerTurn: "+ (currTurnNumber+1), width-10, height-10);
}





void mousePressed() {
  if (Players.get(currTurnNumber).interact()) {
    currTurnNumber++;
    if (currTurnNumber==players) {
      for (Player P : Players) {
        P.animate=true;
        P.animationSpeed=new PVector(P.speed.x/P.steps, P.speed.y/P.steps);
        P.gamePos=P.pos;
        P.startAnimatePos=P.gamePos.copy();
      }
    }
    currTurnNumber%=players;
  }
}
