from colorama.ansi import Fore

from lambdaConstants import Constants
from lambdaInterpreter import Interpreter
from lambdaLexer import Lexer
from lambdaParser import Parser
from utility import printColor, timeIt
from visualize import visualizeAST


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

# Boolean - Arithmetic
inputString = "(ISZERO ZERO)"
inputString = "((LEQ THREE) THREE)"
inputString = "((LEQ TWO) THREE)"
inputString = "((LEQ TEN) TWO)"

# List
inputString = "(FIRST_EL ((PAIR a) b))"
inputString = "(SECOND_EL ((PAIR a) b))"
inputString = "(head ((cons a) ((cons b) c)))"
inputString = "(head (tail ((cons a) ((cons b) c))))"
inputString = "(head (tail (tail ((cons a) ((cons b) ((cons c) d))))))"
inputString = "(FIRST_EL ((PAIR 5) j))"

# Recursion
#inputString = "(FACT TWO)"
#inputString = "(FIB TWO)"
#inputString = "(FACT FOUR)"
#inputString = "(FIB FIVE)"


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
        visualizeAST(AST, "FULL")

    I = Interpreter()
    reducedAST = I.reduce(AST, debug)
    if(debug):
        visualizeAST(reducedAST, "REDUCED")

    equivalentExpression = lambdaConstants.findInDict(str(reducedAST))

    if equivalentExpression:
        if(debug):
            printColor("This is equivalent to:", Fore.YELLOW)
            printColor(equivalentExpression, '\033[1m'+Fore.GREEN, end="\n\n")
        return equivalentExpression

    return reducedAST


if __name__ == '__main__':
    res = evaluate(inputString, debug=True)
