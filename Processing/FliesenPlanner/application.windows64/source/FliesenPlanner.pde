float scale=1;
float range=20;
PVector transOffset=new PVector();

PVector mouseGlobal=new PVector();
PVector mouseAbsolutePos=new PVector();
boolean drawingMode;
boolean measuringMode;
float Area;
boolean toPrint;

boolean ortho=true;
boolean showGrid=true;

String notification="";
long notificationSet;

boolean pause;


PVector fliesenSize=new PVector(0.6, 0.6);
PVector fliesenOffset=new PVector();
float fliesenRotation=0;


ArrayList<Vertex> Vertices=new ArrayList();

void setup() {
  size(1000, 800);
  surface.setTitle("FliesenPlanner");
  surface.setResizable(true);

  Vertices.add(new Vertex(new PVector()));
}

void draw() {
  background(51);
  if (toPrint) background(255);
  translate(width/2, height/2);

  showGrid();
  if (!pause) {
    showText();
    setMouse();


    showPolygon();
    showDrawing();
    showMeasure();
    Util();
  }
}
