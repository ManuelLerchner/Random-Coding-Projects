from lexer import Lexer
from lambdaParser import Parser

import visualize


inp = "(((z λx.λy.z) (x y)) (x y))"
inp = "λz.λy.((y λx.x) λx.(z x))"

print("Trying to evaluate input:", inp)


L = Lexer(inp)
P = Parser(L)

Node = P.parse()

print("Parsed following result: ", Node)


visualize.visualize(Node)
