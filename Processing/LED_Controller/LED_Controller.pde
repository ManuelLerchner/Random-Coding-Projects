//A Lerchner Industry Production in collab. with Jesacher Industries

import controlP5.*;
import processing.serial.*;

Serial myPort;
ControlP5 cp5;

int r, g, b, rf, gf, bf, randr, randg, randb, desiredR, desiredG, desiredB;
boolean randomActivated = false;
boolean instantActivated = false;
boolean updateActivated = false;
String send;

////////////////////////////////////////
////////////////////////////////////////
//////Your Arduino Channel//////////////
String Channel = "COM4";
/////////Enable Arduino/////////////////
boolean EnableSendToArduino = true;
////////////////////////////////////////
////////////////////////////////////////

void setup() {
  size(800, 800);
  //Initialize
  cp5 = new ControlP5(this);
  createSliders();

  if (EnableSendToArduino) {
    myPort = new Serial(this, Channel, 9600);
  }
}

void draw() {
  background (51);
  extractValues();
  showColorRectangles();
  displaytext();
  update();
  randomColors();
  instantColors();
}


////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

//UpdateButton
void Update() {
  if (!randomActivated && !instantActivated) {
    updateActivated = true;
  }
}

//RandomButton
void Random() {
  if (!instantActivated) {
    randomActivated = !randomActivated;
  }
}

//InstantButton
void Instant() {
  if (!randomActivated) {
    instantActivated = !instantActivated;
  }
}

////////////////////////////////////////////////////////////////////////////////////////////////////

//Sliders
void createSliders() {
  cp5.addSlider("R")
    .setRange(0, 255)
    .setPosition(100, 150)
    .setColorBackground(color(70))
    .setColorForeground(color(255, 0, 0))
    .setColorActive(color(255, 0, 0)) 
    .setLabelVisible(false)
    .setSize(50, 400);      
  cp5.addSlider("G")
    .setRange(0, 255)
    .setPosition(200, 150)
    .setColorBackground(color(70))
    .setColorForeground(color(0, 255, 0))
    .setColorActive(color(0, 255, 0))
    .setLabelVisible(false)
    .setSize(50, 400);      
  cp5.addSlider("B")
    .setRange(0, 255)
    .setPosition(300, 150)
    .setColorBackground(color(70))
    .setColorForeground(color(0, 0, 255))
    .setColorActive(color(0, 0, 255)) 
    .setLabelVisible(false)
    .setSize(50, 400);      
  cp5.addButton("Update")
    .setPosition(575, 320)
    .setSize(100, 50);
  cp5.addButton("Random")
    .setPosition(575, 450)
    .setSize(100, 50);
  cp5.addButton("Instant")
    .setPosition(575, 395)
    .setSize(100, 50);
}

////////////////////////////////////////////////////////////////////////////////////////////////////

//Get Values
void extractValues() {
  //Get SliderValues
  r = round(cp5.getController("R").getValue());
  g = round(cp5.getController("G").getValue());
  b = round(cp5.getController("B").getValue());
}

////////////////////////////////////////////////////////////////////////////////////////////////////

//Text
void displaytext() {
  //Text LED Control
  fill(255);
  textAlign(CENTER);
  textSize(40);
  text("LED CONTROL", width/2, 65);

  //Text RGB
  textAlign(CENTER);
  fill(0, 255, 0);
  textSize(40);
  fill(255, 0, 0);
  text("R", 125, 600);
  fill(0, 255, 0);
  text("G", 225, 600);
  fill(0, 0, 255);
  text("B", 325, 600);
  //Text ValuesAbove
  textAlign(CENTER);
  fill(255);
  textSize(20);
  text(r, 125, 130);
  text(g, 225, 130);
  text(b, 325, 130);

  //Text Preview
  textAlign(CENTER);
  textSize(16);
  fill(255-r, 255-g, 255-b);
  text("PREVIEW", 225, 705);
  //Text Current
  textAlign(CENTER);
  textSize(16);
  fill(255-rf, 255-gf, 255-bf);
  text("Current", 625, 705);

  // Text Send
  textSize(12);
  textAlign(LEFT);
  fill(255);

  text("Send to Arduino:\n" +Channel +": "  +send, width-160, height-30);

  if (EnableSendToArduino == false) {
    fill(255, 0, 0);
    textSize(14);
    textAlign(CENTER);
    text("Send to Arduino Disabled, Check ''EnableSendToArduino'' boolean ",width/2, height-20);
  }
}

////////////////////////////////////////////////////////////////////////////////////////////////////

void showColorRectangles() {
  //PreviewRectangle
  rectMode(CENTER);
  fill(r, g, b);
  rect(225, 700, 150, 75, 7);
  //CurrentRectangle
  rectMode(CENTER);
  fill(rf, gf, bf);
  rect(625, 700, 150, 75, 7);

  //ControlRectangle
  rectMode(CORNERS);
  stroke(0, 200);
  strokeWeight(2);
  fill(100, 100);
  rect(550, 290, 700, 550);
}

////////////////////////////////////////////////////////////////////////////////////////////////////

void instantColors() {
  if (instantActivated && !randomActivated) {
    cp5.getController("Instant").setColorBackground(color(255, 0, 0));

    rf=r;
    gf=g;
    bf=b;

    //Prepare and Send Values
    if (EnableSendToArduino) {
      send = normalizeData(rf, gf, bf);
      myPort.write(send);
    }
    delay(20);
  } else {
    cp5.getController("Instant").setColorBackground(color(0, 45, 90));
  }
}

////////////////////////////////////////////////////////////////////////////////////////////////////

void update() {
  if (updateActivated) {
    rf=r;
    gf=g;
    bf=b;
    //Prepare and Send Values
    if (EnableSendToArduino) {
      send = normalizeData(rf, gf, bf);
      myPort.write(send);
    }

    updateActivated = false;
  }
}

////////////////////////////////////////////////////////////////////////////////////////////////////

void randomColors() {
  if (randomActivated && !instantActivated) {
    cp5.getController("Random").setColorBackground(color(255, 0, 0));

    if (frameCount % round(frameRate)*0.5 == 0) {
      desiredR=round(random(0, 255));
      desiredG=round(random(0, 255));
      desiredB=round(random(0, 255));
    }

    randr= round(lerp(r, desiredR, 0.05));
    randg= round(lerp(g, desiredG, 0.05));
    randb= round(lerp(b, desiredB, 0.05));

    cp5.getController("R").setValue(randr);
    cp5.getController("G").setValue(randg);
    cp5.getController("B").setValue(randb);


    rf=r;
    gf=g;
    bf=b;

    //Prepare and Send Values
    if (EnableSendToArduino) {
      send = normalizeData(randr, randg, randb);
      myPort.write(send);
    }
    delay(20);
  } else {

    cp5.getController("Random").setColorBackground(color(0, 45, 90));
  }
}

////////////////////////////////////////////////////////////////////////////////////////////////////

//Create uniform Syntax r g b
String normalizeData(int rval, int gval, int bval) {

  String B1string = nf(rval, 3);
  String B2string = nf(gval, 3);
  String B3string = nf(bval, 3);

  String ret = ("S") + B1string + B2string + B3string + ("E\n");
  return ret;
}
