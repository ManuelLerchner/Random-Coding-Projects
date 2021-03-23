String inputTemp="1";
String displayedInput="1";

int cursorPos=1;

void keyPressed() {

  try {
    if (key=='x') {
      fliesenSize.x=Float.parseFloat(inputTemp);
    }

    if (key=='y') {
      fliesenSize.y=Float.parseFloat(inputTemp);
    }
  }
  catch(NumberFormatException E) {
  }


  if (key=='g') {
    showGrid^=true;
    notificationSet=millis();
    notification="Grid toggled";
  }

  if (key=='o') {
    ortho^=true;
    println("OrthoMode: " +ortho);
    notificationSet=millis();
    notification="Ortho-Mode toggled";
  }

  if (key=='r') {
    fliesenOffset.set(0, 0);
    fliesenRotation=0;
    notificationSet=millis();
    notification="Grid reseted";
  }

  if (key=='p') {
    toPrint=true;
    notificationSet=millis();
    notification="Printed to Desktop";
  }

  if (key=='s') {
    selectOutput("Select or create a file to write to:", "fileSelectedOUT");
    notificationSet=millis();
    notification="Saved!";
  }

  if (key=='l') {
    pause=true;
    selectInput("Select a file to load:", "fileSelectedIN");
    notificationSet=millis();
    notification="Loaded!";
  }

  if (keyCode==37) {
    cursorPos--;
    cursorPos=max(cursorPos, 0);
  }

  if (keyCode==39) {
    cursorPos++;
    cursorPos=min(cursorPos, inputTemp.length() );
  }

  String validChars="1234567890.";

  if (keyCode!=8 && keyCode!=127 && keyCode!=38 && keyCode!=40 &&keyCode!=DOWN && keyCode!=UP) {

    if (validChars.contains(str(key))||keyCode==130) {

      String prev=inputTemp.subSequence(0, cursorPos).toString();
      String after=inputTemp.subSequence(cursorPos, inputTemp.length()).toString();
      if (keyCode==130) {
        prev=prev+'^';
      } else {
        prev=prev+key;
      }
      cursorPos++;
      inputTemp=prev.concat(after);
    }
  } else {

    if (inputTemp.length()>0) {
      String prev=inputTemp.subSequence(0, cursorPos).toString();
      String after=inputTemp.subSequence(cursorPos, inputTemp.length()).toString();
      if (keyCode==8) {
        prev=prev.substring(0, prev.length()-1);
        after=after.substring(0, after.length());
        cursorPos--;
      }
      inputTemp=prev.concat(after);
    }
  }

  displayedInput =inputTemp.subSequence(0, cursorPos).toString()+"|"+inputTemp.subSequence(cursorPos, inputTemp.length()).toString();
}
