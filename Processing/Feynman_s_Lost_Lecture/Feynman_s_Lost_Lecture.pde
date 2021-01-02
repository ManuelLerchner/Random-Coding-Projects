int n;
float px;
float py;
float pcx, pcy, alpha, r, g, b;
boolean perm;

void setup() {
  size(800, 800, P2D);
  background(60);
}

void draw() {

  float[] PointX = new float[n+1];
  float[] PointY = new float[n+1];

  if (dist(width/2, height/2, mouseX, mouseY)>height/2-6) {
    background(100);
    fill(255, 0, 0);
    textSize(width/50+7);
    text("Error", 20, 30);
  } else {
    background(60);
    textSize(width/50+3);
    fill(0, 255, 0);
    text("Anzahl Punkte: "+n, 20, 30);

    textSize(width/50+2);
    text("Reset: R", width-90, height-60);
    text("Fast: F", width-90, height-40);
    text("Perm: P ", width-90, height-20);
    textSize(width/60);
    fill(0);
    text("A Lerchner Ind. \nProduction",width-150,30);
  };

  if (n==0) {
    fill(0, 165, 255);
    textSize(width/50+5);
    text("MouseClick", 20, 60);
  } else {
    fill(0, 165, 255);
    textSize(width/50+5);
    text("MouseWheel", 20, 60);
  }
  fill(r, g, b);
  textSize(width/50+5);
  text("MouseClick || Key ", 20, height-20);

  translate(width/2, height/2);
  noFill();



  strokeWeight(1);
  stroke(255);
  ellipse(0, 0, width-12, height-12);


  px = mouseX-width/2;
  py = mouseY-height/2;




  //Mitte
  if (dist(px, py, 0, 0)<25) {
    stroke(255, 100);
    line(-25, 0, 25, 0);
    line(0, 25, 0, -25);
    px=0;
    py=0;
  }
  //Rechts
  if (dist(px, py, width/2-6, 0)<25) {
    stroke(255, 100);
    line(-25+width/2-6, 0, 25+width/2-6, 0);
    line(width/2-6, 25, width/2-6, -25);
    px=width/2-6;
    py=0;
  }


  for (int i = 0; i < n; i++) {
    //SetKoordsPC
    PointX[i] = cos(map(i, 0, n, 0, -TWO_PI))*(width/2-6);
    PointY[i] = sin(map(i, 0, n, 0, -TWO_PI))*(height/2-6);

    //Linie Kreis-Maus
    strokeWeight(1);
    if (perm == true) {
      stroke(0, 50-35*(1-pow(1.005, -n)));
    } else { 
      stroke(0, 100);
    };
    line(px, py, PointX[i], PointY[i]);


    //Punkte Kreis
    stroke(0);
    strokeWeight(12-12*(1-pow(1.005, -n)));
    point(PointX[i], PointY[i]);

    //Nummerierung
    fill(0);
    textSize(15-15*(1-pow(1.005, -n)));
    text(i+1, PointX[i]+5, PointY[i]+10);

    //Color
    r=map(mouseX, 0, width, 40, 255);
    g=map(mouseY, 0, height, 0, 255);

    //Rotierende Linien
    if (mousePressed || keyPressed || perm == true) {
      alpha = atan((py-PointY[i])/(px-PointX[i]));

      pushMatrix();
      translate((px+PointX[i])/2, (py+PointY[i])/2);
      rotate(alpha);

      stroke(r, g, b, 255);
      strokeWeight(1);
      line(0, -dist(px, py, PointX[i], PointY[i])/2, 0, dist(px, py, PointX[i], PointY[i])/2);
      popMatrix();
    }
  }


  if (dist(width/2, width/2, mouseX, mouseY)<=height/2-6 && n >= 10 && ((mousePressed || keyPressed || perm == true))) {

    //Connect Foci
    strokeWeight(2);
    stroke(255, 0, 0);
    line(px, py, 0, 0);


    //Connect Ends Links
    pushMatrix();
    stroke(0, 255, 0);
    strokeWeight(1);
    translate(px, py);
    if (px != 0 || py !=0) {
      rotate(atan(py/px));
    }
    if (px<0) {
      rotate(PI);
    } 
    line(    0, 0, ((width/2-6)-dist(0, 0, px, py))/2, 0);
    popMatrix();

    //Connect Ends Rechts
    pushMatrix();
    translate(0, 0);
    if (px != 0 || py !=0) {
      rotate(atan(py/px));
    }
    if (px<0) {
      rotate(PI);
    }
    line(    0, 0, -((width/2-6)-dist(0, 0, px, py))/2, 0);
    popMatrix();


    //1ter Foci
    stroke(200, 200, 0);
    strokeWeight(10);
    point(px, py);

    //2ter Foci
    stroke(200, 200, 0);
    strokeWeight(10);
    point(0, 0);
  } else {

    //Punkt Mouse
    stroke(200, 200, 0);
    strokeWeight(10);
    point(px, py);
  }
}



void mouseClicked() {
  n++;
}

void keyPressed() {
  if (key == 'r') {
    n=1;
  } else if (key == 'f') {
    n+=10;
  } else if (key == 'p') {
    if (perm == false) {
      perm = true;
    } else {
      perm = false;
    }
  }
}
void mouseWheel(MouseEvent event) {
  if (n > 0) {
    n-= event.getCount();
  };
}
