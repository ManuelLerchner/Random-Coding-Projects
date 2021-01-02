//////////////////////////////////////////////////////////////////////////////
Vec2 mousePos=new Vec2(-rangeX/2,-rangeY/2);
void mousePressed() {
  if (mouseButton==LEFT) {
    mousePos=mapPixelToPoint((mouseX-width/2)/scale, (mouseY-height/2)/scale);
  } else {
    transOffset.x+= -(mouseX-width/2)/scale;
    transOffset.y+= -(mouseY-height/2)/scale;
  }  

  inputSelected=false;
  if (mouseX>10&&mouseX<10+textWidth("y = "+inputTemp)+8) {
    if (mouseY>height-40 && mouseY<height-10) {
      inputSelected=true;
    }
  }
  redraw();
}

//////////////////////////////////////////////////////////////////////////////
void mouseReleased() {
  redraw();
}

//////////////////////////////////////////////////////////////////////////////
void mouseDragged() {
  transOffset.x+=(mouseX-pmouseX)/scale;
  transOffset.y+=(mouseY-pmouseY)/scale;
  redraw();
}

//////////////////////////////////////////////////////////////////////////////
void mouseWheel(MouseEvent e) {
  scale*=1-e.getCount()/10.0;
  redraw();
}

//////////////////////////////////////////////////////////////////////////////
StringList keys = new StringList();
void keyPressed() {
  if (keyCode==10) {
    inputSelected=!inputSelected;
  }
  if (keyCode==37) {
    cursorPos--;
    cursorPos=max(cursorPos, 0);
    inputSelected=true;
  }
  if (keyCode==39) {
    cursorPos++;
    cursorPos=min(cursorPos, inputTemp.length() );
    inputSelected=true;
  }
  if (keyCode==38 || keyCode==40 || key==' ') {
    inputSelected=false;
  }
  if (keyCode==8 || keyCode==16) {
    inputSelected=true;
  }
  String validChars="abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890()[]{},.+-*/";
  if (validChars.contains(str(key))) {
    inputSelected=true;
  }
  if (inputSelected) {
    InputIsLive=false;
    if (keyCode!=8 && keyCode!=127 && keyCode!=38 && keyCode!=40) {
      if (validChars.contains(str(key))) {
        String prev=inputTemp.subSequence(0, cursorPos).toString();
        String after=inputTemp.subSequence(cursorPos, inputTemp.length()).toString();
        prev=prev+key;
        cursorPos++;
        inputTemp=prev.concat(after);
      }
    } else {
      if (inputTemp.length()>0) {
        String prev=inputTemp.subSequence(0, cursorPos).toString();
        String after=inputTemp.subSequence(cursorPos, inputTemp.length()).toString();
        if (keyCode==8) {
          prev=prev.substring(0, prev.length()-1);
          cursorPos--;
        } else {
          if (cursorPos<inputTemp.length()) {
            after=after.substring(1, after.length());
          }
        }
        inputTemp=prev.concat(after);
      }
    }
    boolean error=false;
    try {
      parser.setExpression(inputTemp);
      parser.getValue();
    }
    catch(Exception ex) {
      error=true;
    }
    if (!error) {
      InputIsLive=true;
      input=inputTemp;
    }
    parser.setExpression(input);
  } else {
    if (keyCode==38) {
      maxDerivative++;
    }
    if (keyCode==40) {
      maxDerivative--;
      maxDerivative=max(maxDerivative, 0);
    }
    if (key==' ') {
      transOffset.x=0;
      transOffset.y=0;
      scale=1;
      maxDerivative=0;
      input="x*x";
      cursorPos=input.length();
      inputTemp=input;
      parser.setExpression(input);
    }
    if (!keys.hasValue(str(key))) {
      keys.append(str(key));
    }
  }
  redraw();
}

//////////////////////////////////////////////////////////////////////////////
void keyReleased() {
  if (keys.hasValue(str(key))) {
    for (int i=keys.size()-1; i>=0; i--) {
      if (keys.get(i).equals(str(key))) {
        keys.remove(i);
      }
    }
  }
  redraw();
}
