
HashMap<String, Node> Data = new HashMap<String, Node>();
PVector mousePos;

void setup() {
  size(400, 400);
  randomSeed(6);
  textAlign(CENTER, CENTER);

  Data.put("A", new Node("A", "B", 1));
  Data.put("B", new Node("B", "C,F", 20));
  Data.put("C", new Node("C", "D", 3));
  Data.put("D", new Node("D", "E", 10));
  Data.put("E", new Node("E", "", 5));
  Data.put("F", new Node("F", "D", 5));





  Graph G=new Graph(Data);
}

void draw() {
  background(151);
  mousePos=new PVector(mouseX, mouseY);
  for (String key : Data.keySet()) {
    Node D= Data.get(key);
    D.show();
    D.move();
  }
}



void mousePressed() {
  for (String key : Data.keySet()) {
    Node D= Data.get(key);
    if (D.pos.dist(mousePos)<10) {
      D.selected=!D.selected;
    }
  }
}
