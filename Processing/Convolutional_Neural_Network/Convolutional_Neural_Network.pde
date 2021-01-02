Network NN=new Network();
void setup() {
  size(400, 400);

  loadData();
}

void draw() {
  background(51);


  int total=0;
  int correct=0;
  for (int i=0; i < 10000; i++) {

    int r=int(random(60000));
    Card T=training_set[r];

    double[] res=NN.forwards(T);

    correct+=res[1];
    total++;

    println("Loss: "+(float)res[0] +" correct: "+100.0*correct/total+"%");
  }



  noLoop();
}


void showMatrix(double[][] values) {

  float size=(float)width/values.length;
  for (int i=0; i < values.length; i++) {
    for (int j=0; j < values.length; j++) {
      fill(255.0*(float)values[i][j]);
      rect(i*size, j*size, size, size);
    }
  }
}
