float[][] BoxBlurr={
  {1/9.0, 1/9.0, 1/9.0}, 
  {1/9.0, 1/9.0, 1/9.0}, 
  {1/9.0, 1/9.0, 1/9.0}, 
};

float[][] Edge={
  {-1, -1, -1}, 
  {-1, 8, -1}, 
  {-1, -1, -1}, 
};

float[][] GaussianBlurr={
  {1/16f, 2/16f, 1/16f}, 
  {2/16f, 5/16f, 3/16f}, 
  {1/16f, 3/16f, 1/16f}, 
};


float[] blurr(float[] in, float[][] filter) {
  float[][] pic= new float[14][14];
  for (int i=0; i < 14; i++) {
    for (int j=0; j < 14; j++) {
      pic[i][j]=in[i+j*14];
    }
  }
  float[] result = new float[pic.length*pic.length];
  for (int i=0; i < pic.length; i++) {
    for (int j=0; j < pic[i].length; j++) {
      for (int k=0; k <=1; k++) {
        for (int l=0; l <=1; l++) {
          if (!(i-k<0 || j-l<0)) {
            result[i+j*14]+=pic[i-k][j-l]*filter[k+1][l+1];
          }
        }
      }
    }
  }
  return result;
}
