ArrayList<Neuron> Neurons = new ArrayList();
class Network {
  float[] response = new float[nnDim[nnDim.length-1]];
  float[] currentInputs= new float[nnDim[0]];
  int bestIndex;
  int total;
  int correct;

  Network(int[] nnDim) {
    ArrayList<Neuron> prevLayer = new ArrayList();
    for (int i=0; i < nnDim.length; i++) {
      prevLayer.clear();
      for (Neuron P : Neurons) {
        if (P.Layer==i-1) {
          prevLayer.add(P);
        }
      }
      for (int j = 0; j < nnDim[i]; j++) {
        Neurons.add(new Neuron(prevLayer, i, j));
      }
    }
  }

  void display() {
    for (Neuron N : Neurons) {
      N.connect();
    }
    for (Neuron N : Neurons) {
      N.show();
    }
    if (!child.DrawMode) {
      //Connect if Correct
      fill(0, 0.5, 0);
      ellipse(width-20, height/2, 1.5*rad, 1.5*rad);
      fill(1);
      text(training_set[trainCard].output, width-19, height/2-1);
    }
  }

  void respond(float[] inputs) {
    currentInputs=inputs;
    for (Neuron N : Neurons) {
      if (N.Layer==0) {
        N.output=inputs[N.Index];
      } else {
        N.respond();
      }
      if (N.Layer==nnDim.length-1) {
        response[N.Index]=N.output;
      }
    }
    float out=-1;
    for (int i=0; i < nnDim[nnDim.length-1]; i++) {
      for (Neuron N : Neurons) {
        if (N.Layer==nnDim.length-1) {
          if (N.output>out) {
            out=N.output;
            bestIndex=N.Index;
          }
        }
      }
    }
    if (NN.bestIndex== training_set[trainCard].output) {
      correct+=1;
    }
    total+=1;
  }

  void train(float [] inputs, float [] outputs) {
    respond(inputs);
    for (Neuron N : Neurons) {
      if (N.Layer==nnDim.length-1) {
        N.setError(outputs[N.Index]);
        N.train();
      }
    }
    for (int i=nnDim.length-2; i >0; i--) {
      for (Neuron N : Neurons) {
        if (N.Layer==i) {
          N.train();
        }
      }
    }
  }

  void reset() {
    Neurons.clear();
    NN=new Network(nnDim);
  }
}
