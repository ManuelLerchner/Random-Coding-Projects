from Lexer import Lexer
from Parser import Parser

expr = "2*x^2+3*x+5"


Lexer = Lexer(expr)
Lexer.evaluate()

Parser = Parser(Lexer.Tokens)

out = Parser.eval()

print("out")
print(out)

print("\nreduced")
reduced = out.simplify()
print(reduced)

print("\nintegration")
integrate = reduced.integrate("x")
print(integrate)


print("\nresult")
result = integrate.simplify()
print(result)
