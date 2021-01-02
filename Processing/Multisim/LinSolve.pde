//https://www.sanfoundry.com/java-program-solve-linear-equation/
class LinSolve {

  //////////////////////////////////////////////////////////////////////////////////
  Complex[] solve(Complex[][] mat, Complex[] constants) {
    int n =constants.length;
    Complex result[] = new Complex[n];
    for (int k=0; k < n; k++) {
      result[k]=new Complex();
    }
    Complex[][] inverted_mat=invert(mat);
    for (int i = 0; i < n; i++) {
      for (int k = 0; k < n; k++) {   
        result[i] = add(result[i], mult(inverted_mat[i][k], constants[k]));
      }
    }
    return result;
  }


  //////////////////////////////////////////////////////////////////////////////////
  Complex[][] invert(Complex a[][]) {
    int n = a.length;
    Complex x[][] = new Complex[n][n];
    Complex b[][] = new Complex[n][n];
    for (int i=0; i < n; i++) {
      for (int k=0; k < n; k++) {
        x[i][k]=new Complex();
        b[i][k]=new Complex();
      }
    }
    int index[] = new int[n];
    gaussian(a, index);
    for (int i=0; i<n; ++i) {
      b[i][i] = new Complex(1, 0);
    }

    for (int i=0; i<n-1; ++i) {
      for (int j=i+1; j<n; ++j) {
        for (int k=0; k<n; ++k) {
          b[index[j]][k]  =sub( b[index[j]][k], mult(a[index[j]][i], b[index[i]][k]));
        }
      }
    }
    for (int i=0; i<n; ++i) {
      x[n-1][i] = div(b[index[n-1]][i], a[index[n-1]][n-1]);
      for (int j=n-2; j>=0; --j) {
        x[j][i] = b[index[j]][i];
        for (int k=j+1; k<n; ++k) {
          x[j][i] = sub(x[j][i], mult( a[index[j]][k], x[k][i]));
        }
        x[j][i] = div(x[j][i], a[index[j]][j]);
      }
    }
    return x;
  }

  //////////////////////////////////////////////////////////////////////////////////
  void gaussian(Complex a[][], int index[]) {
    int n = index.length;
    double c[] = new double[n];
    for (int i=0; i<n; ++i) 
      index[i] = i;
    for (int i=0; i<n; ++i) {
      double c1 = 0;
      for (int j=0; j<n; ++j) {
        double c0 = Math.abs(a[i][j].mag());
        if (c0 > c1) c1 = c0;
      }
      c[i] = c1;
    }
    int k = 0;
    for (int j=0; j<n-1; ++j) {
      double pi1 = 0;
      for (int i=j; i<n; ++i) {
        double pi0 = Math.abs(a[index[i]][j].mag());
        pi0 /= c[index[i]];
        if (pi0 > pi1) {
          pi1 = pi0;
          k = i;
        }
      }
      int itmp = index[j];
      index[j] = index[k];
      index[k] = itmp;
      for (int i=j+1; i<n; ++i) {
        Complex pj = div(a[index[i]][j], a[index[j]][j]);
        a[index[i]][j] = pj;
        for (int l=j+1; l<n; ++l)
          a[index[i]][l] = sub( a[index[i]][l], mult( pj, a[index[j]][l]));
      }
    }
  }


  //////////////////////////////////////////////////////////////////////////////////
  void printMatrix(String[][] M) {
    for (int row = 0; row < M.length; row++) {
      print("("); 
      for (int column = 0; column < M[row].length; column++) {
        if (column != 0) {
          print(",");
        }
        for (int i=0; i <  15-M[row][column].length(); i+=1) {
          print(" ");
        }
        print(M[row][column]); 
        for (int i=0; i <  5; i+=1) {
          print(" ");
        }
      }
      println(")");
    }
    println(" ");
  }

  void printMatrix(Complex[][] M) {
    for (int row = 0; row < M.length; row++) {
      print("("); 
      for (int column = 0; column < M[row].length; column++) {
        if (column != 0) {
          print(",");
        }
        for (int i=0; i <  15-M[row][column].toString().length(); i+=1) {
          print(" ");
        }
        print(M[row][column].toString()); 
        for (int i=0; i <  5; i+=1) {
          print(" ");
        }
      }
      println(")");
    }
    println(" ");
  }


  //////////////////////////////////////////////////////////////////////////////////
  void printVector(String[] V) {
    for (int row = 0; row < V.length; row++) {
      print("("); 
      for (int i=0; i <  10-V[row].length(); i+=1) {
        print(" ");
      }
      print(V[row]); 
      for (int i=0; i <  2; i+=1) {
        print(" ");
      }
      println(")");
    }
    println(" ");
  }

  void printVector(Complex[] V) {
    for (int row = 0; row < V.length; row++) {
      print("("); 
      for (int i=0; i <  10-V[row].toString().length(); i+=1) {
        print(" ");
      }
      print(V[row].toString()); 
      for (int i=0; i <  2; i+=1) {
        print(" ");
      }
      println(")");
    }
    println(" ");
  }
}

//////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////
class Complex {
  double re, im;
  Complex(double re, double im) {
    this.re=re;
    this.im=im;
  }
  Complex() {
    re=0;
    im=0;
  }
  double mag() {
    return Math.sqrt(re*re+im*im);
  }
  Complex scale(double a) {
    re*=a;
    im*=a;
    return new Complex(re, im);
  }
  void print() {
    println(re, im);
  }
  Complex clone() {
    return new Complex(re, im);
  }
  String toString() {
    String mag =nf((float)this.mag(), 0, 3);
    String heading = nf(degrees(atan2((float)im, (float)re)), 0, 1);
    String s= mag+"∠"+heading+"°";
    return  s;
  }
}

//////////////////////////////////////////////////////////////////////////////////
Complex mult(Complex z, Complex o) {
  return new Complex(z.re*o.re-z.im*o.im, z.re*o.im+z.im*o.re);
}

//////////////////////////////////////////////////////////////////////////////////
Complex div(Complex z, Complex o) {
  Complex out=new Complex();
  out.re=((z.re*o.re)+(z.im*o.im))/(o.re*o.re+o.im*o.im);
  out.im=((z.im*o.re)-(z.re*o.im))/(o.re*o.re+o.im*o.im);
  return out;
}

//////////////////////////////////////////////////////////////////////////////////
Complex scale(Complex z, double a) {
  return new Complex(z.re*a, z.im*a);
}

//////////////////////////////////////////////////////////////////////////////////
Complex add(Complex z, Complex o) {
  return new Complex(z.re+o.re, z.im+o.im);
}
//////////////////////////////////////////////////////////////////////////////////
Complex exp(Complex z) {
  double re =Math.exp(z.re)* Math.cos(z.im);
  double im=Math.exp(z.re)*Math.sin(z.im);

  return new Complex(re, im);
}

//////////////////////////////////////////////////////////////////////////////////
Complex sub(Complex z, Complex o) {
  return new Complex(z.re-o.re, z.im-o.im);
}

//////////////////////////////////////////////////////////////////////////////////
Complex Reciprocal(Complex Z) {
  Complex out=new Complex();
  out.re = Z.re/(Z.re*Z.re+Z.im*Z.im);
  out.im = -Z.im/(Z.re*Z.re+Z.im*Z.im);
  return out;
}
