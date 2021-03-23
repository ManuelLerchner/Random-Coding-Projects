from Lexer import Lexer
expr = "(x^2+3.3)/y"


Lexer = Lexer(expr)

Lexer.evaluate()
