class Parser {

  LinkedList<Token> Tokens;
  int tokIdx;
  Token currentToken;

  Parser(LinkedList<Token> Tokens) {
    this.Tokens=Tokens;
    tokIdx=-1;
    advance();
  }

  Token advance() {
    tokIdx++; 
    if (tokIdx<Tokens.size()) {
      currentToken=Tokens.get(tokIdx);
    }
    return currentToken;
  }


  ParseResult parse() {
    ParseResult res=expression();
    if (res.Error==null && !currentToken.type.equals(Token.EOF)) {
      return res.failure(new InvalidSyntaxError(currentToken.posStart, currentToken.posEnd, "Expected +,-,/,*"));
    }
    return res;
  }


  ParseResult for_expr() {
    ParseResult res=new ParseResult();


    if (!(currentToken.type.equals(Token.KEYWORD) && currentToken.name.equals("for"))) {
      return res.failure(new InvalidSyntaxError(currentToken.posStart, currentToken.posEnd, "Expected for"));
    }


    res.register(advance());


    if (!(currentToken.type.equals(Token.IDENTIFIER))) {
      return res.failure(new InvalidSyntaxError(currentToken.posStart, currentToken.posEnd, "Expected identifier"));
    }


    Token varName=currentToken;

    res.register(advance());


    if (!(currentToken.type.equals(Token.EQ))) {
      return res.failure(new InvalidSyntaxError(currentToken.posStart, currentToken.posEnd, "Expected equals"));
    }


    res.register(advance());


    Node startValue=res.register(expression());

    if (res.Error!=null) {
      return res;
    }



    if (!(currentToken.type.equals(Token.KEYWORD) && currentToken.name.equals("to"))) {
      return res.failure(new InvalidSyntaxError(currentToken.posStart, currentToken.posEnd, "Expected to"));
    }

    res.register(advance());

    Node endValue=res.register(expression());
    if (res.Error!=null) {
      return res;
    }




    Node step=null;
    if (currentToken.type.equals(Token.KEYWORD) && currentToken.name.equals("step")) {
      res.register(advance());
      step=res.register(expression());
      if (res.Error!=null) {
        return res;
      }
    }

    if (!(currentToken.type.equals(Token.KEYWORD) && currentToken.name.equals("then"))) {
      return res.failure(new InvalidSyntaxError(currentToken.posStart, currentToken.posEnd, "Expected then"));
    }

    res.register(advance());

    Node body=res.register(expression());
    if (res.Error!=null) {
      return res;
    }


    //

    forNode out=new forNode(varName, startValue, endValue, body);
    out.stepValueNode=step;
    return res.success(out);
  }


  ParseResult while_expr() {
    ParseResult res=new ParseResult();


    if (!(currentToken.type.equals(Token.KEYWORD) && currentToken.name.equals("while"))) {
      return res.failure(new InvalidSyntaxError(currentToken.posStart, currentToken.posEnd, "Expected while"));
    }


    res.register(advance());
    Node condition=res.register(expression());
    if (res.Error!=null) {
      return res;
    }


    if (!(currentToken.type.equals(Token.KEYWORD) && currentToken.name.equals("then"))) {
      return res.failure(new InvalidSyntaxError(currentToken.posStart, currentToken.posEnd, "Expected then"));
    }
    
  

    res.register(advance());

    Node body=res.register(expression());
    if (res.Error!=null) {
      return res;
    }

    whileNode out=new whileNode(condition, body);
    return res.success(out);
  }


  ParseResult if_expr() {
    ParseResult res=new ParseResult();
    LinkedList<if_Case> cases=new LinkedList<if_Case>();
    Node elseCase=null;

    if (!(currentToken.type.matches(Token.KEYWORD) && currentToken.name.equals("if"))) {

      return res.failure(new InvalidSyntaxError(currentToken.posStart, currentToken.posEnd, "Expected if"));
    }

    res.register(advance());
    Node condition=res.register(expression());

    if (res.Error!=null) {
      return res;
    }

    if (!(currentToken.type.matches(Token.KEYWORD) && currentToken.name.equals("then"))) {
      return res.failure(new InvalidSyntaxError(currentToken.posStart, currentToken.posEnd, "Expected then"));
    }

    res.register(advance());

    Node expr=res.register(expression());
    if (res.Error!=null) {
      return res;
    }
    cases.add(new if_Case(condition, expr));



    while (currentToken.type.equals(Token.KEYWORD) && currentToken.name.equals("elif")) {
      res.register(advance());
      condition=res.register(expression());

      if (!(currentToken.type.matches(Token.KEYWORD) && currentToken.name.equals("then"))) {
        return res.failure(new InvalidSyntaxError(currentToken.posStart, currentToken.posEnd, "Expected then"));
      }

      res.register(advance());

      expr=res.register(expression());

      if (res.Error!=null) {
        return res;
      }
      cases.add(new if_Case(condition, expr));
    }


    if (currentToken.type.matches(Token.KEYWORD) && currentToken.name.equals("else")) {
      res.register(advance());
      expr=res.register(expression());
      if (res.Error!=null) {
        return res;
      }
      elseCase=expr;
    }




    return res.success(new ifNode(cases, elseCase));
  }

