ArrayList<Bauteil> Bauteile=new ArrayList();
ArrayList<Line> Lines = new ArrayList();
ArrayList<Node> Nodes = new ArrayList();

int N=20;
float len;
boolean drawLine;


String HudText="";
PVector HudRectSize;
PVector HudPos;

float freq=50;

LinSolve LinSolve=new LinSolve();

void setup() {
  size(800, 800);
  rectMode(CENTER);
  len=width/float(N);


  PVector t=new PVector(2, 2);
  Bauteile.add(new Bauteil(new Resistor(t)));

  PVector t2=new PVector(5, 6);
  Bauteile.add(new Bauteil(new Capacitor(t2)));

  PVector t3=new PVector(6, 6);
  Bauteile.add(new Bauteil(new Resistor(t3)));

  PVector t4=new PVector(8, 6);
  Bauteile.add(new Bauteil(new VoltageSource(t4)));

  PVector t5=new PVector(8, 10);
  Bauteile.add(new Bauteil(new Inductor(t5)));
}

void draw() {
  background(200);
  Grid();
  mousePos=mapToGrid(mouseX, mouseY);

  HudText="";
  for (Line L : Lines) {
    L.hover();
    L.show();
  }

  for (Bauteil B : Bauteile) {

    B.update();
    B.hover();
    B.display();
  }
  HUD();
  setupMatrix();
}

void HUD() {
  if (HudText!="") {
    fill(50, 220);
    stroke(0);
    line(HudPos.x, HudPos.y+0.5*HudRectSize.y, mousePos.x*len, mousePos.y*len);
    rect(HudPos.x, HudPos.y, HudRectSize.x, HudRectSize.y);
    fill(255);
    text(HudText, HudPos.x-textWidth(HudText)/2, HudPos.y);
  }
}
