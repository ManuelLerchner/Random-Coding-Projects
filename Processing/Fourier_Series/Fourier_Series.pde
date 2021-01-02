float time = 0;
float now, last;
float r = 50;
float n = 1;
float x, y;
float[] A;
float[] B;
float vx = 200;
float vy = 200;
float cx = r+vx;
float cy = r+vy;

wave Wave1;
wave Wave2;

void setup() {
  size(800, 800);
  A=new float[0];
  B=new float[0];
}

void draw() {  
  background(51);
  now = millis();


  cx=constrain(cx, 0, width);
  cy=constrain(cy, 0, height);


  x=0;
  y=0;


  //LOOP
  for (int i=0; i < n; i++) {
    float prex =x;
    float prey =y;

    /////////////////////////FORMEL//////!!i starts a 0!!//////////////////////////////////////////////////////////////////////////////
    float freq =  (            (2*i+1)                                       );
    float basis = (            (2*i+1)                                       );
    /////////////////////////FORMEL////////////////////////////////////////////////////////////////////////////////////////////////////

    float rad = r*(4/(PI*basis));
    x += rad*cos(freq*time);
    y += rad*sin(freq*time);

    //Ellipses
    noFill();
    stroke(160, 120, 30, 200);
    strokeWeight(1);
    ellipse(cx+prex, prey+cy, 2*rad, 2*rad);

    //Connecting Lines
    stroke(255);
    line(cx+prex, prey+cy, cx+x, y+cy);
  }



  // Horizontal line
  stroke(255, 100);
  line(cx+x, y+cy, 400, y+cy);

  //Vertical line
  line(cx+x, cy+y, cx+x, 400);

  //Arc
  arc(400, 400, 2*((400)-(cx+x)), 2*((400)-(cx+x)), 0.5*PI, PI);

  //Sector Lines
  stroke(255);
  strokeWeight(1);
  line(400, 0, 400, height);
  line(0, 400, width, 400);

  //Controlls
  fill(20, 100);
  ellipse(width, 0, 100, 100);
  ellipse(width/2, 0, 100, 100);
  ellipse(width, height, 100, 100);

  //text
  fill(255);
  text("#Circles: " +int(n), width-200, height-10);
  text("A Lerchner Ind. Production", 20, 20);
  text("Controls:\n\nButtons Right Corners\nMouseWheel\nMouseDrag\nFixpoint Middle", 20, height-90);
  text("r ++", width-25, 25);
  text("r --", width-25, height-20);
  text("Reset", width/2-15, 20);




  //Add to wave
  Wave1=new wave(y, 400, cy, 1);
  Wave2=new wave(-x, 400, height-cx, 2);

  Wave1.show();
  Wave2.show();



  //Time
  if (time>= -TWO_PI) { 
    time-=TWO_PI/100;
  } else {
    time=-TWO_PI/100;
  };
  
 
}





void mouseWheel(MouseEvent event) {
  n-= event.getCount();
  n=constrain(n, 1, 10000);
}


void mouseDragged() {

  cx+=(mouseX-pmouseX);
  cy+=(mouseY-pmouseY);

  if (dist(mouseX, mouseY, 400, 400)<=20  && dist(cx, cy, 400, 400)<=r) {

    cx=400;
    cy=400;
  }
}


void mousePressed() {
  if ( dist(mouseX, mouseY, width, 0)<=(100)) {
    r+=2;
  }

  if ( dist(mouseX, mouseY, width, height)<=(100)) {
    r-=2;
  }

  if (dist(mouseX, mouseY, width/2, 0)<=100) {
      A=new float[0];
      B= new float[0];
      n=1;
      r=75;
      time=0;
  }

  r=constrain(r, 2, 600);
}
