




ArrayList<Segment> Segments=new ArrayList();
float angle=20;
float ratio=0.5;

Segment root;

void setup() {
  size(600, 600);
  colorMode(HSB, HALF_PI, 1, 1);
  root=new Segment(new PVector(width/2, height), 80, 3, PI/2);
}

void draw() {
  background(2, 0.1, 0.8);

  Segments.clear();
  Segments.add(root);
  root.noChildren=true;

  float ratio=map(mouseX, 0, width, 0.5, 1);
  float angle=map(mouseY, 0, height, 0, PI);




  for (int k=0; k < 14; k++) {
    for (int i=Segments.size()-1; i >=0; i--) {
      Segment S=Segments.get(i);
      if (S.noChildren) {
        S.createChildren(ratio, angle, 0.9);
      }
    }
  }


  for (Segment S : Segments) {
    S.show();
  }
}
