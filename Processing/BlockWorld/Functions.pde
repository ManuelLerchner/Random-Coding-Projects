void setMap() {
  Map.loadPixels();
  yoff =floor(height/BlockSize)-Map.height;
  for (int i=0; i < Map.width; i++) {
    for (int j=0; j < Map.height; j++) {
      int loc = i+j*Map.width;
      if (Map.pixels[loc]==color(0, 0, 0)) {
        Stone.add(new StoneBlock(new PVector(i, j+yoff)));
      }
      if (Map.pixels[loc]==color(100, 150, 50)) {     
        Grass.add(new GrassBlock(new PVector(i, j+yoff)));
      }
      if (Map.pixels[loc]==color(0, 255, 0)) {
        P1=new Player(new PVector(i, j+yoff));
      }
      if (Map.pixels[loc]==color(255, 0, 0)) {
        Finish.add(new FinishBlock(new PVector(i, j+yoff)));
      }
      if (Map.pixels[loc]==color(125, 100, 50)) {
        Chest.add(new ChestBlock(new PVector(i, j+yoff)));
      }
      if (Map.pixels[loc]==color(255, 255, 0)) {
        GravityChanger.add(new GravityBlock(new PVector(i, j+yoff)));
      }
      if (Map.pixels[loc]==color(50, 0, 255)) {
        Feen.add(new Fee(new PVector(i, j+yoff)));
      }
      if (Map.pixels[loc]==color(200, 200, 50)) {
        Koopas.add(new Koopa(new PVector(i, j+yoff)));
      }
    }
  }
  initialMapSize=new PVector(Map.width, Map.height);
  MinimapSegments.set((Map.width * BlockSize)/float(width), ((Map.height)*BlockSize)/float(height));
  MiniMapSize.y=MiniMapSize.x*(Map.height/float(Map.width));
}


void setPictures() {
  Background=loadImage("Background1.png");
  Background.resize(width, height);
  GrassImage=loadImage("Grass.png");
  GrassImage.resize(BlockSize, BlockSize);
  StoneImage=loadImage("Stone.png");
  StoneImage.resize(BlockSize, BlockSize);
  ChestImage=loadImage("PokeBall.png");
  PlayerLeft=loadImage("Player2Left.png");
  PlayerLeft.resize(BlockSize, BlockSize);
  PlayerRight=mirrow(PlayerLeft);
  KoopaLeftImage=loadImage("Koopa.png");
  KoopaRightImage=mirrow(KoopaLeftImage);
  FeeLeftImage=loadImage("FeeLeft.png");
  FeeRightImage=mirrow(FeeLeftImage);
  BulletImage=loadImage("Bullet.png");
  PistoleLeftImage=loadImage("PistoleLeft.png");
  PistoleRightImage=mirrow(PistoleLeftImage);
  SwordLeftImage=loadImage("SwordLeft.png");
  SwordRightImage=mirrow(SwordLeftImage);

  PistoleLeftSmallImage=PistoleLeftImage.copy();
  SwordLeftSmallImage=SwordLeftImage.copy();
  PistoleLeftSmallImage.resize(40, 40);
  SwordLeftSmallImage.resize(30, 30);

  float scale =0.8;
  PistoleLeftImage.resize(round(scale*BlockSize), round(scale*BlockSize));
  PistoleRightImage=mirrow(PistoleLeftImage);
}

PVector changeCordinates(PVector in) {
  PVector out=new PVector();
  PVector temp = new PVector();
  if (in.x*in.y<=Map.width*(Map.height+(height/BlockSize-Map.height))) {
    temp.x=map(in.x, 0, Map.width, 0, Map.width*BlockSize)+BlockSize/2;
    temp.y=map(in.y, 0, Map.height, 0, Map.height*BlockSize)+BlockSize/2;
    out.set(temp);
  }
  return out;
}


PImage mirrow(PImage in) {
  PImage out = in.copy();
  for (int j=0; j < in.height; j++) {
    for (int i=0; i < in.width; i++) {
      int loc = i+in.width*j;
      int Mirrowedloc = (in.width-i-1)+in.width*j;
      out.pixels[loc]= in.pixels[Mirrowedloc];
    }
  }
  return out;
}

