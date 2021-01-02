Network NN;
Data D;
int[] nnDim ={2, 4,4, 1};

boolean manualInput=true;
float LearningRate = 0.01;

void setup() {
  size(400, 400);
  colorMode(RGB, 1, 1, 1);
  rectMode(CENTER);

  NN=new Network(nnDim);
  D=new Data();
}

void draw() {
  background(0.4, 0.6, 0.3);
  manualInput();
  showGrid();
  Train();
  NN.display();
}

///////////////////////////////////////////////////////////////////////
void manualInput() {
  if (manualInput) {
    if (mousePressed) {
      if (mouseButton == RIGHT) {
        float[] tryP ={mouseX/(float)width, mouseY/(float)height};
        NN.respond(tryP);
      }
    }
  }
}

///////////////////////////////////////////////////////////////////////
void Train() {
  if (!manualInput) {
    for (int i = 0; i < 100; i++) {
      D.LoadData();
      NN.train(D.inputs, D.outputs);
    }
  }
}

///////////////////////////////////////////////////////////////////////
void showGrid() {
  if (!manualInput) {
    noStroke();
    float s = width/100;
    for (float i=s/2; i < width+s/2; i+=s) {
      for (float j=s/2; j < height+s/2; j+=s) {
        float[] tryP ={i/(float)width, j/(float)height};
        NN.respond(tryP);
        fill((sigm(NN.response[0])+1)/2);
        rect(i, j, s, s);
      }
    }
    fill(1, 0, 0);
    text(100.0*NN.correct/NN.total+"%", width-80, height-20);
  }
}

///////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////

void keyPressed() {
  NN.reset();
}

void mousePressed() {
  if (mouseButton==LEFT) {
    manualInput=!manualInput;
  }
  if (mouseButton==RIGHT) {
    NN.total=0;
    NN.correct=0;
  }
}

void mouseWheel(MouseEvent event) {
  float e = event.getCount();
  LearningRate*=pow(2, e);
  println(LearningRate);
}
