float a= 1;
float b=3;
float n=1;

void setup() {
  size(600, 600);
}

void draw() {
  background(51);
  translate(width/2, height/2);

  float r= map(1, -1.5, 1.5, -width/2, width/2);

  strokeWeight(18);
  stroke(0, 255, 0);
  point(r*cos(atan(b/a)), r* -sin(atan(b/a)));


  noFill();
  stroke(255);
  strokeWeight(1);
  ellipse(0, 0, 2*r, 2*r);

  text("r = " +(sqrt(a*a+b*b)), 70, 15);
  text("z_k = e^(i * ("+(degrees(atan(b/a)))/n +("° +2*k*Pi/n))"), width/2-200, height/2-20);
  text("n = " +n, -width/2+20, height/2-20);
  text("RedPoint ^" +int(n) + " = GreenPoint", -width/2+20, -height/2+20);


  stroke(255, 100);
  line(-width/2, 0, width/2, 0);
  line(0, -height/2, 0, height/2);




  beginShape();
  for (int i=0; i <= n-1; i++) {


    float x = cos(atan(b/a)/n+i*2*PI/n);
    float y = sin(atan(b/a)/n+i*2*PI/n);


    x=map(x, -1.5, 1.5, -width/2, width/2);
    y=map(y, 1.5, -1.5, -height/2, height/2);


    vertex(x, y);

    strokeWeight(15);
    stroke(255, 0, 0);
    point(x, y);


    strokeWeight(2);
    stroke(160, 120, 30);
  }
  endShape(CLOSE);
}

void mouseWheel(MouseEvent event) {
  float e = event.getCount();
  n-=e;

  n=constrain(n, 1, 10000);
}