void MoveMap() {
  float cornerX = 500;
  float cornerY = 200;
  if (P1.pos.x>width-cornerX) {
    for (GravityBlock G : GravityChanger) {
      G.move(-(cornerX-(width-P1.pos.x))/20.0, 0);
    }
    for (Bullet G : Bullets) {
      G.move(-(cornerX-(width-P1.pos.x))/20.0, 0);
    }
    for (ChestBlock G : Chest) {
      G.move(-(cornerX-(width-P1.pos.x))/20.0, 0);
    }
    for (Fee G : Feen) {
      G.move(-(cornerX-(width-P1.pos.x))/20.0, 0);
    }
    for (Koopa G : Koopas) {
      G.move(-(cornerX-(width-P1.pos.x))/20.0, 0);
    }
    for (FinishBlock G : Finish) {
      G.move(-(cornerX-(width-P1.pos.x))/20.0, 0);
    }
    for (GrassBlock G : Grass) {
      G.move(-(cornerX-(width-P1.pos.x))/20.0, 0);
    }
    for (StoneBlock G : Stone) {
      G.move(-(cornerX-(width-P1.pos.x))/20.0, 0);
    }
    P1.pos.x-=(cornerX-(width-P1.pos.x))/20.0;
  } 
  if (P1.pos.x<cornerX) {
    for (GravityBlock G : GravityChanger) {
      G.move((cornerX-P1.pos.x)/20.0, 0);
    }
    for (ChestBlock G : Chest) {
      G.move((cornerX-P1.pos.x)/20.0, 0);
    }
    for (Bullet G : Bullets) {
      G.move((cornerX-P1.pos.x)/20.0, 0);
    }
    for (Fee G : Feen) {
      G.move((cornerX-P1.pos.x)/20.0, 0);
    }
    for (Koopa G : Koopas) {
      G.move((cornerX-P1.pos.x)/20.0, 0);
    }
    for (FinishBlock G : Finish) {
      G.move((cornerX-P1.pos.x)/20.0, 0);
    }
    for (GrassBlock G : Grass) {
      G.move((cornerX-P1.pos.x)/20.0, 0);
    }
    for (StoneBlock G : Stone) {
      G.move((cornerX-P1.pos.x)/20.0, 0);
    }
    P1.pos.x+=(cornerX-P1.pos.x)/20.0;
  }  
  if (P1.pos.y>height-cornerY) {
    for (GravityBlock G : GravityChanger) {
      G.move(0, -(2*cornerY-(height-P1.pos.y))/20.0);
    }
    for (ChestBlock G : Chest) {
      G.move(0, -(2*cornerY-(height-P1.pos.y))/20.0);
    }
    for (Bullet G : Bullets) {
      G.move(0, -(2*cornerY-(height-P1.pos.y))/20.0);
    }
    for (Fee G : Feen) {
      G.move(0, -(2*cornerY-(height-P1.pos.y))/20.0);
    }
    for (Koopa G : Koopas) {
      G.move(0, -(2*cornerY-(height-P1.pos.y))/20.0);
    }
    for (FinishBlock G : Finish) {
      G.move(0, -(2*cornerY-(height-P1.pos.y))/20.0);
    }
    for (GrassBlock G : Grass) {
      G.move(0, -(2*cornerY-(height-P1.pos.y))/20.0);
    }
    for (StoneBlock G : Stone) {
      G.move(0, -(2*cornerY-(height-P1.pos.y))/20.0);
    }
    P1.pos.y-= (2*cornerY-(height-P1.pos.y))/20.0;
  }
  if (P1.pos.y<cornerY) {
    for (GravityBlock G : GravityChanger) {
      G.move(0, (2*cornerY-P1.pos.y)/20.0);
    }
    for (ChestBlock G : Chest) {
      G.move(0, (2*cornerY-P1.pos.y)/20.0);
    }
    for (Bullet G : Bullets) {
      G.move(0, (2*cornerY-P1.pos.y)/20.0);
    }
    for (Fee G : Feen) {
      G.move(0, (2*cornerY-P1.pos.y)/20.0);
    }
    for (Koopa G : Koopas) {
      G.move(0, (2*cornerY-P1.pos.y)/20.0);
    }
    for (FinishBlock G : Finish) {
      G.move(0, (2*cornerY-P1.pos.y)/20.0);
    }
    for (GrassBlock G : Grass) {
      G.move(0, (2*cornerY-P1.pos.y)/20.0);
    }
    for (StoneBlock G : Stone) {
      G.move(0, (2*cornerY-P1.pos.y)/20.0);
    }
    P1.pos.y+=(2*cornerY-P1.pos.y)/20.0;
  }
}
