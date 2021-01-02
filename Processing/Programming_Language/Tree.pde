public interface ExpressionNode {
  static final int VARIABLE_NODE = 1;
  static final int CONSTANT_NODE = 2;
  static final int ADDITION_NODE = 3;
  static final int MULTIPLICATION_NODE = 4;
  static final int EXPONENTIATION_NODE = 5;
  static final int FUNCTION_NODE = 6;
  int getType();
  double getValue();
  void accept(ExpressionNodeVisitor visitor);
}

public interface ExpressionNodeVisitor
{
  public void visit(VariableExpressionNode node);
  public void visit(ConstantExpressionNode node);
  public void visit(AdditionExpressionNode node);
  public void visit(MultiplicationExpressionNode node);
  public void visit(ExponentiationExpressionNode node);
  public void visit(FunctionExpressionNode node);
}


class ConstantExpressionNode implements ExpressionNode {
  double value;

  ConstantExpressionNode(double value) {
    this.value = value;
  }

  ConstantExpressionNode(String value) {
    this.value = Double.valueOf(value);
  }

  double getValue() {
    return value;
  }

  int getType() {
    return ExpressionNode.CONSTANT_NODE;
  }

  void accept(ExpressionNodeVisitor visitor) {
    visitor.visit(this);
  }
}


class VariableExpressionNode implements ExpressionNode {
  private String name;
  private double value;
  private boolean valueSet;

  public VariableExpressionNode(String name) {
    this.name = name;
    valueSet = false;
  }

  public int getType() {
    return ExpressionNode.VARIABLE_NODE;
  }

  public void setValue(double value) {
    this.value = value;
    this.valueSet = true;
  }

  public double getValue() {
    if (valueSet)
      return value;
    else
      throw new RuntimeException("Variable '" 
        + name + "' was not initialized.");
  }

  void accept(ExpressionNodeVisitor visitor) {
    visitor.visit(this);
  }
}

class Term {
  public boolean positive;
  public ExpressionNode expression;

  public Term(boolean positive, ExpressionNode expression) {
    super();
    this.positive = positive;
    this.expression = expression;
  }
}

abstract class SequenceExpressionNode
  implements ExpressionNode {

  protected LinkedList<Term> terms;

  public SequenceExpressionNode() {
    this.terms = new LinkedList<Term>();
  }

  public SequenceExpressionNode(ExpressionNode a, boolean positive) {
    this.terms = new LinkedList<Term>();
    this.terms.add(new Term(positive, a));
  }

  public void add(ExpressionNode a, boolean positive) {
    this.terms.add(new Term(positive, a));
  }
}

class AdditionExpressionNode
  extends SequenceExpressionNode {

  public AdditionExpressionNode() {
    super();
  }

  public AdditionExpressionNode(ExpressionNode a, 
    boolean positive) {
    super(a, positive);
  }

  public int getType() {
    return ExpressionNode.ADDITION_NODE;
  }

  public double getValue() {
    double sum = 0.0;
    for (Term t : terms) {
      if (t.positive)
        sum += t.expression.getValue();
      else
        sum -= t.expression.getValue();
    }
    return sum;
  }

  void accept(ExpressionNodeVisitor visitor) {
    visitor.visit(this);
    for (Term t : terms)
      t.expression.accept(visitor);
  }
}

class MultiplicationExpressionNode
  extends SequenceExpressionNode {

  public MultiplicationExpressionNode() {
    super();
  }

  public MultiplicationExpressionNode(ExpressionNode a, 
    boolean positive) {
    super(a, positive);
  }

  public int getType() {
    return ExpressionNode.MULTIPLICATION_NODE;
  }

  public double getValue() {
    double prod = 1.0;
    for (Term t : terms) {
      if (t.positive)
        prod *= t.expression.getValue();
      else
        prod /= t.expression.getValue();
    }
    return prod;
  }

  void accept(ExpressionNodeVisitor visitor) {
    visitor.visit(this);
    for (Term t : terms)
      t.expression.accept(visitor);
  }
}

