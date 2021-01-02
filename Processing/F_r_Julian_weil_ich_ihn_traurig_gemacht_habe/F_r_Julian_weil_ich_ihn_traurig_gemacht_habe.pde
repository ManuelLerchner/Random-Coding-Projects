
float scale=1;
PVector globalOffset=new PVector();
ArrayList<Vec> Arrows = new ArrayList();

void setup() {
  size(600, 600);
  textAlign(RIGHT);


  ///////////////////////////////////
  Complex U_l1=new Complex(230, 120);
  Complex U_l2=new Complex(230, 0);
  Complex U_l3=new Complex(230, -120);


  Complex R1=new Complex(10, 0);
  Complex R2=new Complex(10, 0);
  Complex R3=new Complex(10, 0);
  ///////////////////////////////////



  ArrayList<Vec> myVec=calc(U_l1, U_l2, U_l3, R1, R2, R3);
  Arrows.addAll(myVec);




}

void draw() {
  background(51);
  translate(width/2.0, height/2.0);
  scale(scale);


  for (Vec V : Arrows) {
    V.show();
  }
}
