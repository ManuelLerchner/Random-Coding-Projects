from Nodes import *
from Token import Token


class Parser:

    def __init__(self, Token):
        self.Token = Token
        self.count = -1
        self.currToken = None

        self.advance()

    def advance(self):
        self.count += 1
        if self.count < len(self.Token):
            self.currToken = self.Token[self.count]

    def eval(self):
        out = self.makeExpression(self.currToken)
        return out

    def makeExpression(self, tok):
        Term = self.repeat(self.makeTerm, [Token.Plus, Token.Minus])
        return Term

    def makeTerm(self, tok):
        Factor = self.repeat(self.makeFactor, [Token.Mult, Token.Div])
        return Factor

    def makeFactor(self, tok):
        if tok.type in [Token.Plus, Token.Minus]:
            Op = tok
            self.advance()
            Atom = self.makeFactor(self.currToken)
            return UnOpNode(Op, Atom)
        return self.makeAtom(self.currToken)

    def makeAtom(self, tok):
        N = None

        if(tok.type == Token.Number):
            N = NumberNode(tok.value)
            self.advance()
        if(tok.type == Token.Var):
            N = VarNode(tok.value)
            self.advance()
        elif(tok.type == Token.LPar):
            self.advance()
            N = self.makeExpression(tok.value)
            self.advance()
        return N

    def repeat(self, Function, allowedTokens):
        Left = Function(self.currToken)
        Right = None
        while (self.currToken.type in allowedTokens):
            operator = self.currToken
            self.advance()
            Right = Function(operator)
            Left = BinOpNode(Left, operator, Right)

        return Left
