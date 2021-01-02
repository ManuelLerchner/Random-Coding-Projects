
int n = 20;
float alpha; 
float t;

float px, py;
  PImage img;

void setup() {
  fullScreen();
  //size(600, 400);
  n-=1;
  colorMode(HSB, 360, 1, 1);


  img = loadImage("Gabs.png");
  image(img, 0, 0);
  img.resize(200,200);
}

void draw() {

  background(55);
  noiseSeed(1);
  px=noise(t)*width;
  noiseSeed(3);
  py=noise(t)*height;
  t+=0.005;


  fill(255);
  ellipse(px, py, 10, 10);

image(img, px-img.pixelWidth/2, py-150);




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
