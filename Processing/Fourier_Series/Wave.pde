class wave {
  float input, px, py;
  float c;
  int n;

  wave(float input_, float px_, float py_, int n_) {
    input=input_;
    px=px_;
    py=py_;
    n=n_;
  }



  void show() {  

    if (n==1) {
      //Shift
      A=splice(A, input, 0);

      //Shorten if necessary
      if (A.length > width-400-1) {
        A=shorten(A);
      }

      //Wave
      noFill();
      stroke(250,20,20);
      beginShape();
      for (int i=0; i < A.length; i++) {
        vertex (i+px, A[i]+py);
      }
      endShape();
    }

/////////////////////////////////////////////////////////////////////////

    if (n==2) {
      //Shift
      B=splice(B, input, 0);

      //Shorten if necessary
      if (B.length > width-400-1) {
        B=shorten(B);
      }


      //Wave
      noFill();
      stroke(30,230,50);
      beginShape();
      for (int i=0; i < B.length; i++) {
        vertex (i+px, B[i]+py);
      }
      endShape();
    }
  }
}
