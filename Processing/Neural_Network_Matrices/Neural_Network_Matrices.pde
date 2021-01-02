Network NN;

int totalIterations=0;
int total;
int correct;

void setup() {
  size(400, 400);

  loadMNIST();


  ArrayList<LayerType> Layers=new ArrayList();

  Layers.add(new LayerType(28*28, "sigmoid"));
  Layers.add(new LayerType(64, "sigmoid"));    
  Layers.add(new LayerType(64, "sigmoid"));  
  Layers.add(new LayerType(64, "sigmoid"));  
  Layers.add(new LayerType(10, "sigmoid"));

  NN=new Network(Layers, "crossEntropy");


  int iterations=1000000;
  for (int i=1; i <= iterations; i++) {
    float[][][] data=randomTrainMNIST(1);
    float[][] inp=data[0];
    float[][] exp=data[1];
    totalIterations++;
    NN.train(inp, exp, totalIterations, totalIterations%ceil(iterations/10.0)==0);
  }
}


void draw() {
  background(51);


  float[][][] data=randomTestMNIST(1);
  float[] pred=transpose(NN.predict(data[0]))[0];


  int guess=argMax(pred);
  int trueAnswer=argMax(data[1][0]);

  if (trueAnswer==guess) {
    correct++;
  }
  total++;

  showMatrix(data[0][0], 28);

  println("\nGuess: "+guess+ "    Confidence: "+round(pred[guess]*10000.0)/100.0+"%"+ "         True Answer: "+trueAnswer);
  println("Accuracy: "+100.0*correct/total);
}
