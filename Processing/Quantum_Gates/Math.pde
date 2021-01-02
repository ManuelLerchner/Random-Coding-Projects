///////////////////////////////////////////////////////////////////////////////////
Complex[][] KroneckerProduct(Complex A[][], Complex B[][]) { 
  Complex[][] out = new Complex[A.length*B.length][A[0].length*B[0].length];

  // Go through all the elements of a.
  for (int ia = 0; ia < A.length; ia++) {
    for (int ja = 0; ja < A[ia].length; ja++) {
      // For each element of a, multiply it by all the elements of b.
      for (int ib = 0; ib < B.length; ib++) {
        for (int jb = 0; jb < B[ib].length; jb++) {
          out[B.length*ia+ib][B[ib].length*ja+jb] = mult(A[ia][ja], B[ib][jb]);
        }
      }
    }
  }
  return out;
}


///////////////////////////////////////////////////////////////////////////////////
Complex[] matmul(Complex[][] G, Complex[] v) {

  if (G[0].length!=v.length) {
    println("ERROR_matmul: Dimensions dont match");
    exit();
  }

  Complex[] out=new Complex[G.length];
  for (int i=0; i < G.length; i++) {
    out[i]=new Complex(0, 0);
  }

  for (int i=0; i < G.length; i++) {
    for (int j=0; j < G.length; j++) {
      out[i]=add(out[i], mult(G[i][j], v[j]));
    }
  }

  return out;
}
