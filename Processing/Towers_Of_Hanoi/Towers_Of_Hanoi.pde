int hei = 20;
int chosen=-1;
long count;
int moveCount=1;
int PieceToMove=1;
PVector posBevore = new PVector();

boolean Manually=false;
float speed= 0.1;
int n = 10;

boolean next;
boolean stop;
ArrayList<Scheibe> Scheiben = new ArrayList();
ArrayList<Flanke> Flanken = new ArrayList();
IntList P1 = new IntList();
IntList P2 = new IntList();
IntList P3 = new IntList();


int binary;
int[] Binary = new int[n];
void setup() {
  size(800, 600);
  rectMode(CORNERS);
  textAlign(CENTER, CENTER);

  for (int i=0; i < n; i++) {
    Scheiben.add(new Scheibe(i, 1));
    Flanken.add(new Flanke());
  }
}

void draw() {
  colorMode(RGB, 255, 255, 255);
  background(255);


  //Background
  fill(#763502);
  for (int i=1; i < 4; i++) {
    rect(width/4*i-4, 350, width/4*i+4, 500);
  }
  rect(50, 500, width-50, 520);


  //Text
  fill(0);
  textSize(20);
  text("Count: " +count, width/2, 20);

  String b= binary(moveCount);
  b.trim();
  try {
    binary= Integer.parseInt(b);
  }catch(NumberFormatException e){
    println("Error");
  }

  binary=binary%int(pow(10, n));
  text(nf(binary, n), width/2, 80);

  for (int i=0; i < n; i++) {
    Binary[n-i-1]=digit(binary, i+1);
    if (Flanken.get(i).FP(boolean(Binary[n-i-1]))==true) {
      PieceToMove=i+1;
    }
  }
  text("Move: "+PieceToMove, 650, 80);

  for (Scheibe S : Scheiben) {
    S.show();
    S.setPillar();
  }

  for (Scheibe S : Scheiben) {
    if (Manually) {
      S.chosePieceToMoveManually();
    } else {
      if (!stop) {
        S.moveAutomatic(PieceToMove);
      }
      S.lerpTo();
    }
  }

  if (P2.size()==n) {
    stop=true;
  }


  if (P3.size()==n) {
    stop=true;
  }

  P1.clear();
  P2.clear();
  P3.clear();
}


int digit(int a, int n) {
  return (a%int(pow(10, n))/(int(pow(10, n-1))));
}
