SymbolTable globalSymbolTable=new SymbolTable();

void setup() {
  size(400, 800);
  textAlign(LEFT, TOP);
  globalSymbolTable.set("true", new Number(1));
  globalSymbolTable.set("false", new Number(0));
}

void draw() {
  background(31);
  fill(255);
  for (int i=0; i < allCode.size(); i++) {
    LogEntry S = allCode.get(i);
    fill(255);
    text(">", textSpreading, textSpreading*(i+1)); 
    fill(S.col);
    text(S.name, textSpreading+textWidth(">"), textSpreading*(i+1));
  }

  fill(255);
  text(">", textSpreading, textSpreading*((1+allCode.size()))); 
  text(displayInput, textSpreading+textWidth(">"), textSpreading*(1+allCode.size()));
 
}




Number run(String fn, String text) {

  Lexer Lexer=new Lexer(fn, text); 
  LinkedList<Token> tokens=Lexer.makeToken(); 


  //  printToken(tokens);
  Parser Parser=new Parser(tokens);
  ParseResult AbstractSyntaxTree=Parser.parse();




  if (AbstractSyntaxTree.Error!=null) {
    return null;
  }


  Interpreter Interpreter=new Interpreter();
  Context Context=new Context("<program>", null, null);
  Context.SymbolTable=globalSymbolTable;
  RTResult result=Interpreter.visit(AbstractSyntaxTree.Node, Context);


  return result.value;
}



void  printToken(LinkedList<Token> in) {
  for (Token T : in) {
    println(T);
  }
}
