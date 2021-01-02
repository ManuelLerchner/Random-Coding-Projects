ArrayList<Point> Points = new ArrayList();
ArrayList<Cluster> Clusters=new ArrayList();

int clusters=20;
void setup() {
  size(600, 600);

  for (int i=0; i < clusters; i++) {
    PVector pos = new PVector(random(50,width-50), random(50,height-50));
    for (int k=0; k < int(random(20,80)); k++) {
      Points.add(new Point(randPVector(pos, 20)));
    }
  }
}

void draw() {
  background(51);

  for (Point p : Points) {
    p.show();
  }

  for (Cluster c : Clusters) {
    c.show();
  }
}



void mousePressed() {
  Lloyd(clusters);
}
