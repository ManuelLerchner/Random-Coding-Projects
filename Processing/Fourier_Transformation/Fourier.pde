///////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////
Complex[] dft(Complex[] x) {
  for (int i=0; i<samples; i++) {
    FourierOut[i].scale(0);
  }
  for (int k=0; k < samples; k++) {
    for (int n=0; n < samples; n++) {
      FourierOut[k]=addC(FourierOut[k], multC(x[n], rootsOfUnity[k][n]));
    }
    if (k>=(samples)/2) {
      FourierOut[k].scale(0);
      break;
    } else {
      FourierOut[k].scale(2.0/samples);
    }
  }
  return FourierOut;
}

///////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////
Complex[] fft(Complex[] x) {
  int n=x.length;
  if (n==1) {
    return x;
  } else {
    Complex[] gerade=new Complex[n/2];
    Complex[] ungerade=new Complex[n/2];

    for (int i=0; i < n/2; i++) {
      gerade[i]=x[2*i];
      ungerade[i]=x[2*i+1];
    }

    Complex[] g=fft( gerade);
    Complex[] u=fft( ungerade);
    Complex[] c=new Complex[n];
    for (int k=0; k < n/2; k++) {
      Complex secondSum=multC(u[k], expC(-k*TWO_PI/n));
      c[k]=addC(g[k], secondSum);
      c[k+n/2]=addC(g[k], secondSum.scale(-1));
    }
    return c;
  }
}

///////////////////////////////////////////////////////////////////////////
float Index2Freq(int i, float samples, int nFFT) {
  return i * samples / nFFT;
}

///////////////////////////////////////////////////////////////////////////
class Complex {
  float re, im;
  Complex(float re, float im) {
    this.re=re;
    this.im=im;
  }
  float mag() {
    return sqrt(re*re+im*im);
  }
  Complex scale(float a) {
    re*=a;
    im*=a;
    return new Complex(re, im);
  }
}

Complex expC(float val) {
  return new Complex(cos(val), sin(val));
}
Complex multC(Complex z, Complex o) {
  return new Complex(z.re*o.re-z.im*o.im, z.re*o.im+z.im*o.re);
}

Complex addC(Complex z, Complex o) {
  return new Complex(z.re+o.re, z.im+o.im);
}
