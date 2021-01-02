import controlP5.*;
import processing.serial.*;

Serial myPort;

String send;
String Channel = "COM4";  


void setup() {
  size(400, 400);
  background(51);
   myPort = new Serial(this, Channel, 9600);
}

void draw() {
  background(51);
}


void keyPressed() {

  if (key == 'w') {
    send = normalizeData(1);
    myPort.write(send);
  }
    if (key == 'a') {
    send = normalizeData(2);
    myPort.write(send);
  }
    if (key == 's') {
    send = normalizeData(3);
    myPort.write(send);
  }
    if (key == 'd') {
    send = normalizeData(4);
    myPort.write(send);
  }
}


String normalizeData(int val) {

  String B1string = nf(val, 1);

  String ret = ("S") + B1string + ("E\n");
  return ret;
 
}
