
Parser parser = new Parser();

LinkedList<SetVariable> Variables=new LinkedList<SetVariable>();
void setup() {
  size(400, 400);





  LinkedList<ExpressionNode> Expressions=new LinkedList<ExpressionNode>();




  String[] lines = loadStrings("code.txt");
  for (int i = 0; i < lines.length; i++) {
    if (!lines[i].equals("")) {
      if (lines[i].contains("=")) {

        Variables.addAll(assign(lines[i]));
      } else {

        String expression=lines[i];
        Tokenizer tokenizer = new Tokenizer();
        tokenizer.tokenize(expression);


        Parser parser = new Parser();
        ExpressionNode EN=parser.parse(tokenizer.tokens);
        for (SetVariable V : Variables) {
          EN.accept(V);
        }
        Expressions.add(EN);
      }
    }
  }




  for (ExpressionNode E : Expressions) {
    E.getValue();
  }




  exit();
}


void draw() {
}
