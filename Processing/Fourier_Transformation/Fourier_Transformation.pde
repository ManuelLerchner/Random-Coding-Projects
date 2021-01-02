import processing.sound.*;
Waveform waveform;
AudioIn in;

int samples=int(pow(2, 10));//powers of 2 if you use fft instead of dft
float MicSamplingRate=44100; //so the Frequency ranges from 0 to MicSamplingRate/2 due to Nyquist-Limit
float smoothingFactor =0.1;
float amplitude=800.0;

float TextAmplitude=5;
float len;
float[] val=new float[samples];
color[] col=new color[samples];

Complex[] Signal=new Complex[samples];
Complex[] fourier=new Complex[samples];
Complex[] FourierOut =new Complex[samples];
Complex[][] rootsOfUnity = new Complex[samples][samples];

void setup() {
  size(800, 600, P2D);
  textAlign(CENTER);
  textSize(10);

  in = new AudioIn(this, 0);
  waveform = new Waveform(this, samples);
  waveform.input(in);


  //Precalc
  len= 2*width/float(samples);
  for (int i=0; i < samples; i++) {
    col[i] = color(255*noise(i*6.51), 255*noise(1013.132+i*1.5), 255*noise(7424.14+i*1.14));
    FourierOut[i]=new Complex(0, 0);
    for (int j=0; j < samples; j++) {
      rootsOfUnity[i][j]=expC(-TWO_PI*i*j/samples);
    }
  }
}

void draw() {
  background(51);
  waveform.analyze();

  for (int i=0; i < samples; i++) {
    Signal[i]=new Complex(amplitude*waveform.data[i], 0);
  }
  fourier=fft(Signal);
  for (Complex c : fourier) { //scale down FFT
    c.scale(1.0/samples);
  }

  //Soundwave
  noFill();
  stroke(0);
  beginShape();
  for (int i = 0; i < samples; i+=2) {
    vertex(map(i, 0, samples, 0, width), map(waveform.data[i], -1, 1, 200, height-200) );
  }
  endShape();

  //Spektrum
  noStroke();
  for (int i=0; i < samples; i++) {
    val[i] += (fourier[i].mag() - val[i]) * smoothingFactor;
    fill(col[i]);
    rect(i*len, height-5, len, -10*val[i]); 
    if (val[i]>TextAmplitude) {
      fill(255);
      text(nf(Index2Freq(i, MicSamplingRate, samples), 1, 1), (i+0.5)*len, height-15-10*val[i]);
    }
  }
}
