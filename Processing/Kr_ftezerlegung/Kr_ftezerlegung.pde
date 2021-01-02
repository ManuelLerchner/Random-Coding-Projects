float fg = 200;


// p = ]-150,150[
int p = 10;
int v = 280;


void setup() {
  size(800, 800);
  background(110);
  rectMode(CORNERS);
}

void draw() {
  background(100);
  
  
  

  textSize(30);
  text("Kräftezerlegung", 250, 60);

  translate(width/2, height/2 + 150);
  float mouseP = -((mouseY-(height/2+150)));
  
  float hoehe = mouseP;
  float alpha;

  alpha = atan(hoehe/300);


  PVector H = new PVector (0, fg*sin(alpha));
  PVector N = new PVector (0, fg*cos(alpha));
  PVector G = new PVector(0, fg);
  
  beginShape();
  
  strokeWeight(1);
  stroke(255, 165, 0,50);
 vertex(mouseX-width/2,0);
  vertex(mouseX-width/2,mouseY-(height/2+150));
  vertex(150,mouseY-(height/2+150));
  vertex(-150,0);
  
  endShape(CLOSE);



  //Dreieck
  beginShape();

  stroke(0);
  strokeWeight(3);
  noFill();
  vertex(-150, 0);
  vertex(150, 0);
  vertex(150, (mouseY-height/2-150));
  endShape(CLOSE);


  //Vector
  translate(p, (mouseY-height/2-150)*(150+p)/300);

  strokeWeight(5);

  //G
  stroke(255, 0, 0);
  line(0, 0, G.x, G.y);

  //H   
  stroke(0, 255, 0);
  H.rotate(PI/2-alpha);
  line(0, 0, H.x, H.y);

  //N
  stroke(0, 0, 255);
  N.rotate(2*PI-alpha);
  line(0, 0, N.x, N.y);



  //Hilflinien

  beginShape();

  strokeWeight(1);
  stroke(255, 165, 0);

  vertex(N.x, N.y);
  vertex(G.x, G.y);
  vertex(H.x, H.y);

  endShape();

  //Punkte
  stroke(0);
  strokeWeight(25);
  point(0, 0);
  strokeWeight(10);
  point(H.x, H.y);
  point(G.x, G.y);
  point(N.x, N.y);
  



  //Beschriftung

  textSize(15);
  text("G", G.x, G.y+20);
  text("H", H.x-10, H.y-10);
  text("N", N.x+10, N.y+10);

  text("Höhe:  "+floor(hoehe), -350, -(mouseY-height/2-150)*(150+p)/300+40);
  text("Breite: 300", -350, -(mouseY-height/2-150)*(150+p)/300+20);
  text("Winkel:  "+round(degrees(alpha)), -350, -(mouseY-height/2-150)*(150+p)/300+60);
  
  text("mouseX: " + mouseX, -400,-(mouseY-height/2-150)*(150+p)/300-500);
   text("mouseY: " + mouseY, -400,-(mouseY-height/2-150)*(150+p)/300-480);
  







  /////////////////////////////////////////////////////////////////////////////////////////
  // Zweites Kräfted.

  //Vector
  translate(-p, -(mouseY-height/2-150)*(150+p)/300);
  translate(v, -200);

  strokeWeight(5);

  //G
  stroke(255, 0, 0);
  line(0, 0, G.x, G.y);

  //H   
  stroke(0, 255, 0);
  //   H.rotate(PI/2-alpha);
  line(0, 0, H.x, H.y);

  //N
  stroke(0, 0, 255);
  //  N.rotate(2*PI-alpha);
  line(0, 0, N.x, N.y);



  //Hilflinien

  beginShape();

  strokeWeight(1);
  stroke(255, 165, 0);

  vertex(N.x, N.y);
  vertex(G.x, G.y);
  vertex(H.x, H.y);


  endShape(CLOSE);

  //Punkte
  stroke(0);
  strokeWeight(15);
  point(0, 0);
  strokeWeight(10);
  point(H.x, H.y);
  point(G.x, G.y);
  point(N.x, N.y);


  //Beschriftung

  textSize(15);
  text("G", G.x, G.y+20);
  text("H", H.x-10, H.y-10);
  text("N", N.x+10, N.y+10);
}
