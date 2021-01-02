class Pool {

  int poolSize;
  double[][][] values;


  Pool(int poolSize) {
    this.poolSize=poolSize;
  }



  double[][][] forwards(double[][][] data) {
    values=new double[data.length][data[1].length/poolSize][data[1][1].length/poolSize];
    for (int layer=0; layer < data.length; layer++) {
      values[layer]=applyMaxPool(data[layer], poolSize);
    }
    return values;
  }
}


double[][] applyMaxPool(double[][] data, int poolSize) {
  double[][] out=new double[data.length/poolSize][data.length/poolSize];


  for (int i=0; i < out.length; i++) {
    for (int j=0; j < out.length; j++) {
      double max=-1;
      for (int k=0; k < poolSize; k++) {
        for (int l=0; l < poolSize; l++) {
          int x=i*poolSize+k;
          int y=j*poolSize+l;
          max=Math.max(max, data[x][y]);
        }
      }
      out[i][j]=max;
    }
  }


  return out;
}
