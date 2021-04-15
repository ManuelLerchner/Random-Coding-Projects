PVector toScreenPos(PVector in) {

  float x=(in.x*width/range+transOffset.x)*scale;
  float y=-(in.y*width/range+transOffset.y)*scale;

  return new PVector(x, y);
}


PVector toAbsolutePos(PVector in) {

  float x=(in.x/scale-transOffset.x)/width*range;
  float y=(-in.y/scale-transOffset.y)/width*range;

  return new PVector(x, y);
}


float calcArea() {
  ArrayList<PVector> Points=new ArrayList();

  Vertex running=Vertices.get(0);

  while (running !=null) {
    Points.add(running.pos);
    running=running.child;
  }


  float A=0;
  for (int i=0; i < Points.size(); i++) {
    PVector P_i=Points.get(i);
    PVector P_n=Points.get((i+1)%Points.size());

    A+=(P_i.y+P_n.y)*(P_i.x-P_n.x);
  }

  A=0.5*abs(A);

  return A;
}
