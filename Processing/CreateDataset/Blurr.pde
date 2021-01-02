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
  float[][] pic= new float[grid][grid];
  for (int i=0; i < grid; i++) {
    for (int j=0; j < grid; j++) {
      pic[i][j]=in[i+j*grid];
    }
  }
  float[] result = new float[pic.length*pic.length];
  for (int i=0; i < pic.length; i++) {
    for (int j=0; j < pic[i].length; j++) {
      for (int k=-1; k <=1; k++) {
        for (int l=-1; l <=1; l++) {
          if (!(i-k<0 || j-l<0)) {
            if (!(i+k<0 || j+l<0)) {
              if (!(i+k>grid-1 || j+l>grid-1)) {
                if (!(i-k>grid-1 || j-l>grid-1)) {
                  result[i+j*grid]+=pic[i-k][j-l]*filter[k+1][l+1];
                }
              }
            }
          }
        }
      }
    }
  }
  return result;
}
