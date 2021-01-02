class Network {
  Convolution C;
  Pool P;
  Softmax S;


  double[] result;
  Network() {

    C=new Convolution(8);
    P=new Pool(2);
    S=new Softmax(8*13*13, 10);
  }


  double[] forwards(Card T) {


    double[][][] out=C.forwards(T.values);
    out= P.forwards(out);
    result=S.forwards(out);



    double loss = -Math.log(result[T.label]);
    int corr=argmax(result) == T.label ? 1 :0;

    return new double[]{loss, corr};
  }


  int argmax(double[] a) {
    int bestIndex=-1;

    double maxVal=-1;
    for (int i=0; i < a.length; i++) {
      if (a[i]>maxVal) {
        maxVal=a[i];
        bestIndex=i;
      }
    }

    return bestIndex;
  }
}