  ParseResult atom() {
    ParseResult res=new ParseResult();

    Token tok=currentToken;

    if (tok.type==Token.INT || tok.type==Token.FLOAT) {
      res.register(advance());
      return res.success(new NumberNode(tok));

      //
    } else if (tok.type==Token.IDENTIFIER) {
      res.register(advance());
      return res.success(new VarAccessNode(tok));



      //
    } else if (tok.type==Token.LPAREN) {
      res.register(advance());

      Node expr=res.register(expression());
      if (res.Error!=null) {
        return res;
      }


      if (currentToken.type.equals(Token.RPAREN)) {
        res.register(advance());
        return res.success(expr);
      } else {
        return res.failure(new InvalidSyntaxError(tok.posStart, currentToken.posEnd, "Expected ')'"));
      }

      //
    } else if (tok.type==Token.KEYWORD && tok.name.equals("if")) {
      Node if_expr=res.register(if_expr());

      if (res.Error!=null) {
        return res;
      }
      return res.success(if_expr);

      //
    } else if (tok.type==Token.KEYWORD && tok.name.equals("for")) {
      Node for_expr=res.register(for_expr());

      if (res.Error!=null) {
        return res;
      }
      return res.success(for_expr);
    } else if (tok.type==Token.KEYWORD && tok.name.equals("while")) {
      Node while_expr=res.register(while_expr());

      if (res.Error!=null) {
        return res;
      }
      return res.success(while_expr);
    }
    return res.failure(new InvalidSyntaxError(tok.posStart, currentToken.posEnd, "Expected int,float,+,-, '(' "));
  }

  ParseResult power() {
    ParseResult res=new ParseResult();
    Node left=res.register(atom());

    if (res.Error!=null) {
      return res;
    }

    while (currentToken.type.equals(Token.POWER)) {
      Token opTok=currentToken;
      res.register(advance());
      Node right=res.register(factor());
      if (res.Error!=null) {
        return res;
      }
      left=new BinOpNode(left, opTok, right);
    }
    return res.success(left);
  }


  ParseResult factor() {
    ParseResult res=new ParseResult();
    Token tok=currentToken;

    if (tok.type.equals(Token.PLUS) || tok.type.equals(Token.MINUS)) {

      res.register(advance());
      Node factor=res.register(factor());
      if (res.Error!=null) {
        return res;
      }
      return res.success(new UnaryOpNode(tok, factor));

      //
    } 

    return power();
  }

  ParseResult term() {
    ParseResult res=new ParseResult();
    Node left=res.register(factor());

    if (res.Error!=null) {
      return res;
    }

    while (currentToken.type.equals(Token.MUL) || currentToken.type.equals(Token.DIV)) {
      Token opTok=currentToken;
      res.register(advance());
      Node right=res.register(factor());
      if (res.Error!=null) {
        return res;
      }
      left=new BinOpNode(left, opTok, right);
    }
    return res.success(left);
  }


  ParseResult comp_expr() {
    ParseResult res0=new ParseResult();


    if (currentToken.type.equals(Token.KEYWORD) && currentToken.name.equals("not")) {

      Token op_tok=currentToken;
      res0.register(advance());

      Node out=res0.register(comp_expr());
      if (res0.Error!=null) {
        return res0;
      }
      return res0.success(new UnaryOpNode(op_tok, out));
    }


    //
    ParseResult res=new ParseResult();
    Node left=res.register(arith_expr());

    if (res.Error!=null) {
      return res;
    }

    while (currentToken.type.equals(Token.NE)||currentToken.type.equals(Token.EE)  ||currentToken.type.equals(Token.LT) ||currentToken.type.equals(Token.GT) ||currentToken.type.equals(Token.LTE) || currentToken.type.equals(Token.GTE)) {
      Token opTok=currentToken;
      res.register(advance());
      Node right=res.register(arith_expr());
      if (res.Error!=null) {
        return res;
      }
      left=new BinOpNode(left, opTok, right);
    }

    return res.success(left);
  }


  ParseResult arith_expr() {
    ParseResult res=new ParseResult();
    Node left=res.register(term());

    if (res.Error!=null) {
      return res;
    }

    while (currentToken.type.equals(Token.PLUS) || currentToken.type.equals(Token.MINUS) ) {
      Token opTok=currentToken;
      res.register(advance());
      Node right=res.register(term());
      if (res.Error!=null) {
        return res;
      }
      left=new BinOpNode(left, opTok, right);
    }

    return res.success(left);
  }


  ParseResult expression() {

    ParseResult res0=new ParseResult();
    if (currentToken.type.equals(Token.KEYWORD) && currentToken.name.equals("var")) {
      res0.register(advance());

      if (!currentToken.type.equals(Token.IDENTIFIER)) {
        return res0.failure(new InvalidSyntaxError(currentToken.posStart, currentToken.posEnd, "Expected Identifier"));
      }

      Token varName=currentToken;
      res0.register(advance());

      if (!currentToken.type.equals(Token.EQ)) {
        return res0.failure(new InvalidSyntaxError(currentToken.posStart, currentToken.posEnd, "Expected '='"));
      }
      res0.register(advance());

      Node expr=res0.register(expression());
      if (res0.Error!=null) {
        return res0;
      }
      return res0.success(new VarAssignNode(varName, expr));
    }


    //
    ParseResult res=new ParseResult();
    Node left=res.register(comp_expr());

    if (res.Error!=null) {
      return res;
    }


    while (currentToken.type.equals(Token.KEYWORD) &&( currentToken.name.equals("and") || currentToken.name.equals("or")) ) {

      Token opTok=currentToken;
      res.register(advance());
      Node right=res.register(comp_expr());
      if (res.Error!=null) {
        return res;
      }
      left=new BinOpNode(left, opTok, right);
    }

    return res.success(left);
  }
}




class ParseResult {
  Node Node;
  Error Error;
  ParseResult() {
  }

  Node register(ParseResult PR) {
    if (PR.Error!=null) {
      this.Error=PR.Error;
    }
    return PR.Node;
  }


  Token register(Token N) {
    return N;
  }

  ParseResult success(Node N) {
    this.Node=N;
    return this;
  }

  ParseResult failure(Error E) {
    this.Error=E;
    println(E);
    return this;
  }
}
