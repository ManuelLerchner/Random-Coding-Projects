class Curve {

  ArrayList<PVector> path;
  PVector current;
  

  Curve() {
    path = new ArrayList<PVector>();
    current = new PVector();}
  

  void setX(float x) {
    current.x = x; }
 
  void setY(float y) {
    current.y =y; }
 

  void addPoint() {
    path.add(current);
    current = new PVector();}
    
  void reset() {
    path.clear();}
  

  void show() {
    noFill();
    stroke(mouseX/5,mouseY/3,100);
    strokeWeight(1);
    
    beginShape();
      for (PVector v : path) {
      vertex(v.x, v.y);};
    endShape();}
  
}
