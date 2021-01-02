boolean[][] Particles;

color[][] col;

void setup() {
  size(600, 600);
  Particles=new boolean[width][height];
  col=new color[width][height];
}

void draw() {
  background(51);

  loadPixels();
  fill(255);
  stroke(255);

  ArrayList<PVector> toSlide=new ArrayList();
  boolean[][] reserved =new boolean[width][height];


  for (int i =0; i<width; i++) {
    for (int j =height-1; j>=0; j--) {
      
      if (Particles[i][j]==true) {
        pixels[i+width*j]=col[i][j];

        if (i<width && i>=0 && j<width-2) {

          if (Particles[i][j+1]==false) {
            if (reserved[i][j+1]==false) {
              toSlide.add(new PVector(i, j, 0));
              reserved[i][j+1]=true;
            }
          } else {
            if (i<width-1 && i>0) {
              int dir=1;
              if (random(1)<=0.5) dir=-1;
              if (Particles[i+dir][j+1]==false) {
                if (reserved[i+dir][j+1]==false) {
                  toSlide.add(new PVector(i, j, dir));
                  reserved[i+dir][j+1]=true;
                }
              }
            }
          }
        }
      }
    }
  }

  updatePixels();



  for (PVector p : toSlide) {
    Particles[int(p.x)][int(p.y)]=false;
    Particles[int(p.x+p.z)][int(p.y)+1]=true;

    col[int(p.x+p.z)][int(p.y)+1]=col[int(p.x)][int(p.y)];
    col[int(p.x)][int(p.y)]=0;
  }






  if (mousePressed) {
    if (mouseButton==LEFT) {
      if (mouseX>0 && mouseX<width) {
        if (mouseY>0&&mouseY<height) {
          float t=204.42+millis()/300.0;
          col[mouseX][mouseY]=color(20+255*noise(t+52.12), 30+255*noise(t+123.12), 10+255*noise(t+673.2));
          Particles[mouseX][mouseY]=true;
        }
      }
    }
  }
}

void mouseDragged() {
  if (mouseX>5 && mouseX<width-5) {
    if (mouseY>5 && mouseY<height-5) {

      for (int i =-5; i<5; i++) {
        for (int j =-5; j<5; j++) {
          if (mouseButton==RIGHT) {
            Particles[mouseX+i][mouseY+j]=false;
            col[mouseX+i][mouseY+j]=0;
          } else {
            Particles[mouseX+i][mouseY+j]=true;
            float t=millis()/500.0;
            col[mouseX+i][mouseY+j]=color(20+255*noise(t+52.12), 30+255*noise(t+123.12), 10+255*noise(t+673.2));
          }
        }
      }
      
    }
  }
}
