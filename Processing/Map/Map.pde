HashMap<Long, Node> Nodes = new HashMap<Long, Node>();
HashMap<Long, Way> Ways = new HashMap<Long, Way>();

String[] lines;

PVector transOffset=new PVector();
PVector mousePos=new PVector();
double minlat, minlon, maxlat, maxlon;
float scale=1;

Tag Start, End;
Path P;

void settings() {
  lines = loadStrings("mapBig.osm");

  //Parse
  setViewWindow(lines);
  addNodes(lines);
  addPaths(lines);
  double wid=1400;
  double hei=wid*(minlat- maxlat)/ (minlon- maxlon);
  size(round((float)wid), round((float)hei));
}


void draw() {
  background(51);
  translate(width/2, height/2);
  scale(scale);

  for (Long key : Ways.keySet()) {
    Way W = Ways.get(key);
    W.show();
  }

  for (Long key : Nodes.keySet()) {
    Node N = Nodes.get(key);
    N.update();
  }

  showPath();
}
