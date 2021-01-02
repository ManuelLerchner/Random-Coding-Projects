class Card {
  double[][] values;
  double[] oneHotVector;
  int label;

  Card(byte[] imData, int imOffset, byte[] laData, int laOffset) {
    values=new double[28][28];
    oneHotVector=new double[10];
    imageLoad(imData, imOffset);
    labelLoad(laData, laOffset);
  }

  void imageLoad(byte[] images, int offset) {
    for (int i = 0; i < 28; i++) {
      for (int j = 0; j < 28; j++) {
        values[i][j] = (images[i+j*28 + offset]& 255)/255.0;
      }
    }
  }

  void labelLoad(byte[] labels, int offset) {
    label=labels[offset]& 255;
    oneHotVector[label]=1;
  }
}


Card[] training_set;
Card[] testing_set;
void loadData() {

  training_set = new Card[60000];
  testing_set = new Card[10000];


  byte[] testImages = loadBytes("t10k-images.idx3-ubyte");
  byte[] testLabels =loadBytes("t10k-labels.idx1-ubyte");




  byte[] trainImages = loadBytes("train-images.idx3-ubyte");
  byte[] trainLabels = loadBytes("train-labels.idx1-ubyte");




  //Load training set
  for (int i = 0; i < training_set.length; i++) {
    training_set[i] = new Card(trainImages, 16 + i * 28*28, trainLabels, 8 + i);
  }

  //Load testing set
  for (int i = 0; i < testing_set.length; i++) {
    testing_set[i] = new Card(testImages, 16 + i * 28*28, testLabels, 8 + i);
  }
}
