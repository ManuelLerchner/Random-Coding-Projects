ArrayList<Segment> Segments = new ArrayList();
PVector translationVector = new PVector();
PVector mousePos= new PVector();
PVector addVector1 = new PVector();
PVector addVector2 = new PVector();
boolean GlobalSegmentSelected;
boolean GlobalSegmentEdit;
boolean DrawEnabled;
boolean DrawPointSelected;
boolean ShowAddWindow;
boolean ShowEditWindow;
//TextfelderSelected
boolean selectedName;
boolean AddNormalForm;
boolean AddExpForm;
boolean SelectedNormalForm1;
boolean SelectedNormalForm2;
boolean SelectedExpForm1;
boolean SelectedExpForm2;
boolean EditNameBool;
boolean EditNormalForm;
boolean EditExpForm;
boolean EditNormalForm1;
boolean EditNormalForm2;
boolean EditExpForm1;
boolean EditExpForm2;
boolean EditScaleBool;
//TextFeilder
String DrawPoint1 = " ";
String DrawPoint2 = " ";
String Re = "";
String Im = "";
String Mag = "";
String Phi = "";
String Name = "New";
String EditRe = "";
String EditIm = "";
String EditMag = "";
String EditPhi = "";
String EditName = "";
String EditScale = "";

float absScale=1;
int PointIndex;

color Violett = color(129, 1, 217);
color Cyian = color(0, 226, 223);
color Red = color(255, 34, 20);
color Green = color(0, 180, 33);
color White = color(255, 255, 255);
color EditColor;

void setup() {
  fullScreen();
  rectMode(CENTER);
  Segments.add(new Segment(new PVector(0, 100, 0), "Y"));
  Segments.add(new Segment(new PVector(100, 0, 0), "X"));
}

void draw() {
  background(71);
  pushMatrix();
  trans();
  for (Segment S : Segments) {
    S.move();
    S.show();
    S.edit();
  }
  popMatrix();
  DrawVectors();
  HUD();
}
