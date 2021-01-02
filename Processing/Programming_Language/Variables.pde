class SetVariable implements ExpressionNodeVisitor {
  private String name;
  private double value;

  public SetVariable(String name, double value) {
    super();
    this.name = name;
    this.value = value;
  }

  public void visit(VariableExpressionNode node) {
    if (node.name.equals(name))
      node.setValue(value);
  }

  public void visit(ConstantExpressionNode node) {
  }
  public void visit(AdditionExpressionNode node) {
  }
  public void visit(MultiplicationExpressionNode node) {
  }
  public void visit(ExponentiationExpressionNode node) {
  }
  public void visit(FunctionExpressionNode node) {
  }
}



List<SetVariable> assign(String assignments) {
  Tokenizer tokenizer = new Tokenizer();
  tokenizer.tokenize(assignments);


  for (int i=0; i < tokenizer.tokens.size(); i++) {
    Token T = tokenizer.tokens.get(i);

    if (T.token==Token.VARIABLE) {
      tokenizer.tokens.pop();
      tokenizer.tokens.pop();

      ExpressionNode EN=parser.parse(tokenizer.tokens);
      for (SetVariable V : Variables) {
        EN.accept(V);
      }


      Variables.add(new SetVariable(T.sequence, EN.getValue()));
      i+=2;
    }
  }
  return Variables;
}
