ArrayList<Neuron> Neurons = new ArrayList();
class Network {
  PVector NNDim;
  float[] response = new float[nnDim[nnDim.length-1]];
  int correct;
  int total;

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
    int maxIndex=-1;
    for (int i : nnDim) {
      maxIndex=max(maxIndex, i);
    }
    NNDim = new PVector(50*(nnDim.length-0.3), 50*(maxIndex-0.7)+25*(maxIndex)%2);
  }


  void display() {
    fill(0.4, 0.5, 0.3, 180);
    rect(50+(nnDim.length-1)*25, height/2, NNDim.x, NNDim.y);
    for (Neuron N : Neurons) {
      N.connect();
    }
    for (Neuron N : Neurons) {
      N.show();
    }
  }

  void respond(float[] input) {
    for (Neuron N : Neurons) {
      if (N.Layer==0) {
        N.output=input[N.Index];
      } else {
        N.respond();
      }
      if (N.Layer==nnDim.length-1) {
        response[N.Index]=N.output;
      }
    }
  }

  void train(float [] input, float [] outputs) {
    respond(input);
    for (Neuron N : Neurons) {
      if (N.Layer==nnDim.length-1) {
        N.setError(outputs[N.Index]);
        N.train();
        if (abs(N.output-outputs[N.Index])<0.2) {
          correct+=1;
        }
        total+=1;
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
