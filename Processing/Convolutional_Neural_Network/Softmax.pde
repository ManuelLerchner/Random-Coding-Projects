class Softmax {
  int lenInputs;
  int lenOutputs;

  double[][] weights;
  double[] bias;
  double[] values;

  Softmax(int lenInputs, int lenOutputs) {
    this.lenInputs=lenInputs;
    this.lenOutputs=lenOutputs;

    weights=new double[lenOutputs][lenInputs];
    for (int i=0; i < lenInputs; i++) {
      for (int j=0; j < lenOutputs; j++) {
        weights[j][i]=randomGaussian()/lenInputs;
      }
    }

    bias=new double[lenOutputs];
  }



  double[] forwards(double[][][] data) {
    double[] flat=flatten(data);
    double[] out=matmul(weights, flat);

    out=add(out, bias);
    out=exp(out);
    double sum=sum(out);
    out=mult(out, 1/sum);

    return out;
  }
}


double[] flatten(double[][][] in) {
  double[] out=new double[in.length*in[0].length*in[0][0].length];
  for (int i=0; i < in.length; i++) {
    for (int j=0; j < in[0].length; j++) {
      for (int k=0; k < in[0][0].length; k++) {
        int x=i+in.length*(j+in[0][0].length*k);
        out[x]=in[i][j][k];
      }
    }
  }
  return out;
}


double[] matmul(double[][] matrix, double[] vector) {
  int rows = matrix.length;
  int columns = matrix[0].length;

  double[] result = new double[rows];

  for (int row = 0; row < rows; row++) {
    double sum = 0;
    for (int column = 0; column < columns; column++) {
      sum += matrix[row][column]
        * vector[column];
    }
    result[row] = sum;
  }
  return result;
}

double[] add(double[] a, double[] b) {
  double[] result = new double[a.length];
  for (int i=0; i < a.length; i++) {
    result[i]=a[i]+b[i];
  }
  return result;
}


double[] exp(double[] a) {
  double[] result = new double[a.length];
  for (int i=0; i < a.length; i++) {
    result[i]=Math.exp(a[i]);
  }
  return result;
}

double sum(double[] a) {
  double sum=0;
  for (int i=0; i < a.length; i++) {
    sum+=a[i];
  }
  return sum;
}

double[] mult(double[] a, double b) {
  double[] result = new double[a.length];
  for (int i=0; i < a.length; i++) {
    result[i]=a[i]*b;
  }
  return result;
}
