from Lexer import Lexer
from Parser import Parser

expr = "1/2*x"


Lexer = Lexer(expr)

Lexer.evaluate()

Parser = Parser(Lexer.Tokens)

out = Parser.eval()


reduced = out.simplyfy()

print(reduced)
