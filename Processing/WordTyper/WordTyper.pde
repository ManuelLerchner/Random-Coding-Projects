ArrayList<String> Dictionary = new ArrayList();
ArrayList<Word> Words = new ArrayList();

float leftMostWordX=10000;
float leftMostWordY;
float len;

PVector targetPos= new PVector();

int selected = -1;
boolean AnythingSel;
boolean CharRemoved;

int Points;
int HighScore;
int Health =3;
boolean lost = false;

int time=150;
int wordCount;

SpaceShip P1;
PImage Rocket;
ArrayList<Bullet> Bullets = new ArrayList();


int count;

void setup() {
  size(600, 400, P2D);
  rectMode(CENTER);
  imageMode(CENTER);
  textAlign(CENTER, CENTER);
  P1 = new SpaceShip();


  setDict();
  Words.add(new Word());
}

void draw() {
  background(51);

  //HUD
  text(Points +" Points", width-100, height-40);
  text(HighScore +" Highscore", width-100, height-25);
  text(Health +" HP", width-100, height-10);

  //HP
  if (Health ==0) {
    lost =true;
  }



  //Word Functions
  for (int i =Words.size()-1; i>=0; i--) {
    if (Words.get(i).WordSelected==true) {
      targetPos=Words.get(i).pos;
      fill(0, 255, 0);
      stroke(0, 255, 0);
      len =Words.get(i).word.length();
      rect(targetPos.x, targetPos.y+10, len*7, 2);
    }
    Words.get(i).show();

    if (!lost) {
      Words.get(i).move();
    }

    if (Words.get(i).remove==true) {
      Words.remove(i);
    }
  }


  //Bullet
  for (int i =Bullets.size()-1; i>=0; i--) {
    Bullet B = Bullets.get(i);
    B.show();
    if (B.remove) {
      Bullets.remove(i);
    }
  }


  //Player
  P1.show();

  //Add Words
  if (frameCount%time==0 && !lost && Words.size()<3) {
    Words.add(new Word());
  }
}



void setDict() {
  String[] lines = loadStrings("words.txt");

  for (int i = 0; i < lines.length; i++) {
    Dictionary.add(lines[i]);
  }
}
