//Leftclick = place Node; Click on Node to select Node; if selected Connect to next Node while a Condition (Keyboard) is in the "Contitions" String; 
//Middle click on Node to make it AKTZEPTIERENDER ZUSTAND, so if a Orb lands here and survives, it gets printet to the console 
//Middle click on Line to make it to EPSILON ÜBERGANG
//Enter Condition as a single long string ("148018300723") and press enter to autoTest the string, you can select single Test in the corner to enter a single condition ("2","5","2") hit enter to move orb forward
//if an orb has multiple possible paths it gets cloned and uses all of them in parallel, the orb dies if it has no valid path
//Drag to pan, Mousewheel to zoom
//rightclick on Nodes, or LineText to delete the Segment
//LeftClick on LineText to straighten the line
boolean OneDigitEntries=true;
//if OneDigitEntries is enabled you can only input one digit conditions, else you have to seperate them with ","

ArrayList<Node> Nodes = new ArrayList();
ArrayList<Orb> Orbs = new ArrayList();

float scale=1;
PVector transOffset=new PVector();
String input="1";
String inputTemp="";
String inputPrev="";
boolean moveOrbs;
boolean programmingMode=true;
boolean singleInput;
boolean autoTest;
boolean globalMoving;
int StringCount;

void setup() {
  size(600, 600);
}

void draw() {
  background(80, 100, 100);
  textAlign(CENTER, CENTER);
  pushMatrix();
  translate(width/2, height/2);
  scale(scale);
  mousePos.set((mouseX-width/2)/scale-transOffset.x, (mouseY-height/2)/scale-transOffset.y);
  globalMoving=false;

  for (Node N : Nodes) {
    N.connect();
  }
  for (Node N : Nodes) {
    N.show();
    N.interact();
  }

  for (int i =Orbs.size()-1; i>=0; i--) {
    Orb O = Orbs.get(i);
    O.react();
    O.move();
    O.show();
  }
  popMatrix();

  AutoTest();
  HUD();
}

////////////////////////////////////////////////////////////////////////////////////////////////
void AutoTest() {
  moveOrbs=false;
  if (autoTest) {
    boolean epsilonMoved=false;
    for (Node start : Nodes) {
      for (int i = 0; i<start.outputs.size(); i++) {
        Node Target = start.outputs.get(i);
        if (start.Orbs.size()>0) {
          if (start.conditions.get(i).equals("ε")) {
            if (Target.Orbs.size()==0) {
              if (!Target.reserved) {
                Orb New = new Orb(start, start.Orbs.get(0).pastNodes.copy(), true);
                New.pastNodes.append(start.index);
                Target.reserved=true;
                New.speed=0.05;
                New.end=Target;
                New.moving=true;
                Orbs.add(New);
                epsilonMoved=true;
                globalMoving=true;
              }
            }
          }
        }
      }
    }

    if (!globalMoving) {
      if (!epsilonMoved) {
        if (StringCount<Word.size()) {
          inputTemp=Word.get(StringCount);
          StringCount++;
          moveOrbs=true;
          input=inputTemp;
        } else {
          autoTest=false;
          globalMoving=false;
          println("----------------------------------------------");
          println(nf(hour(), 2)+":"+nf(minute(), 2)+":"+nf(second(), 2));
          println("");
          for (Node N : Nodes) {
            if (N.acceptingNode==true) {
              for (Orb O : N.Orbs) {
                println("Word:'" +inputPrev+"'");
                println("End on: Z"+N.index );
                println("Path taken:");
                print("[");
                for (int i : O.pastNodes) {
                  print("Z"+i+",");
                }
                print("Z"+N.index);
                println("]");
                println("");
              }
            }
          }
          print("----------------------------------------------");

          input=inputPrev;
          cursorPos=input.length();
        }
      }
    }
  }
}

////////////////////////////////////////////////////////////////////////////////////////////////
void HUD() {
  fill(255);
  textAlign(LEFT, CENTER);
  String InputFunction="Current Input: ";
  if (programmingMode) {
    text("Programming Mode\nHit ENTER to test", +5, height-20);
    InputFunction="Condition: ";
  } else {
    text("Testing Mode\nHit SPACE to exit", +5, height-20);
  }

  fill(255);
  String displayFunction =input.subSequence(0, cursorPos).toString()+"|"+input.subSequence(cursorPos, input.length()).toString();
  text(InputFunction+displayFunction, 5, 20);

  if (!programmingMode) {
    fill(255, 0, 200);
    ellipse(width-20, height-20, 10, 10);
    text("Single Input: "+singleInput, width-125, height-15);
  }
}