class ExponentiationExpressionNode
  implements ExpressionNode {

  private ExpressionNode base;
  private ExpressionNode exponent;

  public ExponentiationExpressionNode(ExpressionNode base, 
    ExpressionNode exponent) {
    this.base = base;
    this.exponent = exponent;
  }

  public int getType() {
    return ExpressionNode.EXPONENTIATION_NODE;
  }

  public double getValue() {
    return Math.pow(base.getValue(), exponent.getValue());
  }

  void accept(ExpressionNodeVisitor visitor) {
    visitor.visit(this);
    base.accept(visitor);
    exponent.accept(visitor);
  }
}

class FunctionExpressionNode
  implements ExpressionNode {
  public static final int SIN = 1;
  public static final int COS = 2;
  public static final int TAN = 3;

  public static final int ASIN = 4;
  public static final int ACOS = 5;
  public static final int ATAN = 6;

  public static final int SQRT = 7;
  public static final int EXP = 8;

  public static final int LN = 9;
  public static final int LOG = 10;
  public static final int LOG2 = 11;

  public static final int PRINT = 12;
  public static final int REPEAT = 13;

  private int function;
  private ExpressionNode argument;

  public FunctionExpressionNode(int function, 
    ExpressionNode argument) {
    super();
    this.function = function;
    this.argument = argument;
  }

  public int getType() {
    return ExpressionNode.FUNCTION_NODE;
  }

  public double getValue() {
    switch (function) {
    case SIN:  
      return Math.sin(argument.getValue());
    case COS:  
      return Math.cos(argument.getValue());
    case TAN:  
      return Math.tan(argument.getValue());
    case ASIN: 
      return Math.asin(argument.getValue());
    case ACOS: 
      return Math.acos(argument.getValue());
    case ATAN: 
      return Math.atan(argument.getValue());
    case SQRT: 
      return Math.sqrt(argument.getValue());
    case EXP:  
      return Math.exp(argument.getValue());
    case LN:   
      return Math.log(argument.getValue());
    case LOG:  
      return Math.log(argument.getValue())
        * 0.43429448190325182765;
    case LOG2: 
      return Math.log(argument.getValue())
        * 1.442695040888963407360;
    case PRINT:   

      println(argument.getValue());
      return argument.getValue();

    case REPEAT:   
      for (int i=0; i < 10; i++) {
        println(argument.getValue());
      }

      return argument.getValue();
    }
    throw new RuntimeException("Invalid function id "+function+"!");
  }

  void accept(ExpressionNodeVisitor visitor) {
    visitor.visit(this);
    argument.accept(visitor);
  }
}




int stringToFunction(String str) {
  if (str.equals("sin")) return FunctionExpressionNode.SIN;
  if (str.equals("cos")) return FunctionExpressionNode.COS;
  if (str.equals("tan")) return FunctionExpressionNode.TAN;

  if (str.equals("asin")) return FunctionExpressionNode.ASIN;
  if (str.equals("acos")) return FunctionExpressionNode.ACOS;
  if (str.equals("atan")) return FunctionExpressionNode.ATAN;

  if (str.equals("sqrt")) return FunctionExpressionNode.SQRT;
  if (str.equals("exp")) return FunctionExpressionNode.EXP;

  if (str.equals("ln")) return FunctionExpressionNode.LN;
  if (str.equals("log"))return FunctionExpressionNode.LOG;
  if (str.equals("log2")) return FunctionExpressionNode.LOG2;
  if (str.equals("print")) return FunctionExpressionNode.PRINT;
  if (str.equals("repeat")) return FunctionExpressionNode.REPEAT;


  throw new RuntimeException("Unexpected Function "+str+" found!");
}

String getAllFunctions() {
  return "sin|cos|tan|asin|acos|atan|sqrt|exp|ln|log|log2";
}
