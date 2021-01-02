class Curve {

  ArrayList<PVector> path;
  PVector current;


  Curve() {
    path = new ArrayList<PVector>();
    current = new PVector();
  }

  void setX(float x) {
    current.x = x;
  }

  void setY(float y) {
    current.y =y;
  }

  void addPoint() {

    path.add(current);
  
  }
  
  void reset(){
   path.clear(); 
  }

  void show() {
    stroke(#895515);
    strokeWeight(1);
    beginShape();
    for (PVector v : path) {

      vertex(v.x, v.y);
     
    };
    endShape();
    
    strokeWeight(2);
    stroke(170,40,10);
    point(current.x,current.y);
    
      current = new PVector();
  }
}
