class EulerMethod {

  PVector pos;
  float hue;

  ArrayList<PVector> Vertices=new ArrayList();

  float stepSize=0.005;
  EulerMethod(PVector start) {
    pos=start;
  }

  int modulus=5;
  int counter;


  void update() {

    PVector grad=functionPrime(pos).mult(stepSize);
    pos.add(grad);
    
   

    if (counter%modulus==0) {
      Vertices.add(pos.copy());
    }
    counter++;
  }

  void show() {

    beginShape();
    stroke(hue, 1, 1);
    noFill();
    for (PVector V : Vertices) {
      PVector screenPos=toScreenPos(V);
      vertex(screenPos.x, screenPos.y);
    }

    endShape();
  }
}
