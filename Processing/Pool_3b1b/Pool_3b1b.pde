double posX1;
double posX2;

double mass1=1;
double mass2=pow(100, 3);

double size1=10;
double size2;

double speed1=0;
double speed2=-1;


double posY=400;
double wallPos = 30;

long count;
boolean finished;


int speed = 1;
double dt = 0.0001;

void setup() {
  size(400, 450);
  rectMode(CENTER);

  size1=10+Math.cbrt(mass1);
  size2=10+(Math.cbrt(mass2));


  posX1=200;
  posX2=300;
}

void draw() {
  background(51);

  for (int s=0; s < speed; s++) {
    for (int i=0; i < 1.0/dt; i++) {
      //Collide Walls
      if (posX2-size2/2<wallPos) {
        posX2=wallPos+size2/2;
        speed2*=-1;
      }
      if (posX1-size1/2<wallPos) {
        count++;
        posX1=wallPos+size1/2;
        speed1*=-1;
      }

      //Collide
      if (Math.abs(posX1-posX2)<Math.abs(size1/2+size2/2) && !finished) {
        count++;
        posX1 = posX2-(size1/2+size2/2);
        double speed1New, speed2New;
        double constant = 2*(mass1*speed1+mass2*speed2)/(mass1+mass2);

        speed1New = constant-speed1;
        speed2New = constant-speed2;

        speed1=speed1New;
        speed2=speed2New;
      }

      posX1+=speed1*dt;
      posX2+=speed2*dt;

      if (posX2 >width-size2/2 && !finished) {
        posX2=width-size2/2;
      }


      if (speed1<speed2 && speed1>0 &&speed2>0) {
        finished=true;
      }
    }
  }




  fill(255);
  text("Count: "+count, width-100, 20);

  fill(100);
  if (finished) {
    fill(155);
  }
  rect((float)posX1, (float)posY-(float)size1/2, (float)size1, (float)size1);
  rect((float)posX2, (float)posY-(float)size2/2, (float)size2, (float)size2);

  fill(255);
  line((float)wallPos, 0, (float)wallPos, height);
  line(0, (float)posY, width, (float)posY);
}
