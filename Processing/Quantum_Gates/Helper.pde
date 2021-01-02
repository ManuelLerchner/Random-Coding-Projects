///////////////////////////////////////////////////////////////////////////////////
Complex[] string2Qubit(String s) {
  Complex[][] out=new Complex[2][1];
  Complex[][] Q_ZERO={
    {new Complex(1, 0)}, 
    {new Complex(0, 0)}
  };
  Complex[][] Q_ONE={
    {new Complex(0, 0)}, 
    {new Complex(1, 0)}
  };

  for (int i=0; i < s.length(); i++) {
    Complex[][] q;
    if (s.charAt(i)=='0') {
      q=Q_ZERO;
    } else {
      q=Q_ONE;
    }

    if (i==0) {
      out=q;
    } else {
      out=KroneckerProduct(out, q);
    }
  }
  return column(out, 0);
}

Complex[] column(Complex[][] A, int n) {
  Complex[] out = new Complex[A.length];
  for (int i=0; i < A.length; i++) {
    out[i]=A[i][n];
  }
  return out;
}


///////////////////////////////////////////////////////////////////////////////////
String qubit2Dirac(Qubit q) {
  ArrayList<Complex> Factors=new ArrayList();
  IntList States=new IntList();

  for (int i=0; i < q.stateVector.length; i++) {
    if (!equalsZero(q.stateVector[i])) {
      Factors.add(q.stateVector[i]);
      States.append(i);
    }
  }

  String State="";
  for (int i=0; i < States.size(); i++) {
    String DiracNotation=dec2bin(States.get(i), round(log(q.stateVector.length)/log(2)));
    State+="[  ("+Factors.get(i).toString()+") * |" + new StringBuilder(DiracNotation).reverse().toString()+">  |  "+nf((float)(100*Math.pow(Factors.get(i).mag(), 2)), 2, 3) +"%  ]";

    if (i!=States.size()-1) {
      State+=" + ";
    }

    if (States.size()>5) {
      State+="\n";
    }
  }

  return State;
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


///////////////////////////////////////////////////////////////////////////////////
boolean equalsZero(Complex a) {
  Complex Zero=new Complex(0, 0);
  if (a.re==Zero.re && a.im==Zero.im) {
    return true;
  }
  return false;
}


///////////////////////////////////////////////////////////////////////////////////
String dec2bin(int n, int places) { 
  String bin="";
  while (n > 0) { 
    bin+= n % 2; 
    n = n / 2;
  } 

  while (bin.length()<places) {
    bin+="0";
  }

  return new StringBuilder(bin).reverse().toString();
} 


///////////////////////////////////////////////////////////////////////////////////
void printMat(Complex[][] L) {
  for (Complex[] C : L) {
    for (Complex c : C) {
      if (c.im!=0) {
        print(nf((float)c.re, 1, 4)+" j" +nf((float)c.im, 1, 4)+"  ");
      } else {
        print(nf((float)c.re, 1, 4) +"  ");
      }
    }
    println("");
  }
}

///////////////////////////////////////////////////////////////////////////////////
void calcCircuit(Qubit Q, Layer[] Lay) {
  int count=0;
  for (Layer L : Lay) {
    Q.stateVector=matmul(L.mat, Q.stateVector);
    println(nf((millis()-tstart)/1000.0, 0, 2) +"s |  Layer " +count +" calculated.  " +nf(100.0*(++count)/Lay.length, 0, 2)+"%");
  }
}

///////////////////////////////////////////////////////////////////////////////////
Complex[][] findGate(String s) {
  boolean found=false;
  Complex[][] Gate={};
  if (s=="IDENTITY") {
    found=true;
    Gate=HADAMARD;
  }
  if (s=="NOT") {
    found=true;
    Gate=NOT;
  }
  if (s=="PAULIY") {
    found=true;
    Gate=PAULIY;
  }
  if (s=="PAULIZ") {
    found=true;
    Gate=PAULIZ;
  }
  if (s=="HADAMARD") {
    found=true;
    Gate=HADAMARD;
  }
  if (s=="S") {
    found=true;
    Gate=S;
  }
  if (s=="CNOT") {
    found=true;
    Gate=CNOT;
  }
  if (s=="CHADAMARD") {
    found=true;
    Gate=CHADAMARD;
  }
  if (s=="CNOTSWAPPED") {
    found=true;
    Gate=CNOTSWAPPED;
  }
  if (s=="SWAP") {
    found=true;
    Gate=SWAP;
  }
  if (!found) {
    println("ERROR_No such Gate found");
    println(s);
    exit();
  }
  return Gate;
}

///////////////////////////////////////////////////////////////////////////////////
void showGate(String s, float sX, float sY) {
  boolean found=false;
  float size=min(sX, sY)/1.05;

  if (s=="IDENTITY") {
    found=true;
    fill(255);
    rect(0, 0, size, size);
    fill(0);
    text("I", 0, 0);
  }
  if (s=="NOT") {
    found=true;
    fill(255);
    rect(0, 0, size, size);
    fill(0);
    text("X", 0, 0);
  }
  if (s=="PAULIY") {
    found=true;
    fill(255);
    rect(0, 0, size, size);
    fill(0);
    text("Y", 0, 0);
  }
  if (s=="PAULIZ") {
    found=true;
    fill(255);
    rect(0, 0, size, size);
    fill(0);
    text("Z", 0, 0);
  }
  if (s=="HADAMARD") {
    found=true;
    fill(255);
    rect(0, 0, size, size);
    fill(0);
    text("H", 0, 0);
  }
  if (s=="S") {
    found=true;
    fill(255);
    rect(0, 0, size, size);
    fill(0);
    text("S", 0, 0);
  }
  if (s=="CNOT") {
    found=true;
    fill(255);
    ellipse(0, sY, size/2, size/2);
    fill(0);
    stroke(0);
    line(0, 0, 0, sY+size/4);
    line(-size/4, sY, size/4, sY);
    ellipse(0, 0, size/5, size/5);
  }
  if (s=="CHADAMARD") {
    found=true;
    fill(0);
    stroke(0);
    line(0, 0, 0, sY+size/4);
    ellipse(0, 0, size/5, size/5);
    fill(255);
    rect(0, sY, size, size);
    fill(0);
    text("H", 0, sY);
  }
  if (s=="CNOTSWAPPED") {
    found=true;
    fill(0);
    stroke(0);
    line(0, 0, 0, sY);
    ellipse(0, sY, size/5, size/5);
    fill(255);
    rect(0, 0, size, size);
    fill(0);
    text("X", 0, 0);
  }
  if (s=="SWAP") {
    found=true;
    fill(0);
    stroke(0);
    line(0, 0, 0, sY);

    line(-size/10, -size/10, size/10, size/10);
    line(-size/10, size/10, size/10, -size/10);

    line(-size/10, -size/10+sY, size/10, size/10+sY);
    line(-size/10, size/10+sY, size/10, -size/10+sY);
  }
  if (!found) {
    println("ERROR_No such Gate found");
    exit();
  }
}
