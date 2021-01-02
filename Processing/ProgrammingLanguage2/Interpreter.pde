class Interpreter {

  Interpreter() {
  }


  RTResult visit(Node N, Context Context) {

    if (N.getClass()==NumberNode.class) {
      return visitNumberNode((NumberNode)N, Context);
    } else if (N.getClass()==BinOpNode.class) {

      return visitBinOpNode((BinOpNode)N, Context);
    } else if (N.getClass()==UnaryOpNode.class) {
      return visitUnaryOpNode((UnaryOpNode)N, Context);
    } else if (N.getClass()==VarAssignNode.class) {
      return visitVarAssignNode((VarAssignNode)N, Context);
    } else if (N.getClass()==VarAccessNode.class) {
      return visitVarAccessNode((VarAccessNode)N, Context);
    } else if (N.getClass()==ifNode.class) {
      return visitIfNode((ifNode)N, Context);
    } else if (N.getClass()==forNode.class) {
      return visitforNode((forNode)N, Context);
    } else if (N.getClass()==whileNode.class) {
      return visitwhileNode((whileNode)N, Context);
    } else {
      throw new RuntimeException("No visit Method defined");
    }
  }


  RTResult visitVarAccessNode(VarAccessNode N, Context Context) {

    RTResult res= new RTResult();
    String varName=N.varNameToken.name;
    Number val=Context.SymbolTable.get(varName);

    return res.success(val);
  }

  RTResult visitVarAssignNode(VarAssignNode N, Context Context) {

    RTResult res= new RTResult();
    String varName=N.varNameToken.name;
    Number val=res.register(visit(N.valueNode, Context));
    if (res.Error!=null) {
      return res;
    }
    Context.SymbolTable.set(varName, val);

    return res.success(val);
  }


  RTResult visitNumberNode(NumberNode N, Context Context) {
    RTResult res= new RTResult();
    Number out=new Number(N.numberToken.value);
    out.setContext(Context);
    out.setPos(N.numberToken.posStart, N.numberToken.posEnd);

    return res.success(out);
  }


  RTResult visitBinOpNode(BinOpNode N, Context Context) {
    RTResult res= new RTResult();
    Number Left=res.register(visit(N.left, Context));
    Number Right=res.register(visit(N.right, Context));



    if (res.Error!=null) {
      return res;
    }

    Number result=null;
    if (N.operatorToken.type.equals(Token.PLUS)) {
      result=Left.add(Right);
    } else if (N.operatorToken.type.equals(Token.MINUS)) {
      result=Left.sub(Right);
    } else if (N.operatorToken.type.equals(Token.MUL)) {
      result=Left.mult(Right);
    } else if (N.operatorToken.type.equals(Token.DIV)) {
      result=Left.div(Right);
    } else if (N.operatorToken.type.equals(Token.POWER)) {
      result=Left.power(Right);
    } else if (N.operatorToken.type.equals(Token.EE)) {
      result=Left.comparison_EE(Right);
    } else if (N.operatorToken.type.equals(Token.NE)) {
      result=Left.comparison_NE(Right);
    } else if (N.operatorToken.type.equals(Token.LT)) {
      result=Left.comparison_LT(Right);
    } else if (N.operatorToken.type.equals(Token.GT)) {
      result=Left.comparison_GT(Right);
    } else if (N.operatorToken.type.equals(Token.LTE)) {
      result=Left.comparison_LTE(Right);
    } else if (N.operatorToken.type.equals(Token.GTE)) {
      result=Left.comparison_GTE(Right);
    } else if (N.operatorToken.type.equals(Token.KEYWORD) &&N.operatorToken.name.equals("and")) {
      result=Left.AND(Right);
    } else if (N.operatorToken.type.equals(Token.KEYWORD) &&N.operatorToken.name.equals("or")) {
      result=Left.OR(Right);
    } else {
      return null;
    }
    if (result.Error!=null) {
      return res.failure(result.Error);
    }

    result.setPos(Left.posStart, Right.posEnd);
    return res.success(result);
  }

  RTResult visitUnaryOpNode(UnaryOpNode N, Context Context) {
    RTResult res= new RTResult();
    Number Number=res.register(visit(N.Node, Context));

    if (res.Error!=null) {
      return res;
    }

    if (N.operatorToken.type.equals(Token.MINUS)) {
      Number=Number.mult(new Number(-1));
    } else if ( N.operatorToken.type.equals(Token.KEYWORD) &&N.operatorToken.name.equals("not")) {
      Number=Number.notted();
    }

    Number.setPos(N.operatorToken.posStart, N.operatorToken.posEnd);
    return res.success(Number);
  }

  RTResult visitIfNode(ifNode N, Context Context) {
    RTResult res= new RTResult();


    for (if_Case condition : N.cases) {

      Number conditionValue=res.register(visit(condition.cond, Context));

      if (res.Error!=null) {
        return res;
      }

      if (conditionValue.isTrue()) {
        Number exprValue=res.register(visit(condition.expr, Context));

        if (res.Error!=null) {
          return res;
        }
        return res.success(exprValue);
      }
    }

    if (N.elseCase!=null) {
      Number elseValue=res.register(visit(N.elseCase, Context));

      if (res.Error!=null) {
        return res;
      }
      return res.success(elseValue);
    }



    return res.success(null);
  }



  RTResult visitforNode(forNode N, Context Context) {

    RTResult res= new RTResult();


    Number startValue=res.register(visit(N.startValue, Context));
    if (res.Error!=null) {
      return res;
    }

    Number endValue=res.register(visit(N.endValue, Context)); 
    if (res.Error!=null) {
      return res;
    }


    Number stepValue=new Number(1);
    if (N.stepValueNode!=null) {
      stepValue=res.register(visit(N.stepValueNode, Context)); 
      if (res.Error!=null) {
        return res;
      }
    }


    double i=startValue.value;

    if (stepValue.value>=0) {

      while (i<endValue.value) {
        Context.SymbolTable.set(N.varNameTok.name, new Number(i));
        i+=stepValue.value;

        res.register(visit(N.bodyNode, Context));
        if (res.Error!=null) {
          return res;
        }
      }
    } else {
      while (i>endValue.value) {
        Context.SymbolTable.set(N.varNameTok.name, new Number(i));
        i+=stepValue.value;

        res.register(visit(N.bodyNode, Context));
        if (res.Error!=null) {
          return res;
        }
      }
    }

    return res.success(null);
  }

  RTResult visitwhileNode(whileNode N, Context Context) {

    RTResult res= new RTResult();


    while (true) {
      Number condition=res.register(visit(N.conditionNode, Context));
      if (res.Error!=null) {
        return res;
      }
      if (!condition.isTrue()) {
        break;
      }

      res.register(visit(N.bodyNode, Context)); 
      if (res.Error!=null) {
        return res;
      }
    }

    return res.success(null);
  }
}




