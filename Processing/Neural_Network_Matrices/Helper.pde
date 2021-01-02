////////////////////////////////////////////////////////////////////
float[][] createOutputMatrix(int n) {
  float[][] output=new float[n][n];
  for (int i=0; i < n; i++) {
    for (int j=0; j < n; j++) {
      float x=(float)i/n;
      float y=(float)j/n;
      float[][] pos={
        {x, y}
      };
      output[j][i]=NN.forward(pos)[0][0];
    }
  }
  return output;
}

////////////////////////////////////////////////////////////////////
float[][] randomMat(int len, int hei) {
  float[][] out=new float[hei][len];
  float scale=2;
  for (int i=0; i < len; i++) {
    for (int j=0; j < hei; j++) {
      out[j][i]=random(-scale, scale);
    }
  }
  return out;
}

////////////////////////////////////////////////////////////////////
float[] randomVec(int len) {
  float[] out=new float[len]; 
  for (int i=0; i < len; i++) {
    out[i]=0;
  }
  return out;
}


////////////////////////////////////////////////////////////////////
void showMatrix(float[][]A ) {
  float len=(float)width/A.length;
  noStroke();
  for (int i=0; i < A.length; i++) {
    for (int j=0; j < A[0].length; j++) {

      fill(A[j][i]*255);
      rect(j*len, i*len, len, len);
    }
  }
}

////////////////////////////////////////////////////////////////////
void showMatrix(float[]A, int len ) {
  float pixLen=(float)width*len/A.length;
  noStroke();
  for (int i=0; i < len; i++) {
    for (int j=0; j < len; j++) {

      fill(A[i*len+j]*255);
      rect(j*pixLen, i*pixLen, pixLen, pixLen);
    }
  }
}


///////////////////////////////////////////////////////////////////
String printMatrix(float[][] C) {
  String out="";
  for (int i=0; i < C.length; i++) {
    String row=i+". [";
    for (int j=0; j < C[0].length; j++) {
      String curr=nf(C[i][j], 1, 4);
      for (int l=0; l < 10-curr.length(); l++) {
        row+=" ";
      }
      row+= curr+(j==C[0].length-1 ?"]" :" ");
    }
    out+=row+"\n";
  }
  print(out+"\n");
  return out;
}
