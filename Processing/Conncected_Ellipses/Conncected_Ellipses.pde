float n =5;
square s1;

void setup() {
  size(600, 600);
  rectMode(CENTER);
}

void draw() {
  background(90);

 float s = map(mouseX*mouseY,0,width*height,0,width/n);

  for (int i=0; i <= width; i+=width/n) {
    for (int j=0; j <= height; j+=height/n) {
      s1=new square(i, j, s*(sin(s/10)) );
      s1.show();
      
    }
  }
}
