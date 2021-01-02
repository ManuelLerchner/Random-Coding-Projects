//sichtfeld 
double rangex;
double rangey=2;
//versch x
double xoffs = 0;
//versch y
double yoffs = 0;

int maxI =2;
int EscVal =2;
boolean axes = true;


void setup() {
  size(500, 500, P2D);
  //fullScreen(P2D);
  frameRate(1000);
  colorMode(HSB, 3600, 1, 1);
  rangex=((width)/float(height))*rangey;
}

void draw() {

  loadPixels();
  //JedesPixel
  for (int i=0; i < width; i+=1) {
    for (int j=0; j < height; j+=1) {
      //Maping
      double a= map2(i, 0, width, (-rangex+xoffs), (rangex+xoffs));
      double b= map2(j, 0, height, (-rangey+yoffs), (rangey+yoffs));
      int pindex = (i+j*width);

      //C
      double ac =a;
      double bc =b;

      int iter = 0;

      //Algorithm
      while (iter < maxI) {
        double aa = a*a-b*b;
        double bb = 2*a*b;

        a=aa+ ac;
        b=bb+ bc;
        //Breakpoint
        if (a*a+b*b >= EscVal*EscVal) {
          break;
        }
        iter++;
      }
      //Color
      if (iter == maxI) {  
        pixels[pindex] = color(0);
      } else {
        float col = map(sqrt( float(iter)/maxI), 0, 1, 0, 3600);
        pixels[pindex] =color (col, 1, map(col, 0, 2600, 0, 1));
      }
    }
  }

  updatePixels();
  if (key == 'm') {
    saveFrame("Mandelbrot-###.png");
  }



  //Achsen
  if (axes == true) {
    stroke(500, 1, 1, 255);
    strokeWeight(1);
    line(width/2, 0, width/2, height);
    line(0, height/2, width, height/2);
  } else
  { 
    strokeWeight(10);
    stroke(0, 1, 1);
    point(width/2, height/2);
  }


  //Text
  textSize(16);
  text("Max Iter.: " +maxI, 10, 20);
  text("Esc.Val.: " +EscVal, 10, 50);
  textSize(14);
  text("A Lerchner Ind. Production \n\n\nKeys: \nq | a,   w | s,   r,   p,  f \n\nMouse:\nDrag,  Zoom,  JumpTo", 10, height-160);
  text("dx: " + rangex/3, width-width/7-45, height-60);


  //dx
  stroke(0, 0, 1);
  strokeWeight(1);
  line(width-width/6-20, height-50, width-20, height-50);
  line(width-width/6-20, height-45, width-width/6-20, height-55);
  line(width-20, height-45, width-20, height-55);
}


//Zoom
void mouseWheel(MouseEvent event) {
  if (event.getCount()<0) {
    rangey *= 0.85;
    rangex=((width)/float(height))*rangey;
  } else {
    rangey *= 1/0.85;
    rangex=((width)/float(height))*rangey;
  }
}

//Sichtfenster
void mouseDragged() { 
  if (mouseButton == LEFT) {
    yoffs += rangex*0.001*(pmouseY-mouseY);
    xoffs += rangex*0.001*(pmouseX-mouseX);
  }
}

//Jump
void mousePressed() {
  if (mouseButton == RIGHT) {
    xoffs= map2(mouseX, width/2-(height/rangey)-xoffs*width/2/rangex, width/2+0.5*(height/rangey)-xoffs*width/2/rangex, -2, 1);
    yoffs= map2(mouseY, height/2+0.5*(height/rangey)-yoffs*(height/2/rangey), height/2-0.5*(height/rangey)-yoffs*(height/2/rangey), 1, -1);
  }
}

//Keys
void keyPressed() {
  if (key == 'r') {
    rangey=2;
    rangex=((width)/float(height))*rangey;
    xoffs=0;
    yoffs=0;
  }

  if (key =='q') {
    maxI += 1;
  } else if (key == 'a'&& maxI != 1) {
    maxI-=1;
  };

  if (key =='w') {
    EscVal +=1;
  } else if (key =='s' && EscVal != 1) {
    EscVal -=1;
  };

  if (key =='p') {
    if (axes == true) {
      axes = false;
    } else {
      axes = true;
    };
  };
  if (key =='f') {
    maxI+=10;
  }
}


double map2(double value, double start1, double stop1, double start2, double stop2) {
  return ((value - start1) / (stop1 - start1)) * (stop2 - start2) + start2;
}
