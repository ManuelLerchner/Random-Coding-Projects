import java.util.regex.Pattern;
import java.util.LinkedList;
import java.util.regex.Matcher;


class Tokenizer {
  LinkedList<TokenInfo> tokenInfo;
  LinkedList<Token> tokens;

  Tokenizer() {
    tokenInfo= new LinkedList<TokenInfo>();
    tokens = new LinkedList<Token>();


    add("sin|cos|exp|ln|sqrt|print|repeat", 1); // function
    add("\\(", 2); // open bracket
    add("\\)", 3); // close bracket
    add("[+-]", 4); // plus or minus
    add("[*/]", 5); // mult or divide
    add("\\^", 6); // raised
    add("[0-9]+", 7); // integer number
    add("[a-zA-Z][a-zA-Z0-9_]*", 8); // variable

    add("=", 9); // expr
    add(";", 10); // expr
  }

  void add(String regex, int token) {
    tokenInfo.add(new TokenInfo(Pattern.compile("^("+regex+")"), token));
  }

  void tokenize(String str) {
    String s = str.trim();
    tokens.clear();
    while (!s.equals("")) {
      boolean match = false;

      for (TokenInfo info : tokenInfo) {
        Matcher m = info.regex.matcher(s);
        if (m.find()) {
          match = true;

          String tok = m.group().trim();
          tokens.add(new Token(info.token, tok));

          s = m.replaceFirst("").trim();
          break;
        }
      }

      if (!match) throw new RuntimeException  (
        "Unexpected character in input: "+s);
    }
  }
}



class TokenInfo {
  Pattern regex;
  int token;

  TokenInfo(Pattern regex, int token) {
    this.regex = regex;
    this.token = token;
  }
}


class Token {
  static final int EPSILON = 0;
  static final int PLUSMINUS = 4;
  static final int MULTDIV = 5;
  static final int RAISED = 6;
  static final int FUNCTION = 1;
  static final int OPEN_BRACKET = 2;
  static final int CLOSE_BRACKET = 3;
  static final int NUMBER = 7;
  static final int VARIABLE = 8;
  static final int ASSIGNMENT = 9;
  static final int ENDCHAR = 10;
  static final int STRUCTURE = 11;

  int token;
  String sequence;

  Token(int token, String sequence) {
    this.token = token;
    this.sequence = sequence;
  }
}
