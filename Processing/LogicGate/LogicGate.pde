float scale=2;
PVector globalPanOffset=new PVector();
PVector mouse;
boolean globalSelected;
boolean globalDrawSelected;
boolean globalHighlighted;

/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
 'a' spawn AND
 'o' spawn OR
 'n' spawn NOT
 'A' spawn NAND
 'O' spawn NOR
 'e' spawn EQU
 'x' spawn XOR
 
 'b' spawn BUTTON
 't' spawn TORCH
 
 Click on the edge of an Object to enter its edit Menu. With the letters '1' through '9' you can negate the i-th Pin of the Object
 
 Press 's' to save
 
 Use Mouse-RIGHT to delete Objects and Lines
 Use Mouse-LEFT to connect Objects
 USE Mouse-MIDDLE to select and move Objects
 ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
 */

ArrayList<UTILITY> Utility=new ArrayList();

void setup() {
  size(800, 800);
  rectMode(CENTER);
  textAlign(CENTER, CENTER);
  textSize(10);

   selectInput("Select a file to load:", "fileSelectedIN");
  //loadData("data/Adder.txt");
//  Utility.add(new UTILITY(new ADDER(), new PVector(0, 0)));
}

void draw() {
  background(41);
  translate(width/2, height/2);
  scale(scale);

  setMouse();
  connectDrawing();
  grid();

  for (int i=0; i<Utility.size(); i++) {
    UTILITY U = Utility.get(i);
    U.update();
    U.move();
  }

  //Update Automaticall
  if (frameCount%50==0) {
    // updateNetwork();
    for (UTILITY U : Utility) {
      for (int i=0; i<U.Connectors.size(); i++) {
        Connector C =U.Connectors.get(i);
        if (C.type.equals("Output")) {
          U.WireUpdate(C, U.state[i]);
        }
      }
    }
  }
}
