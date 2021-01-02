
int AmountQubits;
float tstart;
Layer[] Layers;
Qubit Q;

void setup() {
  size(800, 600);
  rectMode(CENTER);
  textAlign(CENTER, CENTER);
  tstart=millis();



  //https://algassert.com/quirk#circuit={%22cols%22:[[%22H%22],[1,%22H%22],[%22%E2%80%A2%22,%22X%22],[1,%22%E2%80%A2%22,%22X%22],[1,%22%E2%80%A2%22,%22H%22],[%22%E2%80%A2%22,%22H%22],[1,%22%E2%80%A2%22,%22H%22],[1,1,%22%E2%80%A2%22,%22H%22],[1,1,%22%E2%80%A2%22,%22X%22],[%22Y%22],[%22Z^%C2%BD%22],[%22H%22],[1,1,%22H%22],[1,1,1,%22%E2%80%A2%22,%22H%22],[%22Swap%22,%22Swap%22]],%22init%22:[1]}
  Q=new Qubit("0000000100");



  Layer L0=new Layer("HADAMARD", 1);
  Layer L1=new Layer("HADAMARD", 2);
  Layer L2=new Layer("CNOT", 1, 2);
  Layer L3=new Layer("CNOT", 2, 3);
  Layer L4=new Layer("CHADAMARD", 2, 3);
  Layer L5=new Layer("CHADAMARD", 1, 2);
  Layer L6=new Layer("CHADAMARD", 2, 3);
  Layer L7=new Layer("CHADAMARD", 3, 4);
  Layer L8=new Layer("CNOT", 3, 4);
  Layer L9=new Layer("PAULIY", 1);
  Layer L10=new Layer("S", 1);
  Layer L11=new Layer("HADAMARD", 1);
  Layer L12=new Layer("HADAMARD", 3);
  Layer L13=new Layer("CHADAMARD", 4, 5);
  Layer L14=new Layer("SWAP", 1, 2);


  Layer L15=new Layer("PAULIY", 6);
  Layer L16=new Layer("S", 5);
  Layer L17=new Layer("HADAMARD", 6);
  Layer L18=new Layer("HADAMARD", 5);
  Layer L19=new Layer("CHADAMARD", 5, 6);
  Layer L20=new Layer("SWAP", 7, 8);


  println("Layer 7 internal Matrix");
  println("Matrix length: " +L7.mat.length);
  println("______\n");

  Layer[] L={L0, L1, L2, L3, L4, L5, L6, L7, L8, L9, L10, L11, L12, L13, L14, L15, L16, L17, L18, L19, L20};


  Layers=L;
  calcCircuit(Q, L);

  println(Q);

  println("took "+(millis()-tstart)/1000.0 +"s to calculate");
}

void draw() {
  background(51);

  float stepY=height/(AmountQubits+1.0);
  float stepX=width/(Layers.length+1.0);


  stroke(255);
  strokeWeight(1);
  for (int i=1; i < AmountQubits+1; i++) {
    line(10, i*stepY, width-10, i*stepY);
    fill(255);
    text("|"+Q.name.charAt(i-1)+">", 15, i*stepY-10);
  }

  strokeWeight(1.5);
  for (int i=1; i < Layers.length+1; i++) {
    float x=i*stepX;
    float y=(1+Layers[i-1].pos)*stepY;
    pushMatrix();
    translate(x, y);
    showGate(Layers[i-1].name, stepX, stepY);
    popMatrix();
  }
}
