class Qubit {
  Complex[] stateVector;
  String name;

  Qubit(String s) {
    name=s;
    AmountQubits=s.length();
    this.stateVector=string2Qubit(s);
  }


  String toString() {
    String out="\n-----------\n";
    out+="Q_State:\n";
    out+=qubit2Dirac(this);
    out+="\n-----------";
    return out;
  }
}



///////////////////////////////////////////////////////////////////////////////////
class Complex {
  double re=0, im=0;
  Complex(double re, double im) {
    this.re=re;
    this.im=im;
  }

  String toString() {
    if (im!=0) {
      return nfp((float)re, 0, 4)+" "+nfp((float)im, 0, 4)+"j";
    } else {
      return nfp((float)re, 0, 4);
    }
  }
  double mag() {
    return Math.sqrt(re*re+im*im);
  }
}


///////////////////////////////////////////////////////////////////////////////////
Complex mult(Complex a, Complex b) {
  return new Complex(a.re*b.re-a.im*b.im, a.re*b.im+b.re*a.im);
}

Complex add(Complex a, Complex b) {
  return new Complex(a.re+b.re, a.im+b.im);
}
