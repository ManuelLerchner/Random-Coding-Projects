from Token import Token
import math


class Node:

    def __init__(self):
        pass

    def __repr__(self):
        pass


class UnOpNode(Node):

    def __init__(self, op, Right):
        self.op = op
        self.Right = Right

    def __repr__(self):
        return str(self.op) + " " + str(self.Right)

    def simplify(self):
        if(self.op.type == Token.Plus):
            return NumberNode(self.Right.val)
        elif(self.op.type == Token.Minus):
            return NumberNode(-self.Right.val)


class NumberNode(Node):
    def __init__(self, val):
        self.val = val

    def __repr__(self):
        return str(self.val)

    def simplify(self):
        return self

    def integrate(self, variable):

        out = BinOpNode(NumberNode(self.val), Token(Token.Mult),
                        VarNode(variable))
        return out


class VarNode(Node):

    def __init__(self, var):
        self.var = var

    def __repr__(self):
        return str(self.var)

    def simplify(self):
        return self

    def integrate(self, variable):

        if self.var == variable:

            out = BinOpNode(VarNode(variable), Token(Token.Pow),
                            NumberNode(2))
            out = BinOpNode(out, Token(Token.Div), NumberNode(2))
            return out

        return self


class BinOpNode(Node):

    def __init__(self, Left, op, Right):
        self.Left = Left
        self.Right = Right
        self.op = op

    def __repr__(self):
        return "("+str(self.Left) + " " + str(self.op) + " " + str(self.Right)+")"

    def simplify(self):

        LFT = self.Left.simplify()
        RGT = self.Right.simplify()

        typeLeft = type(LFT).__name__
        typeRight = type(RGT).__name__

        # swap number to left
        if type(RGT).__name__ == "NumberNode" and self.op.type in [Token.Plus, Token.Mult]:
            temp = RGT
            RGT = LFT
            LFT = temp

        typeLeft = type(LFT).__name__
        typeRight = type(RGT).__name__

        # Eval NumberNodes
        if(typeLeft == typeRight == "NumberNode"):
            if(self.op.type == Token.Plus):
                out = NumberNode(LFT.val+RGT.val)
                return out
            if(self.op.type == Token.Div):
                out = NumberNode(LFT.val/RGT.val)
                return out
            if(self.op.type == Token.Mult):
                out = NumberNode(LFT.val*RGT.val)
                return out
            if(self.op.type == Token.Minus):
                out = NumberNode(LFT.val-RGT.val)
                return out

        # Remove Base Nodes

        if typeLeft == typeRight == "VarNode":
            if LFT.var == RGT.var:
                if self.op.type in [Token.Div]:
                    return NumberNode(1)

                if self.op.type in [Token.Mult]:
                    return BinOpNode(LFT, Token(Token.Pow), NumberNode(2))

                if self.op.type in [Token.Plus]:
                    return BinOpNode(NumberNode(2), Token(Token.Mult), LFT)

                if self.op.type in [Token.Minus]:
                    return NumberNode(0)

        if typeLeft == "NumberNode":
            if LFT.val == 0:
                if self.op.type in [Token.Plus, Token.Minus]:
                    return RGT
                if self.op.type in [Token.Mult, Token.Div]:
                    return NumberNode(0)

            if LFT.val == 1:
                if self.op.type == Token.Mult:
                    return RGT

        if typeRight == "NumberNode":
            if RGT.val == 0:
                if self.op.type in [Token.Plus, Token.Minus]:
                    return LFT
                if self.op.type == Token.Mult:
                    return NumberNode(0)

            if RGT.val == 1:
                if self.op.type == Token.Mult or self.op.type == Token.Div:
                    return LFT

        # Eval Nested NumberNodes
        if(self.op.type in [Token.Plus, Token.Minus]):
            if typeLeft == "BinOpNode" and typeRight == "NumberNode":
                LFT.Right = BinOpNode(LFT.Right, self.op, RGT)
                LFT = LFT.simplify()
                return LFT

            if typeRight == "BinOpNode" and typeLeft == "NumberNode":
                if RGT.op.type in [Token.Plus, Token.Minus]:
                    RGT.Left = BinOpNode(LFT, self.op, RGT.Left)
                    RGT = RGT.simplify()
                    return RGT

        if(self.op.type in [Token.Div, Token.Mult]):
            if typeLeft == "BinOpNode":
                if LFT.op.type in [Token.Mult, Token.Div]:

                    typeLeft_Right = type(LFT.Right).__name__
                    if LFT.op.type != Token.Div:
                        if typeLeft_Right == typeRight == "NumberNode":
                            LFT.Left = BinOpNode(LFT.Left, self.op, RGT)
                            LFT = LFT.simplify()
                            return LFT

                        if typeLeft_Right == typeRight == "VarNode":
                            LFT.Right = BinOpNode(LFT.Right, self.op, RGT)
                            LFT = LFT.simplify()
                            return LFT

                    if LFT.op.type == Token.Div:

                        if type(LFT.Right).__name__ == "NumberNode":
                            LFT.Right = BinOpNode(LFT.Right, self.op, RGT)
                            LFT = LFT.simplify()
                            return LFT

            if typeRight == "BinOpNode":
                if RGT.op.type in [Token.Mult, Token.Div]:

                    typeRight_Right = type(RGT.Right).__name__
                    if typeRight_Right == typeLeft == "NumberNode":
                        RGT.Left = BinOpNode(RGT.Left, self.op, LFT)
                        RGT = RGT.simplify()
                        return RGT

                    if typeRight_Right == typeLeft == "VarNode":
                        RGT.Right = BinOpNode(RGT.Right, self.op, LFT)
                        RGT = RGT.simplify()
                        return RGT

        if self.op.type == Token.Div:
            if typeRight == "VarNode" and typeLeft == "NumberNode":

                out = BinOpNode(LFT, Token(Token.Mult),
                                BinOpNode(RGT, Token(Token.Pow), NumberNode(-1)))
                out = out.simplify()
                return out

        return BinOpNode(LFT, self.op, RGT)

    def integrate(self, variable):
        typeleft = type(self.Left).__name__
        typeright = type(self.Right).__name__

        if(self.op.type in [Token.Plus, Token.Minus]):
            out = BinOpNode(self.Left.integrate(variable), self.op,
                            self.Right.integrate(variable))
            return out

        if(self.op.type == Token.Mult):

            if typeleft == "NumberNode":
                out = BinOpNode(self.Left, Token(Token.Mult),
                                self.Right.integrate(variable))
                return out

            if typeleft == "VarNode":
                out = BinOpNode(self.Left.integrate(variable), Token(Token.Mult),
                                self.Right.integrate(variable))

                return out

        if(self.op.type == Token.Pow):
            if typeleft == "NumberNode" and typeright == "VarNode":
                out = BinOpNode(self, Token(Token.Div),
                                NumberNode(math.log(self.Left.val)))

                return out

            if typeleft == "VarNode" and typeright == "NumberNode":

                out = BinOpNode(self.Left, Token(Token.Pow),
                                NumberNode(self.Right.val+1))

                out = BinOpNode(out, Token(Token.Div),
                                NumberNode(self.Right.val+1))

                return out
