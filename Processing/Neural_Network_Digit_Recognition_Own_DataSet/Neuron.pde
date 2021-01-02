class Neuron {
  ArrayList<Neuron> input = new ArrayList();
  PVector absPos=new PVector();
  float weights[];
  float error;
  float output;
  float bias;
  int Layer;
  int Index;

  Neuron(ArrayList<Neuron> input_, int Layer_, int Index_) {
    for (Neuron N : input_) {
      input.add(N);
    }
    weights = new float [input_.size()];
    for (int i = 0; i < input_.size(); i++) {
      weights[i] = randomGaussian();
    }
    absPos=getPos(Layer_, Index_);
    Layer=Layer_;
    Index=Index_;
  }

  void show() {
    if (absPos.y<height && absPos.y>0) {
      if (Layer==nnDim.length-1) {
        if (Index==NN.bestIndex) {
          if (training_set[trainCard].output==Index&&!child.DrawMode) {
            stroke(0, 0.3, 0);
            line(width-20, height/2, absPos.x+50, absPos.y );
          }
          fill(1, 0, 0);
          stroke(1, 0, 0);
          line(absPos.x+50, absPos.y, absPos.x, absPos.y);
          ellipse(absPos.x+50, absPos.y, 1.5*rad, 1.5*rad);
          fill(1);
          text(Index, absPos.x+51, absPos.y-1);
        }
        fill(1);
        text(Index, absPos.x+25, absPos.y);
      }
      stroke(0);
      fill((1+sigm(output))/2);
      strokeWeight(1);
      ellipse(absPos.x, absPos.y, rad, rad);
    }
  }

  void connect() {
    if (absPos.y<height+ConnectZone && absPos.y>-ConnectZone) {
      for (Neuron N : input) {
        if (N.absPos.y<height+ConnectZone && N.absPos.y>-ConnectZone) {
          if (nnDim[N.Layer]>10) {
            if (N.output>sigm(N.Layer)) {
              stroke((1+sigm(weights[N.Index]))/2, 100*(N.output));
              line(absPos.x, absPos.y, N.absPos.x, N.absPos.y);
            }
          } else {
            stroke((1+sigm(weights[N.Index]))/2, 100*N.output);
            line(absPos.x, absPos.y, N.absPos.x, N.absPos.y);
          }
        }
      }
    }
  }  

  void respond() {
    float sum_input = 0.0;
    for (Neuron N : input) {
      sum_input += N.output*weights[N.Index];
    }
    sum_input+=bias;
    output = sigm(sum_input);
    error = 0;
  }

  void setError(float desired) {
    error = desired-output;
  }

  void train() {
    float delta =(1.0 - output) * (1 + output) * error * LearningRate;
    bias+=output*delta;
    for (Neuron N : input) {
      if (N.Layer!=0) {
        N.error += weights[N.Index] * error;
      }
      weights[N.Index] += N.output * delta;
    }
  }
}

///////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////
PVector getPos(int Layer, int index) {
  PVector out = new PVector();
  float d=rad/2+100/nnDim[Layer];
  out.x=(Layer+0.5)*width/(nnDim.length+2);
  out.y=height/2+(2*index-nnDim[Layer]+1)*d;
  return out;
}

float sigm(float x) {
  return  2.0 / (1.0 + exp(-2.0 * x)) - 1.0;
}
