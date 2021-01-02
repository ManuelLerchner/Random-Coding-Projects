class Neuron {
  ArrayList<Neuron> input = new ArrayList();
  float weights[];
  float error;
  float bias;
  float output;

  PVector absPos=new PVector();
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
    stroke(0);
    fill((1+sigm(output))/2);
    strokeWeight(1);
    ellipse(absPos.x, absPos.y, 10, 10);
    if (Layer==nnDim.length-1) {
      fill(1);
      text(output, absPos.x, absPos.y+20);
    }
  }

  void connect() {
    for (Neuron N : input) {
      stroke((1+sigm(weights[N.Index]))/2);
      line(absPos.x, absPos.y, N.absPos.x, N.absPos.y);
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
    float delta =(1.0 - output) * (1.0 + output) * error * LearningRate;
    bias+=output * delta;
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
  out.x=(Layer+1)*50;
  out.y=height/2+(2*index-nnDim[Layer]+1)*25;
  return out;
}

float sigm(float x) {
  return  2.0 / (1.0 + exp(-2.0 * x)) - 1.0;
}

float relu(float in) {
  return max(0.01, in);
}
