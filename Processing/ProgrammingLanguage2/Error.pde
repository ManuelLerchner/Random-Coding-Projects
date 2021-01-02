//Encountered Error Pos
class Position {
  int idx;
  int ln;
  int col;

  String fn, ft;

  Position(int idx, int ln, int col, String fn, String ft) {
    this.idx=idx;
    this.ln=ln;
    this.col=col;
    this.fn=fn;
    this.ft=ft;
  }

  Position advance(char currentChar) {
    idx++;
    col++;
    if (currentChar=='\n') {
      ln++;
      col=0;
    }
    return this;
  }

  Position copy() {
    return new Position(idx, ln, col, fn, ft);
  }
}

/////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////



class Error extends Throwable {
  String errorName;
  String details;
  Position posStart, posEnd;

  Error(Position posStart, Position posEnd, String errorName, String details) {
    this.posStart=posStart;
    this.posEnd=posEnd;
    this.errorName=errorName;
    this.details=details;
  }

  String toString() {
    String out= "\nFound Error:\n";
    out+= errorName +": " +details +"\n";
    out+="File: "+ posStart.fn +", Line: " +(posStart.ln+1);

    out+="\n\n";
    out+=posStart.ft;
    out+=arrows(posStart.ft.length(), posStart.idx, posEnd.idx);
    return out;
  }
}

String arrows(int len, int start, int end) {
  String out="\n";

  for (int i=0; i <= len; i++) {
    if (i<start-1 || i>end-1) {
      out+=" ";
    } else {
      out+="^";
    }
  }
  return out;
}


class IllegalCharError extends Error {
  IllegalCharError(Position posStart, Position posEnd, String details) {
    super(posStart, posEnd, "Illegal Character", details);
  }
}

class InvalidSyntaxError extends Error {
  InvalidSyntaxError(Position posStart, Position posEnd, String details) {
    super(posStart, posEnd, "Invalid Syntax", details);
  }
}

class RTError extends Error {
  Context Context;
  Position posStart;

  RTError(Position posStart, Position posEnd, String details, Context Context) {
    super(posStart, posEnd, "Runtime Error", details);
    this.Context=Context;
    this.posStart=posStart;
  }

  String toString() {

    String out= "\nFound Error:\n";
    if (posStart==null) {
      return out;
    }
    out += generateTraceBack();
    out+= errorName +": " +details +"\n";

    out+="\n\n";
    out+=posStart.ft;
    out+=arrows(posStart.ft.length(), posStart.idx, posEnd.idx);
    return out;
  }


  String generateTraceBack() {
    String out="";
    Position pos=posStart;
    Context ctx=Context;

    while (ctx!=null) {
      out="File: "+ pos.fn +", Line: " +(pos.ln+1)+", in " + ctx.name +"\n"+out;
      pos=ctx.parentEntryPos;
      ctx=ctx.parent;
    }

    return "Tracebeack:\n"+out;
  }
}
