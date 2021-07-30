import sys

from colorama.ansi import Fore

from lambdaConstants import Constants
from lambdaInterpreter import Interpreter
from lambdaLexer import Lexer
from lambdaParser import Parser
from utility import printColor, timeIt
from visualize import visualizeAST

sys.setrecursionlimit(2500)


# Boolean
inputString = "((AND TRUE) TRUE)"
inputString = "((XOR FALSE) TRUE)"
inputString = "(NOT (NOT FALSE))"
inputString = "(((C XOR) FALSE) FALSE)"

# Logic
inputString = "(((IFTHENELSE FALSE) A) B)"

# Arithmetic
inputString = "(SUCC (SUCC (SUCC FOUR)))"
inputString = "((MULT TWO) FOUR)"
inputString = "(PRED (PRED TEN))"
inputString = "((EXP TWO) THREE)"
inputString = "((MINUS EIGHT) THREE)"
inputString = "((DIV SIX) TWO)"

# Boolean - Arithmetic
inputString = "(ISZERO ZERO)"
inputString = "((LEQ THREE) THREE)"
inputString = "((LEQ TWO) THREE)"
inputString = "((LEQ TEN) TWO)"
inputString = "((EQ TWO) ONE)"

# List
inputString = "(FIRST_EL ((PAIR a) b))"
inputString = "(SECOND_EL ((PAIR a) b))"
inputString = "(head ((cons a) ((cons b) c)))"
inputString = "(head (tail ((cons a) ((cons b) c))))"
inputString = "(head (tail (tail ((cons a) ((cons b) ((cons c) d))))))"
inputString = "(FIRST_EL ((PAIR ONE) THREE))"

# Recursion
inputString = "(FACT THREE)"
inputString = "(FIB THREE)"
inputString = "(FACT THREE)"
inputString = "(FIB SIX)"

# Random
inputString = "(λf.((PLUS f) TWO) ONE) "
inputString = "(λf.(f THREE) λx.((MULT x) x)) "
inputString = "((λf.f λx.((MULT x) x)) THREE) "
inputString = "(λx.((MULT x) x) THREE) "
#inputString = "((DIV (FIB SIX)) (FACT FOUR)))"
#inputString = "((DIV (FACT FOUR)) (FIB SIX))"


@timeIt
def evaluate(prettyString: str, debug=False):
    lambdaConstants = Constants()

    if(debug):
        printColor("\nUserInput:", Fore.YELLOW)
        printColor(prettyString, '\033[1m'+Fore.GREEN)

    inputString = lambdaConstants.evaluateString(prettyString)

    L = Lexer()
    L.analyze(inputString, debug)

    P = Parser(L)
    AST = P.parse()
    if(debug):
        visualizeAST(AST, "FULL", prettyString)

    I = Interpreter()
    reducedAST = I.reduce(AST, debug)
    if(debug):
        visualizeAST(reducedAST, "REDUCED", prettyString)

    equivalentExpression = lambdaConstants.findInDict(str(reducedAST))

    if equivalentExpression:
        if(debug):
            printColor("Input:", Fore.YELLOW)
            printColor(prettyString, '\033[1m'+Fore.GREEN)
            printColor("evaluated to:", Fore.YELLOW)
            printColor(equivalentExpression, '\033[1m'+Fore.GREEN, end="\n\n")

            with open("Visuals/history.txt", mode="a") as f:
                f.write(
                    f"{prettyString.replace('λ','#')}  -->  {equivalentExpression}\n")

        return equivalentExpression

    return reducedAST


if __name__ == '__main__':

    res = evaluate(inputString, debug=True)
