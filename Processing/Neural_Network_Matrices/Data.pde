class Card {
  float[][] values;
  float[] oneHotVector;
  int label;

  Card(byte[] imData, int imOffset, byte[] laData, int laOffset) {
    values=new float[28][28];
    oneHotVector=new float[10];
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
void loadMNIST() {

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

float[][][] randomXOR(int batchSize) {

  float[][] inp=new float[batchSize][];
  float[][] out=new float[batchSize][];

  for (int i=0; i < batchSize; i++) {

    boolean a=boolean(round(random(1)));
    boolean b=boolean(round(random(1)));
    boolean c=a^b;

    inp[i]=new float[]{int(a), int(b)};
    out[i]=new float[]{int(c)
    };
  }

  return new float[][][]{inp, out};
}


float[] flatten(float[][] A) {
  float[] out=new float[A.length*A[0].length];
 
  for (int i=0; i < A.length; i++) {
    for (int j=0; j < A[0].length; j++) {
      out[i*A[0].length+j]=A[j][i];
    }
  }
  return out;
}


float[][][] randomTrainMNIST(int batchSize) {

  float[][] inp=new float[batchSize][];
  float[][] out=new float[batchSize][];

  for (int i=0; i < batchSize; i++) {
    int r=floor(random(60000));

    inp[i]=flatten(training_set[r].values);
    out[i]=training_set[r].oneHotVector;
  };


  return new float[][][]{inp, out};
}

float[][][] randomTestMNIST(int batchSize) {

  float[][] inp=new float[batchSize][];
  float[][] out=new float[batchSize][];

  for (int i=0; i < batchSize; i++) {
    int r=floor(random(10000));

    inp[i]=flatten(testing_set[r].values);
    out[i]=testing_set[r].oneHotVector;
  };


  return new float[][][]{inp, out};
}
