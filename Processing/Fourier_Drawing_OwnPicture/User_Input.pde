void mousePressed() {
  mousePath.add(new PVector(mouseX-width/2, mouseY-height/2));
}

void mouseDragged() {
  if (frameCount%sampleEveryXFrames==0) {
    mousePath.add(new PVector(mouseX-width/2, mouseY-height/2));
  }
}

void mouseReleased() {
  N=mousePath.size();
  println("\n\n\nN: "+N);
  dx=TWO_PI/N;
  Complex[] temp=new Complex[N];
  for (int i=0; i < N; i++) {
    temp[i]=new Complex(mousePath.get(i).x, mousePath.get(i).y);
  }
  fourier=dft(temp);
  Sort(fourier);
  mousePath.clear();
  path.clear();
  time=0;
}
