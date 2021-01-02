//Lexer
import java.util.Arrays;
import java.util.List;
import java.util.HashMap;

static class Token {
  static final String INT ="INT";
  static final String FLOAT ="FLOAT";
  static final String PLUS ="PLUS";
  static final String MINUS ="MINUS";
  static final String MUL ="MUL";
  static final String DIV ="DIV";
  static final String POWER ="POWER";
  static final String LPAREN ="LPAREN";
  static final String RPAREN ="RPAREN";
  static final String IDENTIFIER ="IDENTIFIER";
  static final String KEYWORD ="KEYWORD";
  static final String EQ ="EQ";
  static final String EOF ="EOF";
  static final String EE ="EE";
  static final String NE ="NE";
  static final String LT ="LT";
  static final String GT ="GT";
  static final String LTE ="LTE";
  static final String GTE ="GTE";

  static final String Digits=".0123456789";
  static final String Letters="0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ_abcdefghijklmnopqrstuvwxyzäöüÄÖÜ";

  static final String[] Keywords = {"var", "and", "or", "not", "if", "then", "elif", "else", "for", "to", "step", "while"}; //plotzholta

  String type;
  float value;
  boolean setValue;
  String name;

  Position posStart, posEnd;

  Token(String type) {
    this.type=type;
  }

  String toString() {
    return type + (setValue?(" " +(type.equals(INT)?nf(value, 0, 0):value)):"");
  };
}



class Context {
  String name;
  Context parent;
  Position parentEntryPos;
  SymbolTable SymbolTable;

  Context(String name, Context parent, Position parentEntryPos) {
    this.name=name;
    this.parent=parent;
    this.parentEntryPos=parentEntryPos;
  }
}


class SymbolTable {

  SymbolTable parent;
  HashMap<String, Number> symbols=new HashMap();

  SymbolTable() {
  }


  Number get(String name) {
    Number value=null;

    if (symbols.containsKey(name)) {
      value=symbols.get(name);
    } else {
      if (parent!=null) {
        if (parent.symbols.containsKey(name)) {
          value=parent.symbols.get(name);
        }
      }
    }

    if (value==null) {
      println(name+" is not defined");
      return null;
    }
    return value;
  }

  void set(String name, Number val) {
    symbols.put(name, val);
  }

  void remove(String name) {
    symbols.remove(name);
  }
}



class if_Case {
  Node cond, expr;
  if_Case(Node cond, Node expr) {
    this.cond=cond;
    this.expr=expr;
  }
}
