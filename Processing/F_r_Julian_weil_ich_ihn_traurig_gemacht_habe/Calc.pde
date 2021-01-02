

ArrayList<Vec> calc(Complex V1, Complex V2, Complex V3, Complex R1, Complex R2, Complex R3) {
  ArrayList<Vec> out = new ArrayList();


println(V1.im);
println(V2.im);

println(V3.im);

  Vec U1=new Vec(V1, color(255, 125, 125), "U1");
  Vec U2=new Vec(V2, color(125, 255, 125), "U2");
  Vec U3=new Vec(V3, color(125, 125, 255), "U3");


 

  out.add(U1);
  out.add(U2);
  out.add(U3);

  return out;
}
