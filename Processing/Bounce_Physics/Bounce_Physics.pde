//A Lerchner Ind Production
//All Cirlces have same weight
import processing.sound.*;
SoundFile KlickSound;
ArrayList<circle> circles;

///////////////////////////
//////Parameters///////////
///////////////////////////
int NumberCircles =80;
float MinSizeCircles = 30 ;
float VarSize = 30;

float InitialSpeed =1.5;
boolean Sound_ON =false;
float SoundAmplitude =0.6;
int SoundBetween = 500;
////////////////////////////
///////////////////////////

float randomsize;
PVector PosCircle = new PVector();
int MaxTries;
long GlobalTime;
long LastSoundTime;
float Verschiebung;
float t;

void setup() {
  size(800, 800);
  background(51);
  colorMode(HSB, 255, 255, 255);
  strokeCap(SQUARE);
  rectMode(CORNERS);

  KlickSound = new SoundFile(this, "Tick.mp3");
  circles = new ArrayList<circle>();

  //Create Circles
  for (int i=0; i < NumberCircles; i++) {
    newCircle();
    circles.add(new circle(PosCircle.x, PosCircle.y, abs(MinSizeCircles+randomsize), random(-InitialSpeed, InitialSpeed), random(-InitialSpeed, InitialSpeed)));
  }
}


void draw() {
  background(50);
  GlobalTime=millis();

  //Show circles
  for (circle c : circles) {
    c.show();
    c.update();
  }

  //Rectangle BreathTime
  if (t<=PI) {
    t+=0.01;
  } else {
    t=0;
  }

  //Hud
  //Background
  strokeWeight(0.75);
  stroke(0, 0, 0, 200);
  fill(0, 0, 255, 50);
  rect(constrain(width-80-MinSizeCircles-VarSize-3, 70, width), height-50-3, width, height);
  rect(constrain(width-150-MinSizeCircles-VarSize-3, 0, width), height-50-3, constrain(width-80-MinSizeCircles-VarSize-3, 70, width), height);

//Size Boxex
  stroke(0, 0, 0);
  strokeWeight(1.25);
  fill(100, 255, 255);
  rect(constrain(width-80-VarSize,100,width), height-25, constrain(width-80-abs(sin(t))*VarSize,100,width), height-15);
  fill(24, 255, 255);
  rect(constrain(width-80-MinSizeCircles-VarSize, 73, width), height-25, constrain(width-80-VarSize,100,width), height-15);

//Text
  textSize(13);
  fill(0, 0, 0);
  text("Size Circles:", constrain(width-80-MinSizeCircles-VarSize, 73, width), height-40);
  text("#Circles:", constrain(width-150-MinSizeCircles-VarSize, 3, width), height-40);
  textSize(20);
  fill(0, 0, 255);
  text(NumberCircles, constrain(width-140-MinSizeCircles-VarSize, 3, width), height-15);
}



void newCircle() {
  if (MaxTries<=1000) {
    MaxTries++;

    //Search Pos x/y/r
    randomsize = random(VarSize);
    PosCircle.x = random(MinSizeCircles+randomsize+2, width-MinSizeCircles-randomsize-2);
    PosCircle.y = random(MinSizeCircles+randomsize+2, height-MinSizeCircles-randomsize-2);


    for (circle c : circles) {
      float d = dist(PosCircle.x, PosCircle.y, c.x, c.y);

      if (d<(MinSizeCircles+randomsize)/2+c.r/2) {
        newCircle();
      }
    }
  } else {
    println("MaxTries >1000.");
    exit();
  }
}
