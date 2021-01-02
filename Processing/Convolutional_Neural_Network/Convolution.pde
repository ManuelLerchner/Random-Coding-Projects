class Convolution {

  int filterSize;
  double[][][] values;
  double[][][] mat;

  Convolution(int filterSize) {
    this.filterSize=filterSize;


    mat=new double[filterSize][3][3];


    for (int layer=0; layer < filterSize; layer++) {
      for (int i=0; i < mat[layer].length; i++) {
        for (int j=0; j < mat[layer][i].length; j++) {
          mat[layer][j][i]=randomGaussian()/9.0;
        }
      }
    }
  }



  double[][][] forwards(double[][] data) {
    values=new double[filterSize][data.length-2][data.length-2];
    for (int layer=0; layer < filterSize; layer++) {
      values[layer]=applyKernel(data, mat[layer]);
    }
    return values;
  }
}


double[][] applyKernel(double[][] data, double[][] mat) {
  double[][] out=new double[data.length-1][ data.length-1];
  for (int cx=1; cx < data.length-1; cx++) {
    for (int cy=1; cy < data.length-1; cy++) {
      for (int k=0; k < mat.length; k++) {
        for (int l=0; l < mat.length; l++) {
          out[cx][cy]+=data[cx+k-1][cy+l-1]*mat[k][l];
        }
      }
    }
  }
  return out;
}
