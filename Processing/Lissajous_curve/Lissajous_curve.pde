//Manuel Lerchner Industries


int raster =40;
int d = 40;
int r=d/2;
float angle=PI/2;

Curve [][] curves;



void setup() {
 //size(900, 900,P2D);
 fullScreen(P2D);
  background(0);
  noFill();




  curves = new Curve[raster][raster];

  for (int i=0; i < raster; i++) {
    for (int j=0; j < raster; j++) {

      curves[i][j] = new Curve();
    }
  }
}



void draw() {


  background(0);

  for (int i=2; i < raster; i++) {


    int cx = width/raster*i;
    int cy = width/(raster)*i;


    strokeWeight(1);
    stroke(255); 
    ellipse(cx, width/raster, d, d);
    ellipse(height/raster, cy, d, d);



    stroke(255);
    strokeWeight(7);
    point(cx+r*sin(angle*(i-1)), width/raster+r*cos(angle*(i-1)));
    point(height/raster+r*sin(angle*(i-1)), cy+r*cos(angle*(i-1)));

    stroke(100, 130);
    strokeWeight(1);
    line(cx+r*sin(angle*(i-1)), width/raster+r*cos(angle*(i-1)), cx+r*sin(angle*(i-1)), height);
    line(height/raster+r*sin(angle*(i-1)), cy+r*cos(angle*(i-1)), width, cy+r*cos(angle*(i-1)));


    for (int j=1; j < raster; j++) {       
      curves[j][i].setX(cx+r*sin(angle*(i-1)));
      curves[i][j].setY(cx+r*cos(angle*(i-1)));
    }


    if (angle< 2.5*PI) { 
      angle+=PI/8000;
    } else {
      angle=PI/2;
    };
  }

  for (int i=2; i < raster; i++) {
    for (int j=2; j < raster; j++) {
      curves[j][i].addPoint();
      curves[j][i].show();
      
      if(mousePressed){
       
    curves[i][j].reset();};
    }
  }
  
  textSize(15);
  text("A Lerchner Industries Production: ''Lissajous curve''", 30, 20);
}
