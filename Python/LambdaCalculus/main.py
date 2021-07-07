from lambdaInterpreter import Interpreter
from lambdaLexer import Lexer
from lambdaParser import Parser
from lambdaToken import Token
from nodes import VarNode
from visualize import visualizeAST

inputString = "(((z λx.λy.z) (x y)) (x y))"
inputString = "(λz.λy.((y λx.x) λx.(z x)) k)"
inputString = "(((λx.λy.(y x) λt.t) λk.k) o)"
inputString = "(λx.(λu.λy.x (λv.v λy.y)) (λz.λx.(z z) ((v x) λu.(u v))))"

# SWITCH RETURN FIRST ==> RETURN Second
inputString = "(((λf.λa.λb.((f b) a) λi.λj.i) 1) 2)"
# Logical AND
inputString = "((λp.λq.((p q) λu.λo.o) λx.λy.y) λk.λl.l)"

#inputString = "((λx.λy.x λx.λl.x) x)"

"""!!!Todo Fix  Variable Colission"""
#AST.replace(VarNode(Token(Token.VAR, "x")), VarNode(Token(Token.VAR, "l")))

if __name__ == "__main__":

    print("Trying to evaluate input:", inputString)

    # lexical analyze String
    L = Lexer()
    L.analyze(inputString)

    # Parse
    P = Parser(L)
    AST = P.parse()
    visualizeAST(AST, "FULL")

    print("Trying to interpret AST: ", AST)

    # Reduce
    I = Interpreter()
    reducedAST = I.reduce(AST)
    visualizeAST(reducedAST, "REDUCED")

    print("Got:", reducedAST)
