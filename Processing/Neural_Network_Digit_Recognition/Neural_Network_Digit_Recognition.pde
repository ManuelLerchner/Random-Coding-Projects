Network NN;
ChildApplet child;
Button TrainButton, TestButton;

int[] nnDim ={196, 49, 10};
float LearningRate = 0.01;

int trainCard;
int ConnectZone = 50;
float rad=10;
boolean AutoTestMode;

void settings() {
  size(400, 400);
}

void setup() {  
  colorMode(RGB, 1, 1, 1);
  rectMode(CENTER);
  textAlign(CENTER, CENTER);
  TrainButton = new Button(width*0.8, height*0.93, "Train\n  10.000");
  TestButton = new Button(width*0.93, height*0.93, "Test");
  loadData();
  NN=new Network(nnDim);
  child = new ChildApplet();
}

void draw() {
  background(0.4, 0.6, 0.3);
  AutoTest();
  NN.display();
  TrainButton.display();
  TestButton.display();
}

///////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////
void Train() {
  for (int i = 0; i < 10000; i++) {
    trainCard =floor(random(0, training_set.length));
    NN.train(training_set[trainCard].inputs, training_set[trainCard].outputs);
    child.update=true;
  }
}

///////////////////////////////////////////////////////////////////////
void AutoTest() {
  if (AutoTestMode) {
    trainCard =floor(random(0, training_set.length));
    NN.respond(training_set[trainCard].inputs);
    child.update=true;
    fill(1, 0, 0);
    text(nf(100.0*NN.correct/NN.total, 0, 3)+"%", width-55, height-60);
  }
}

///////////////////////////////////////////////////////////////////////
void keyPressed() {
  NN.reset();
}

///////////////////////////////////////////////////////////////////////
void mousePressed() {
  if (TrainButton.hover()) {
    child.DrawMode=false;
    Train();
  }
  if (TestButton.hover()) {
    child.DrawMode=false;
    if (mouseButton==RIGHT) {
      AutoTestMode=!AutoTestMode;
      NN.total=0;
      NN.correct=0;
    } else {
      trainCard =floor(random(0, training_set.length));
      NN.respond(training_set[trainCard].inputs);
      child.update=true;
    }
  }
}
