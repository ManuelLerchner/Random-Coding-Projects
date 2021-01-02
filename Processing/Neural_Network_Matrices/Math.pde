///////////////////////////////////////////////////////////////////
float[][] matmul(float[][] A, float[][] B) {
  float[][] out=new float[A.length][B[0].length]; 
  if (A[0].length!=B.length) {
    println("Dim Error: " +A[0].length+ "  "+B.length);
    return out;
  }
  for (int k=0; k < A.length; k++) {
    for (int i=0; i < B[0].length; i++) {
      for (int j=0; j < B.length; j++) {
        out[k][i]+=A[k][j]*B[j][i];
      }
    }
  }
  return out;
}

///////////////////////////////////////////////////////////////////
float[][] hadamard(float[][] A, float[][] B) {
  if (A.length!= B.length || A[0].length !=B[0].length) {
    println("Error");
    return null;
  }

  float[][] out=new float[A.length][A[0].length]; 
  for (int k=0; k < out.length; k++) {
    for (int i=0; i < out[0].length; i++) {
      out[k][i]=A[k][i]*B[k][i];
    }
  }
  return out;
}

///////////////////////////////////////////////////////////////////
float[][] transpose(float[][] A) {
  float[][] out=new float[A[0].length][A.length]; 
  for (int k=0; k < out.length; k++) {
    for (int i=0; i < out[0].length; i++) {
      out[k][i]=A[i][k];
    }
  }
  return out;
}

///////////////////////////////////////////////////////////////////
float[][] addVector(float[][] A, float[] b) {
  float[][] out=new float[A.length][A[0].length]; 
  for (int k=0; k < out.length; k++) {
    for (int i=0; i < out[0].length; i++) {
      out[k][i]=A[k][i]+b[k];
    }
  }
  return out;
}

///////////////////////////////////////////////////////////////////
float sum(float[] a) {
  float s=0;
  for (int i=0; i < a.length; i++) {
    s+=a[i];
  }
  return s;
}

///////////////////////////////////////////////////////////////////
float average(float[] a) {
  return sum(a)/a.length;
}

///////////////////////////////////////////////////////////////////
int argMax(float[] a) {
  float max=-1;
  int maxIndex=-1;
  for (int i=0; i < a.length; i++) {
    if (a[i]>max) {
      max=a[i];
      maxIndex=i;
    }
  }
  return maxIndex;
}


///////////////////////////////////////////////////////////////////
////////////////////Activation/////////////////////////////////////
///////////////////////////////////////////////////////////////////
float sigmoid(float s) {
  return 1/(1+exp(-s));
}

///////////////////////////////////////////////////////////////////
float sigmoidPrime(float a) {
  return sigmoid(a) * (1 - sigmoid(a));
}

///////////////////////////////////////////////////////////////////
float relu(float s) {
  return max(0, s);
}

///////////////////////////////////////////////////////////////////
float reluPrime(float a) {
  return a>0?1:0;
}

float leakyRelu(float s) {
  float k=5;
  return s>0?s:s/k;
}

///////////////////////////////////////////////////////////////////
float leakyReluPrime(float a) {
  float k=5;
  return a>0?1:1/k;
}



///////////////////////////////////////////////////////////////////
////////////////////Cost///////////////////////////////////////////
///////////////////////////////////////////////////////////////////

float quadratic(float a, float y) {
  return 0.5*sq(a-y);
}

float quadraticPrime(float a, float y) {
  return a-y;
}


float crossEntropy(float a, float y) {
  return -a*constrain(log(y), -100, 0);
}

float crossEntropyPrime(float a, float y) {
  return (a - y) / (EPSILON+a - sq(a));
}


///////////////////////////////////////////////////////////////////
float[][] applyFunction(float[][] A, String fun) {
  float[][] out = new float[A.length][A[0].length];
  for (int i = 0; i < A.length; i++) {
    for (int j = 0; j < A[0].length; j++) {

      switch (fun) {
      case "sigmoid": 
        out[i][j] = sigmoid(A[i][j]);
        break;

      case "sigmoidPrime": 
        out[i][j] = sigmoidPrime(A[i][j]);
        break;

      case "relu": 
        out[i][j] = relu(A[i][j]);
        break;

      case "reluPrime": 
        out[i][j] = reluPrime(A[i][j]);
        break;

      case "leakyRelu": 
        out[i][j] = leakyRelu(A[i][j]);
        break;

      case "leakyReluPrime": 
        out[i][j] = leakyReluPrime(A[i][j]);
        break;

      default:
        println("Invalid Activation Function");
        return null;
      }
    }
  }

  return out;
}

float calcCost(Network N, float[][] y) {
  float[][] a=transpose(N.Layers[N.Layers.length-1].a);
  float[][] c=applyFunction(a, y, N.costFunction);
  float[] average=new float[a.length];


  for (int i=0; i < average.length; i++) {
    average[i]=average(c[i]);
  }

  return sum(average);
}


float[][] applyFunction(float[][] A, float[][] y, String fun) {
  float[][] out = new float[A.length][A[0].length];

  for (int i = 0; i < A.length; i++) {
    for (int j = 0; j < A[0].length; j++) {
      switch(fun) {
      case "quadratic":  
        out[i][j] = quadratic(A[i][j], y[i][j]);
        break;

      case "quadraticPrime":  
        out[i][j] = quadraticPrime(A[i][j], y[i][j]);
        break;

      case "crossEntropy":  
        out[i][j] = crossEntropy(A[i][j], y[i][j]);
        break;

      case "crossEntropyPrime":  
        out[i][j] = crossEntropyPrime(A[i][j], y[i][j]);
        break;

      default:
        println("Wrong Cost Function");
        return null;
      }
    }
  }
  return out;
}



float[] softMax(float[] a) {
  float sum=sum(a);
  float[] out=new float[a.length];
  for (int i=0; i < a.length; i++) {
    out[i]=exp(a[i])/sum;
  }
  return out;
}
