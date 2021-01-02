import java.util.LinkedList;


class Lexer {

  String text;
  String fn;
  char currentChar;
  Position pos;


  Lexer(String fn, String text) {
    this.fn=fn;
    this.text=text;
    this.pos=new Position(-1, 0, -1, fn, text);
    advance();
  }


  void advance() {
    pos.advance(currentChar);
    if (pos.idx<text.length()) {
      currentChar=text.charAt(pos.idx);
    } else {
      currentChar=0;
    }
  }

  LinkedList<Token> makeToken() {
    LinkedList<Token> tokens=new LinkedList<Token>();
    try {

      while (currentChar!=0) {
        if (currentChar==' ' || currentChar=='\t') {
          advance();
        } else {

          if (Token.Digits.contains(str(currentChar))) {
            tokens.add(makeNumber());
          }

          if (Token.Letters.contains(str(currentChar))) {
            tokens.add(makeIdentifier());
          }


          Token T;
          switch(currentChar) {
          case '+':
            T=new Token(Token.PLUS);
            T.posStart=pos;
            T.posEnd=pos.copy().advance(currentChar);
            tokens.add(T);
            advance();
            break;
          case '-':
            T=new Token(Token.MINUS);
            T.posStart=pos;
            T.posEnd=pos.copy().advance(currentChar);
            tokens.add(T);
            advance();
            break;
          case '*':
            T=new Token(Token.MUL);
            T.posStart=pos;
            T.posEnd=pos.copy().advance(currentChar);
            tokens.add(T);
            advance();
            break;
          case '/':
            T=new Token(Token.DIV);
            T.posStart=pos;
            T.posEnd=pos.copy().advance(currentChar);
            tokens.add(T);
            advance();
            break;
          case '^':
            T=new Token(Token.POWER);
            T.posStart=pos;
            T.posEnd=pos.copy().advance(currentChar);
            tokens.add(T);
            advance();
            break;
          case '(':
            T=new Token(Token.LPAREN);
            T.posStart=pos;
            T.posEnd=pos.copy().advance(currentChar);
            tokens.add(T);
            advance();
            break;
          case ')':
            T=new Token(Token.RPAREN);
            T.posStart=pos;
            T.posEnd=pos.copy().advance(currentChar);
            tokens.add(T);
            advance();
            break;
          case '!':
            T=makeNotEquals();
            T.posStart=pos;
            T.posEnd=pos.copy().advance(currentChar);
            tokens.add(T);
            break;
          case '=':
            T=makeEquals();
            T.posStart=pos;
            T.posEnd=pos.copy().advance(currentChar);
            tokens.add(T);
            break;
          case '<':
            T=makeLessThan();
            T.posStart=pos;
            T.posEnd=pos.copy().advance(currentChar);
            tokens.add(T);
            break;
          case '>':
            T=makeGreaterThan();
            T.posStart=pos;
            T.posEnd=pos.copy().advance(currentChar);
            tokens.add(T);
            break;
          case 0:
            advance();
            break;
          case ' ':
            advance();
            break;

          default:
            //Error
            Position posStart=pos.copy();
            char curr=currentChar;
            advance();
            throw new IllegalCharError(posStart, pos, str(curr));
          }
        }
      }
    }
    catch(IllegalCharError E) {
      println(E);
    }

    Token EOF=new Token(Token.EOF);
    EOF.posStart=pos;
    EOF.posEnd=pos.copy().advance(currentChar);
    tokens.add(EOF);
    return tokens;
  }

  Token makeNumber() {
    String numStr="";
    int dotCount=0;
    Position posStart=pos.copy();

    while (currentChar!=0 && Token.Digits.contains(str(currentChar))) {
      if (currentChar=='.') {
        if (dotCount>=1) {
          break;
        }
        dotCount++; 
        numStr+=".";
      } else {
        numStr+=str(currentChar);
      }
      advance();
    }

    if (dotCount==0) {
      Token INT=new Token(Token.INT);
      INT.value=int(numStr);
      INT.posStart=posStart;
      INT.posEnd=pos.copy().advance(currentChar);
      INT.setValue=true;
      return INT;
    } else { 
      Token FLOAT=new Token(Token.FLOAT);
      FLOAT.value=float(numStr);
      FLOAT.posStart=posStart;
      FLOAT.posEnd=pos.copy().advance(currentChar);
      FLOAT.setValue=true;
      return FLOAT;
    }
  }

  Token makeIdentifier() {
    String idstr="";
    Position posStart=pos.copy();

    while (currentChar!=0 && Token.Letters.contains(str(currentChar))) {
      idstr+=str(currentChar);
      advance();
    }

    if (Arrays.asList(Token.Keywords).contains(idstr)) {
      Token Keyword=new Token(Token.KEYWORD);
      Keyword.posStart=posStart;
      Keyword.posEnd=pos.copy().advance(currentChar);
      Keyword.name=idstr;
      return Keyword;
    } else {
      Token Identifier=new Token(Token.IDENTIFIER);
      Identifier.posStart=posStart;
      Identifier.posEnd=pos.copy().advance(currentChar);
      Identifier.name=idstr;
      return Identifier;
    }
  }

  Token makeNotEquals() {
    Position posStart=pos.copy();

    advance();

    if (currentChar=='=') {
      advance();
      Token NE=new  Token(Token.NE);
      NE.posStart=posStart;
      NE.posEnd=pos.copy().advance(currentChar);
      return NE;
    }

    println("Expected '=' after '!'");
    return null;
  }

  Token makeEquals() {
    Position posStart=pos.copy();
    advance();

    if (currentChar=='=') {
      advance();
      Token EE=new Token(Token.EE);
      EE.posStart=posStart;
      EE.posEnd=pos.copy().advance(currentChar);
      return EE;
    }

    Token EQ=new  Token(Token.EQ);
    EQ.posStart=posStart;
    EQ.posEnd=pos.copy().advance(currentChar);

    return EQ;
  }

  Token makeLessThan() {
    Position posStart=pos.copy();
    advance();


    if (currentChar=='=') {
      advance();
      Token LTE=new  Token(Token.LTE);
      LTE.posStart=posStart;
      LTE.posEnd=pos.copy().advance(currentChar);
      return LTE;
    }

    Token LT=new  Token(Token.LT);
    LT.posStart=posStart;
    LT.posEnd=pos.copy().advance(currentChar);

    return LT;
  }

  Token makeGreaterThan() {
    Position posStart=pos.copy();
    advance();

    if (currentChar=='=') {
      advance();
      Token GTE=new  Token(Token.GTE);
      GTE.posStart=posStart;
      GTE.posEnd=pos.copy().advance(currentChar);
      return GTE;
    }

    Token GT=new  Token(Token.GT);
    GT.posStart=posStart;
    GT.posEnd=pos.copy().advance(currentChar);

    return GT;
  }
}
