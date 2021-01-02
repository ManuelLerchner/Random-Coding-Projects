
import java.util.List;

class Parser {
  LinkedList<Token> tokens;
  Token lookahead;

  ExpressionNode parse(LinkedList<Token> tokens) {
    this.tokens = (LinkedList<Token>)tokens.clone();
    lookahead = this.tokens.getFirst();


    ExpressionNode expr = expression();



    if (lookahead.token != Token.EPSILON)
      throw new RuntimeException("Unexpected symbol %s found"+ lookahead.sequence);

    return expr;
  }

  void nextToken() {
    tokens.pop();
    // at the end of input we return an epsilon token
    if (tokens.isEmpty())
      lookahead = new Token(Token.EPSILON, "");
    else
      lookahead = tokens.getFirst();
  }


  ExpressionNode expression() {
    // expression -> signed_term sum_op


    ExpressionNode expr = signedTerm();


    return sumOp(expr);
  }

  ExpressionNode sumOp(ExpressionNode expr) {
    // sum_op -> PLUSMINUS term sum_op
    if (lookahead.token == Token.PLUSMINUS) {
      AdditionExpressionNode sum;
      if (expr.getType() == ExpressionNode.ADDITION_NODE)
        sum = (AdditionExpressionNode)expr;
      else
        sum = new AdditionExpressionNode(expr, true);

      boolean positive = lookahead.sequence.equals("+");
      nextToken();
      ExpressionNode t = term();
      sum.add(t, positive);

      return sumOp(sum);
    }

    // sum_op -> EPSILON
    return expr;
  }

  ExpressionNode signedTerm() {
    // signed_term -> PLUSMINUS term
    if (lookahead.token == Token.PLUSMINUS) {
      boolean positive = lookahead.sequence.equals("+");
      nextToken();
      ExpressionNode t = term();
      if (positive)
        return t;
      else
        return new AdditionExpressionNode(t, false);
    }

    // signed_term -> term
    return term();
  }


  ExpressionNode term() {
    // term -> factor term_op
    ExpressionNode f = factor();
    return termOp(f);
  }

  ExpressionNode termOp(ExpressionNode expression) {
    // term_op -> MULTDIV factor term_op
    if (lookahead.token == Token.MULTDIV) {
      MultiplicationExpressionNode prod;

      if (expression.getType() == ExpressionNode.MULTIPLICATION_NODE)
        prod = (MultiplicationExpressionNode)expression;
      else
        prod = new MultiplicationExpressionNode(expression, true);

      boolean positive = lookahead.sequence.equals("*");
      nextToken();
      ExpressionNode f = signedFactor();
      prod.add(f, positive);

      return termOp(prod);
    }

    // term_op -> EPSILON
    return expression;
  }


  ExpressionNode signedFactor()
  {
    // signed_factor -> PLUSMINUS factor
    if (lookahead.token == Token.PLUSMINUS)
    {
      boolean positive = lookahead.sequence.equals("+");
      nextToken();
      ExpressionNode t = factor();
      if (positive)
        return t;
      else
        return new AdditionExpressionNode(t, false);
    }

    // signed_factor -> factor
    return factor();
  }


  ExpressionNode factor() {
    // factor -> argument factor_op
    ExpressionNode a = argument();
    return factorOp(a);
  }

  ExpressionNode factorOp(ExpressionNode expression) {
    // factor_op -> RAISED factor
    if (lookahead.token == Token.RAISED) {
      nextToken();
      ExpressionNode exponent = signedFactor();

      return new ExponentiationExpressionNode(expression, exponent);
    }

    // factor_op -> EPSILON
    return expression;
  }

  ExpressionNode argument()
  {
    // argument -> FUNCTION argument
    if (lookahead.token == Token.FUNCTION)
    {
      int function = stringToFunction(lookahead.sequence);
      nextToken();
      ExpressionNode expr = argument();
      return new FunctionExpressionNode(function, expr);
    }
    // argument -> OPEN_BRACKET sum CLOSE_BRACKET
    else if (lookahead.token == Token.OPEN_BRACKET)
    {
   
      nextToken();
      ExpressionNode expr = expression();
      if (lookahead.token != Token.CLOSE_BRACKET)
        throw new RuntimeException("Closing brackets expected"+ lookahead);
      nextToken();
      return expr;
    }

    // argument -> value
    return value();
  }

  ExpressionNode value() {
    // argument -> NUMBER
    if (lookahead.token == Token.NUMBER) {
      ExpressionNode expr = new ConstantExpressionNode(lookahead.sequence);
      nextToken();
      return expr;
    }


    // argument -> VARIABLE
    if (lookahead.token == Token.VARIABLE) {
      ExpressionNode expr = new VariableExpressionNode(lookahead.sequence);
      nextToken();
      return expr;
    }

    if (lookahead.token == Token.EPSILON)
      throw new RuntimeException("Unexpected end of input");
    else
      throw new RuntimeException("Unexpected symbol %s found"+ lookahead.sequence);
  }
}
