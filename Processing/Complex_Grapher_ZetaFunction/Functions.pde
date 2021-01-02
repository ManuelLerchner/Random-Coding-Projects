PVector f1(float Re, float Im) {
  PVector in = new PVector(Re, Im);
  PVector out = new PVector();

  out = ComplexMult(ComplexPower(in, Re/Im), new PVector(Im, Re));
  return out;
}

PVector f2(float Re, float Im) {
  PVector in = new PVector(Re, Im);
  PVector out = new PVector();

  in.div(5);
  out = ComplexPower(in, 3);
  out=ComplexMult(out, ComplexPower(Reciprocal(in.x, in.y), 11));
  out.x-=1;
  return out;
}

PVector f3(float Re, float Im) {
  PVector in = new PVector(Re, Im);
  PVector out = new PVector();

  in.div(3);

  out=  ComplexPower(in, 2);
  out.x-=1;
  out=ComplexMult(out, ComplexPower(new PVector(in.x-2, in.y-1), 2));
  out=ComplexMult(out, Reciprocal(ComplexPower(in, 2).x+2, 2+ComplexPower(in, 2).y));

  return out;
}



///////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////

PVector Zeta(float Re, float Im) {
  PVector sum=new PVector();
  PVector val=new PVector();
  PVector Recip = new PVector();

  for (int k=1; k < PartialSumZetaFunction; k++) {
    val.set((ComplexExp(k, Re, Im)));
    val.mult(pow(-1, k-1));
    Recip = (Reciprocal(val.x, val.y));
    sum.add(Recip);
  }

  PVector div = ComplexExp(2, -Re+1, -Im);
  div.mult(-1);
  div.x+=1;
  sum.set(ComplexMult(sum, Reciprocal(div.x, div.y)));

  return sum;
}

PVector MandelBrot(float Re, float Im, int Iter) {
  PVector in = new PVector(Re, Im);
  PVector temp = new PVector(0, 0);
  for (int i=0; i < Iter; i++) {
    temp = ComplexPower(temp, 2).add(in);
  }
  return temp;
}
