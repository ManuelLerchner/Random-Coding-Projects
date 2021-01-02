Card [] training_set; 
class Card {
  float [] inputs;
  float [] outputs;
  int output;
  
    Card() {
    inputs = new float [196]; 
    outputs = new float[10];
  }

  void imageLoad(byte [] images, int offset) { 
    for (int i = 0; i < 196; i++) {
      inputs[i] = int(images[i+offset]) / 128.0 - 1.0;
    }
  }

  void labelLoad(byte [] labels, int offset) { 
    output = int(labels[offset]);
    for (int i = 0; i < 10; i++) { 
      if (i == output) {
        outputs[i] = 1.0;
      } else {
        outputs[i] = -1.0;
      }
    }
  }
}

void loadData() {
  byte [] images = loadBytes("t10k-images-14x14.idx3-ubyte");
  byte [] labels = loadBytes("t10k-labels.idx1-ubyte");
  training_set = new Card [10000];
  for (int i = 0; i < 10000; i++) {
    training_set[i] = new Card();
    training_set[i].imageLoad(images, 16 + i * 196); 
    training_set[i].labelLoad(labels, 8 + i);  
  }
}
