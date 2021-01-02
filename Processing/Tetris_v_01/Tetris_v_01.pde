PVector gridSize = new PVector(9, 20);
int gridLen = 40;
int c;


ArrayList<PVector> Static = new ArrayList();
ArrayList<Block> Blocks = new ArrayList();
ArrayList<PVector> col = new ArrayList();


void settings() {
  size(round(gridSize.x*gridLen), round(gridSize.y*gridLen));
}


void setup() {
  rectMode(CENTER);

  setShapes();
  Blocks.add(new Block(1, new PVector(4, 4)));
}

void draw() {
  background(51);




  for (int i =0; i<Static.size(); i++) {


    PVector pos = absPos(Static.get(i));
    colorMode(HSB, 255, 100, 100);

    fill(map(col.get(i).x, 0, shapes.size(), 0, 255), 100, 100);


    rect(pos.x, pos.y, gridLen, gridLen);

    colorMode(RGB, 255, 255, 255);
  }

  for (int i =0; i<Blocks.size(); i++) {
    Blocks.get(i).show();
    Blocks.get(i).move();



    if (! Blocks.get(i).stop) {
      for (part p : Blocks.get(i).Parts) {

        p.show();
      }
    }


    if ( Blocks.get(i).add) {
      Blocks.add(new Block(c, new PVector(4, 4)));
      Blocks.get(i).add=false;
      c++;
      c=c%7;
    }

    Blocks.get(i).Parts.clear();
  }





  grid();
}



void grid() {
  stroke(0);
  for (int i=0; i < width; i+=width/gridSize.x) {
    line(i, 0, i, height);
  }
  for (int i=0; i < height; i+=height/gridSize.y) {
    line(0, i, width, i);
  }
}






void keyPressed() {
  if (key == 'r') {
    Blocks.clear();
    col.clear();
    Static.clear();
    c=0;
    Blocks.add(new Block(floor(random(0,shapes.size())), new PVector(4, 4)));
  }
}
