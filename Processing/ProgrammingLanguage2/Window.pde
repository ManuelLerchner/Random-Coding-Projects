ArrayList<LogEntry> allCode=new ArrayList();
float textSpreading=20;

String inputTemp="";
int cursorPos=inputTemp.length();
String displayInput=inputTemp.subSequence(0, cursorPos).toString()+"|"+inputTemp.subSequence(cursorPos, inputTemp.length()).toString();

int swipeIndex=0;
class LogEntry {
  String name;
  color col;
  LogEntry(String name, color col) {
    this.name=name;
    this.col=col;
  }
}



void keyPressed() {


  if (keyCode==UP) {
    if (swipeIndex>1) {
      swipeIndex-=2;
      inputTemp=allCode.get(swipeIndex).name;
      cursorPos=inputTemp.length();
    }
  }

  if (keyCode==DOWN) {
    if (swipeIndex<allCode.size()-2) {
      swipeIndex+=2;
      inputTemp=allCode.get(swipeIndex).name;
      cursorPos=inputTemp.length();
    }
  }


  if (keyCode==37) {
    cursorPos--;
    cursorPos=max(cursorPos, 0);
  }

  if (keyCode==39) {
    cursorPos++;
    cursorPos=min(cursorPos, inputTemp.length() );
  }

  String validChars="abcdefghijklmnopqrstuvwxyzäöüABCDEFGHIJKLMNOPQRSTUVWXYZÄÖÜ1234567890()[]{},.+-*/ =<>!^";

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


  if (key==ENTER) {

    if (inputTemp.matches("clear")) {
      inputTemp="";
      displayInput="";
      cursorPos=0;
      swipeIndex=0;
      allCode.clear();
      return;
    }

    Number Number=run("<std>", inputTemp);
    allCode.add(new LogEntry(inputTemp, color(255)));

    if (Number!=null) {
      allCode.add(new LogEntry(formatNumber(Number), #2BAF07));
    } else {
      allCode.add(new LogEntry("", #2BAF07));
    }
    inputTemp="";
    cursorPos=0;
    swipeIndex=allCode.size();
  }

  displayInput =inputTemp.subSequence(0, cursorPos).toString()+"|"+inputTemp.subSequence(cursorPos, inputTemp.length()).toString();
}



String formatNumber(Number N) {
  return (N.value%1==0)?String.valueOf((int)Math.round(N.value)):String.valueOf(N.value);
}
