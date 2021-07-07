from lambdaLexer import Lexer
from lambdaToken import Token
from nodes import ApplicationNode, FunctionNode, VarNode


class Parser:

    def __init__(self, Lexer: Lexer):
        self.Lexer = Lexer

    def parse(self):
        """
        Parses given Lexer-Tokens into AST

        """

        N = self.expression()

        if not self.Lexer.finished():
            self.Lexer.throwError(
                f"Parser finished", self.Lexer.idx, "Expression")

        return N

    def expression(self):
        """
        Creates Expression

        <λexp>: :=  |<var> 
                    |<LAMBDA > <var> <DOT> <λexp>
                    |<LPAR> <λexp> <SPACE> <λexp> <RPAR>
        """

        # Skip Leading Spaces
        while self.Lexer.peekToken(Token.SPACE):
            self.Lexer.skipToken(Token.SPACE, "Expression")

        if self.Lexer.peekToken(Token.VAR):
            return self.variable()

        elif self.Lexer.peekToken(Token.LAMBDA):
            return self.function()

        elif self.Lexer.peekToken(Token.LPAR):
            return self.application()

    def variable(self):
        """
        Creates VarNode

                <var>
        """
        tok = self.Lexer.nextToken(Token.VAR, "Variable")
        return VarNode(tok)

    def function(self):
        """
        Creates FunctionNode

                λ<var>.<exp>
        """

        self.Lexer.skipToken(Token.LAMBDA, "Function")

        var = self.variable()

        self.Lexer.skipToken(Token.DOT, "Function")

        exp = self.expression()

        return FunctionNode(var, exp)

    def application(self):
        """
        Creates ApplicationNode

                (<λexp> <λexp>)
        """

        self.Lexer.skipToken(Token.LPAR, "Application")

        A = self.expression()

        self.Lexer.skipToken(Token.SPACE, "Application")

        B = self.expression()

        self.Lexer.skipToken(Token.RPAR, "Application")

        return ApplicationNode(A, B)
