
int n = 20;
flq

float px, py;

void setup() {
  //fullScreen();
  size(600, 400);
  n-=1;
  colorMode(HSB, 360, 1, 1);
}

void draw() {

  background(55);



  px= mouseX;
  py = mouseY;
  fill(255);
  ellipse(px, py, 10, 10);




  //text("N: " +(n+1) ,100,100);
  text("A Lerchner Ind. Prod", width-180, height-20);
  for (int i=0; i< width; i+=width/(n)) {
    for (int j=0; j < height; j+=height/(n)) {
      //Angle
      if ( px >=i && py <=j  ) {
        alpha= atan((abs(py-j))/( abs(px-i+0.01)));
      } else if ( px <=i && py <=j  ) {
        alpha= 1*PI-atan((abs(py-j))/( abs(px-i+0.01)));
      } else if ( px <=i && py >=j  ) {
        alpha= 1*PI+atan((abs(py-j))/( abs(px-i+0.01)));
      } else if ( px >=i && py >=j  ) {
        alpha= 2*PI-atan((abs(py-j))/( abs(px-i+0.01)));
      }



      Pfeil a = new Pfeil(i, j, alpha);  
      a.update();
    }
  }
}

void keyPressed() {
  if (key == 'q') {
    n++;
  } else if ( key == 'a' && n !=1 ) {
    n--;
  }
};
