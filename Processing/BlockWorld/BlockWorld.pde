PImage Background;
PImage Map;
PImage GrassImage;
PImage StoneImage;
PImage ChestImage;
PImage FeeLeftImage, FeeRightImage;
PImage PlayerLeft, PlayerRight;
PImage KoopaLeftImage, KoopaRightImage;
PImage PistoleLeftImage, PistoleRightImage;
PImage SwordLeftImage, SwordRightImage;
PImage BulletImage;
PImage PistoleLeftSmallImage;
PImage SwordLeftSmallImage;

PVector Gravity = new PVector(0, 0.5);
PVector MiniMapSize = new PVector(160, 0);
int BlockSize=50;
boolean mapEnabled = true;
boolean Help = true;

ArrayList<GrassBlock> Grass = new ArrayList();
ArrayList<FinishBlock> Finish = new ArrayList();
ArrayList<StoneBlock> Stone = new ArrayList();
ArrayList<ChestBlock> Chest = new ArrayList();
ArrayList<Bullet> Bullets = new ArrayList();
ArrayList<GravityBlock> GravityChanger  = new ArrayList();
ArrayList<Fee> Feen = new ArrayList();
ArrayList<Koopa> Koopas = new ArrayList();
ArrayList<PVector> HitableBlocks = new ArrayList();
float yoff;
PVector MinimapSegments = new PVector();
PVector MinimapPos = new PVector();
PVector initialMapSize=new PVector();
boolean showMap=true;

Player P1;

void setup() {
  Map=loadImage("Map.png");
  size(1200, 800);
  rectMode(CENTER);
  imageMode(CENTER);
  textAlign(CENTER, CENTER);

  setMap();
  setPictures();
}

void draw() {
  background(Background);

  for (GrassBlock G : Grass) {
    G.update();
  }
  for (StoneBlock S : Stone) {
    S.update();
  }
  for (FinishBlock F : Finish) {
    F.update();
  }
  for (ChestBlock C : Chest) {
    C.update();
  }
  for (GravityBlock G : GravityChanger) {
    G.update();
  }
  for (Bullet G : Bullets) {
    G.update();
  }
  for (Fee E : Feen) {
    E.update();
  }
  for (Koopa K : Koopas) {
    K.update();
  }


  if (Bullets.size()>30) {
    Bullets.remove(0);
  }
  for (int i=Chest.size()-1; i >= 0; i--) {
    if (Chest.get(i).opening==true) {
      Chest.remove(i);
    }
  }



  if (P1.Inv.size()>11) {
    P1.Inv.remove(11);
  }

  P1.update();

  showHud();
  HitableBlocks.clear();
}






void showHud() {
  if (mapEnabled) {
    if (P1.pos.x>width-MiniMapSize.x*1.2&&P1.pos.y<MiniMapSize.y*1.2) {
      showMap=false;
    } else {
      showMap=true;
    }
    if (showMap) {
      fill(255);
      float rows=MinimapSegments.x;
      float cols=MinimapSegments.y;

      Map.resize(round(MiniMapSize.x), round(MiniMapSize.y));
      image(Map, width-MiniMapSize.x/2-10, MiniMapSize.y/2+10);

      stroke(0);
      strokeWeight(1);
      for (int i=0; i <= rows; i++) {
        line(width-MiniMapSize.x-10+(MiniMapSize.x)/rows*i, 10, width-MiniMapSize.x-10+(MiniMapSize.x)/rows*i, MiniMapSize.y+10);
      }
      for (int i=0; i <= cols; i++) {
        line(width-MiniMapSize.x-10, MiniMapSize.y+10-(MiniMapSize.y/cols)*i, width-10, MiniMapSize.y+10-(MiniMapSize.y/cols)*i);
      }


      PVector pos =new PVector(-(P1.pos.x-(Stone.get(Stone.size()-1).pos.x)), -(P1.pos.y-(Stone.get(Stone.size()-1).pos.y)));
      PVector MappedPos = new PVector(map(pos.x, BlockSize*initialMapSize.x, 0, 0, MiniMapSize.x), map(pos.y, 0, BlockSize*initialMapSize.y, 0, MiniMapSize.y));
      fill(255, 0, 0);
      PVector PlayerPos = new PVector(width-MiniMapSize.x-10+MappedPos.x, MiniMapSize.y+10-MappedPos.y);
      ellipse(PlayerPos.x, PlayerPos.y, 6, 6);


      float rad =100;
      stroke(255);
      strokeWeight(2);
      noFill();
      ellipse(width-rad/2-10, MiniMapSize.y+rad/2+30, rad, rad);
      line(width-rad/2-10, MiniMapSize.y+rad/2+30, width-rad/2-10+rad/3*cos(P1.angle+PI/2), MiniMapSize.y+rad/2+30+rad/3*sin(P1.angle+PI/2));
      stroke(255, 0, 0);
      strokeWeight(10);
      point(width-rad/2-10+rad/3*cos(P1.angle+PI/2), MiniMapSize.y+rad/2+30+rad/3*sin(P1.angle+PI/2));
    }
  }
}
