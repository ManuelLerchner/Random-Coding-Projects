class Network {
  LayerType[] LayerType;
  Layer[] Layers;

  String costFunction;
  float learningRate=0.1;

  Network(ArrayList<LayerType> LayerType, String costFunction) {
    this.LayerType=LayerType.toArray(new LayerType[0]);
    this.costFunction=costFunction;
    Layers=new Layer[LayerType.size()];
    for (int i=0; i < Layers.length; i++) {
      Layers[i]=new Layer(i, this);
    }
  }


  float[][] predict(float[][] input) {
    float[][] pred=forward(input);
    float[][] out=new float[pred.length][pred[0].length];
    for (int i=0; i < pred.length; i++) {
      out[i]=softMax(pred[i]);
    }

    return pred;
  }

  float[][] forward(float[][] input) {
    Layers[0].a=transpose(input);
    for (int i=1; i < Layers.length; i++) {
      Layers[i].forward();
    }
    return Layers[Layers.length-1].a;
  }

  void backwards(float[][] expect) {
    Layers[Layers.length-1].calcDelta(expect);
    for (int i=Layers.length-2; i >=1; i--) {
      Layers[i].calcDelta();
    }
  }

  void adjustParameters() {
    for (int l=1; l < LayerType.length; l++) {
      for (int j=0; j < LayerType[l].len; j++) {
        float delC_b=average(Layers[l].delta[j]);
        Layers[l].bias[j]-=learningRate*delC_b;

        for (int k=0; k < LayerType[l-1].len; k++) {

          float delC_w=average(Layers[l-1].a[k])*average(Layers[l].delta[j]);
          Layers[l].weights[j][k]-=learningRate*delC_w;
        }
      }
    }
  }

  void train(float[][] inp, float[][] out, int iter, boolean print) {
    forward(inp);
    backwards(out);
    adjustParameters();

    if (print) {
      println("\n\n\n-----------------------------------");
      println("Input");
      printMatrix(inp);
      println("Output");
      printMatrix(transpose(Layers[Layers.length-1].a));
      println("Cost: " +calcCost(this, out));
      println("\nTraining-Iteration: "+iter);
      println("-----------------------------------");
    }
  }
}


class LayerType {
  int len;
  String activationFunction;

  LayerType(int len, String type) {
    this.len=len;
    this.activationFunction=type;
  }
}
