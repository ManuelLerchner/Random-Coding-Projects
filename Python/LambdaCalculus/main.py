from lambdaConstants import Constants
from lambdaInterpreter import Interpreter
from lambdaLexer import Lexer
from lambdaParser import Parser
from visualize import visualizeAST


Const = Constants.getAll()

TRUE = Const["TRUE"]
FALSE = Const["FALSE"]

AND = Const["AND"]
OR = Const["OR"]
XOR = Const["XOR"]
NOT = Const["NOT"]

ZERO = Const["ZERO"]
ONE = Const["ONE"]
TWO = Const["TWO"]
SUCC = Const["SUCC"]

I = Const["I"]
K = Const["K"]
KI = Const["KI"]
C = Const["C"]


inputString = f'(({AND} {FALSE}) {TRUE})'
inputString = f'({NOT} {TRUE})'
inputString = f'(({XOR} {TRUE}) {TRUE})'
inputString = f'((({C} {XOR}) {TRUE}) {FALSE})'
#inputString = f'{ONE}'


def evaluate(inputString: str):
    L = Lexer()
    L.analyze(inputString)

    P = Parser(L)
    AST = P.parse()
    visualizeAST(AST, "FULL")

    I = Interpreter()
    reducedAST = I.reduce(AST)
    visualizeAST(reducedAST, "REDUCED")

    return reducedAST


evaluate(inputString)
