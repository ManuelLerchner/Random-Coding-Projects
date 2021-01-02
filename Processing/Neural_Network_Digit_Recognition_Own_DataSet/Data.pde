Card [] training_set; 
class Card {
  float [] inputs;
  float [] outputs;
  int output;
  
    Card() {
    inputs = new float [dim*dim]; 
    outputs = new float[10];
  }

  void imageLoad(String [] images, int offset) { 
    for (int i = 0; i < dim*dim; i++) {
      inputs[i] = int(images[i+offset]) / 128.0 - 1.0;
    }
  }

  void labelLoad(String [] labels, int offset) { 
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
  String [] images = loadStrings("numbers32.txt");
  String [] labels = loadStrings("labels32.txt");
  int totalImages = images.length/(dim*dim);
  println(totalImages+" Images loaded");
  training_set = new Card [totalImages];
  for (int i = 0; i < totalImages; i++) {
    training_set[i] = new Card();
    training_set[i].imageLoad(images,  i * dim*dim); 
    training_set[i].labelLoad(labels,  i);  
  }
}
