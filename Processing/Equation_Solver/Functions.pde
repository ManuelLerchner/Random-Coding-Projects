PVector f(PVector z) {
  float x=z.x;
  float y=z.y;
  //return z;
  //return ComplexMult(z.copy().add(-1, 0), z.copy().add(1, 0));
  //return(Zeta(z.x, z.y));
  // return(f3(z.x*2.0, z.y*2.0));
  // return(MandelBrot(z.x/2.0, z.y/2.0,100));

  return(ComplexPower(z,5).copy().sub(z).sub(1,0));
  //return (new PVector(x-2,y));
  //sin(x*y)=cos(x*1.3);
  //return(new PVector(sin(z.x*z.y),cos(z.x*1.3)));

  //sin(x)+cos(y)=0
  //return(new PVector((sin(z.x)+cos(z.y)),0));

  //sin(x)+tan(y)=0
  //return(new PVector((sin(z.x)+tan(z.y)),0));

  //x*y=x+y
  //return(new PVector(x*y-(x+y), 0));


  //x*y=x+y
  //return(new PVector(sin(x+y)+cos(x*y)+1,0));
}

///////////////////////////////////////////////////////////////////////
PVector f1(float Re, float Im) {
  PVector in = new PVector(Re, Im);
  PVector out = new PVector();
  out = ComplexMult(ComplexPower(in, Re/Im), new PVector(Im, Re));
  return out;
}

///////////////////////////////////////////////////////////////////////
PVector f2(float Re, float Im) {
  PVector in = new PVector(Re, Im);
  PVector out = new PVector();
  in.div(5);
  out = ComplexPower(in, 3);
  out=ComplexMult(out, ComplexPower(Reciprocal(in.x, in.y), 11));
  out.x-=1;
  return out;
}

///////////////////////////////////////////////////////////////////////
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

  for (int k=1; k < 10; k++) {
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


///////////////////////////////////////////////////////////////////////
////////////////////Operations/////////////////////////////////////////
///////////////////////////////////////////////////////////////////////

PVector ComplexExp(float b, float Re, float Im) {
  PVector out = new PVector();
  float theta = Im*log(b);
  out.x=cos(theta);
  out.y=sin(theta);
  out.mult(pow(b, Re));

  return out;
}

PVector ComplexMult(PVector Z1, PVector Z2) {
  PVector out = new PVector();
  float Re = Z1.x*Z2.x-Z1.y*Z2.y;
  float Im = Z1.x*Z2.y+Z1.y*Z2.x;
  out.set(Re, Im);
  return out;
}

PVector ComplexPower(PVector Z, float exp) {
  PVector out = new PVector();
  float len = pow(Z.mag(), exp);
  float angle = Z.heading()*exp;
  float Re = len*cos(angle);
  float Im = len*sin(angle);
  out.set(Re, Im);
  return out;
}

PVector Reciprocal(float Re, float Im) {
  PVector out=new PVector();
  out.x = Re/(Re*Re+Im*Im);
  out.y = -Im/(Re*Re+Im*Im);
  return out;
}

///////////////////////////////////////////////////////////////////////
//////////////////Color////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////

PVector col(PVector in) {
  PVector HSL = new PVector();
  HSL.x=in.heading();
  if (HSL.x<0) {
    HSL.x=TWO_PI+HSL.x;
  }
  HSL.y=1-pow(colorFactor, in.mag());
  HSL.z=HSL.y;

  if (Float.isNaN(in.mag())) {
    HSL.y=0;
    HSL.z=1;
  }  
  return HSL;
}