class Number {
  double value;
  Position posStart, posEnd;
  Error Error;
  Context Context;

  Number(double value) {
    this.value=value;
  }

  void setPos(Position posStart, Position posEnd) {
    this.posStart=posStart;
    this.posEnd=posEnd;
  }

  Number setContext(Context Context) {
    this.Context=Context;
    return this;
  }

  Number add(Number Other) {
    return new Number(value+Other.value).setContext(Context);
  }

  Number sub(Number Other) {
    return new Number(value-Other.value).setContext(Context);
  }

  Number mult(Number Other) {
    return new Number(value*Other.value).setContext(Context);
  }

  Number div(Number Other) {
    Number out=new  Number(value/Other.value).setContext(Context);
    if (Other.value==0) {
      out.Error=new RTError(Other.posStart, Other.posEnd, "Division by Zero", Context);
    }
    return out ;
  }

  Number power(Number Other) {
    Number out=new  Number(Math.pow(value, Other.value)).setContext(Context);
    if (Other.value==0 && value==0) {
      out.Error=new RTError(Other.posStart, Other.posEnd, "Zero Raised by Zero", Context);
    }
    return out ;
  }

  Number comparison_EE(Number Other) {
    Number out=new  Number(int(Math.round(value)==Math.round(Other.value))).setContext(Context);
    return out ;
  }

  Number comparison_NE(Number Other) {
    Number out=new  Number(int(Math.round(value)!=Math.round(Other.value))).setContext(Context);
    return out ;
  }

  Number comparison_LT(Number Other) {
    Number out=new  Number(int(Math.round(value)<Math.round(Other.value))).setContext(Context);
    return out ;
  }
  Number comparison_GT(Number Other) {
    Number out=new  Number(int(Math.round(value)>Math.round(Other.value))).setContext(Context);
    return out ;
  }
  Number comparison_LTE(Number Other) {
    Number out=new  Number(int(Math.round(value)<=Math.round(Other.value))).setContext(Context);
    return out ;
  }
  Number comparison_GTE(Number Other) {
    Number out=new  Number(int(Math.round(value)>=Math.round(Other.value))).setContext(Context);
    return out ;
  }

  Number AND(Number Other) {
    Number out=new  Number(int(boolean((int)Math.round(value))&&boolean((int)Math.round(Other.value)))).setContext(Context);
    return out ;
  }
  Number OR(Number Other) {
    Number out=new  Number(int(boolean((int)Math.round(value))||boolean((int)Math.round(Other.value)))).setContext(Context);
    return out ;
  }

  Number notted() {
    Number out=new  Number(int(boolean((int)Math.round(value))^true)).setContext(Context);
    return out ;
  }



  boolean isTrue() {
    return boolean((int)Math.round(value));
  }

  String toString() {
    return String.valueOf(value);
  }
}

class RTResult {
  Number value;
  Error Error;

  RTResult() {
  }

  Number register(RTResult PR) {
    if (PR.Error!=null) {
      this.Error=PR.Error;
    }
    return PR.value;
  }


  Number register(Number N) {
    return N;
  }

  RTResult success(Number N) {
    this.value=N;
    return this;
  }

  RTResult failure(Error E) {
    this.Error=E;
    println(E);
    return this;
  }
}
