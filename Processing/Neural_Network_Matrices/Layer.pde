class Layer {
  Network N;

  int index;
  float[][] weights, delta, a, z;
  float[] bias;


  Layer(int index, Network N) {
    this.N=N;
    this.index=index;
    this.bias=randomVec(N.LayerType[index].len);
    this.weights=index>0?randomMat(N.LayerType[index-1].len, N.LayerType[index].len):null;
  }


  void forward() {
    z = addVector(matmul(weights, N.Layers[index - 1].a), bias);
    a = applyFunction(z, N.LayerType[index].activationFunction);
  }

  void calcDelta(float[][] expect) {
    float[][] error=applyFunction(a, transpose(expect), N.costFunction+"Prime");
    float[][] deriv=applyFunction(z, N.LayerType[index].activationFunction+"Prime");
    delta=hadamard(error, deriv);
  }

  void calcDelta() {
    float[][] error=matmul(transpose(N.Layers[index+1].weights), N.Layers[index+1].delta);
    float[][] deriv=applyFunction(z, N.LayerType[index].activationFunction+"Prime");
    delta=hadamard(error, deriv);
  }
}
