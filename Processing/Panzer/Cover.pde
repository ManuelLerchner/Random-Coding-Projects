class Object {
  float x;
  float y;
  float w, h;

  Object() { 
    x=random(width);
    y=random(height/2-20, height/2+90);   

    w= random(30, 200);
    h= random(30, 100);
  }


  void show() {
    rectMode(CORNER);
    noStroke();
    fill(200,170,40);
    rect(x, y, w, h);
    stroke(0);
    strokeWeight(1);
  }
}
