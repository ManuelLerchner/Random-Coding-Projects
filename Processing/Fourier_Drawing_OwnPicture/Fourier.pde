Complex[] dft(Complex[] x) {
  Complex[] FourierOut=new Complex[N];
  int progress=ceil(N/4.0);
  for (int k=0; k < N; k++) {
    if (k%progress==0) {
      println("Progress: "+ceil(100.0*k/N)+"%");
    }
    Complex temp=new Complex(0, 0);
    for (int n=0; n < N; n++) {
      temp=addC(temp, multC(x[n], expC(-TWO_PI*k*n/N)));
    }
    temp.scale(1.0/N);
    FourierOut[k]=new Complex(temp.re, temp.im, k);
  }
  println("Progress: "+100+"%"); 
  return FourierOut;
}


///////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////
class Complex {
  double re, im, phase, mag, freq;
  Complex(double re, double im) {
    this.re=re;
    this.im=im;
  }
  Complex(double re, double im, double freq) {
    this.re=re;
    this.im=im;
    this.freq=freq;
    this.phase=Math.atan2(im, re);
    this.mag=Math.sqrt(re*re+im*im);
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
}

///////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////
Complex expC(double val) {
  return new Complex(Math.cos(val), Math.sin(val));
}
Complex multC(Complex z, Complex o) {
  return new Complex(z.re*o.re-z.im*o.im, z.re*o.im+z.im*o.re);
}

Complex addC(Complex z, Complex o) {
  return new Complex(z.re+o.re, z.im+o.im);
}
