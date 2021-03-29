from Token import Token


class Node:

    def __init__(self):
        pass

    def __repr__(self):
        pass


class BinOpNode(Node):

    def __init__(self, Left, op, Right):
        self.Left = Left
        self.Right = Right
        self.op = op

    def __repr__(self):
        return "("+str(self.Left) + " " + str(self.op) + " " + str(self.Right)+")"

    def simplyfy(self):

        LFT = self.Left.simplyfy()
        RGT = self.Right.simplyfy()

        typeLeft = type(LFT).__name__
        typeRight = type(RGT).__name__

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

        return BinOpNode(LFT, self.op, RGT)


class UnOpNode(Node):

    def __init__(self, op, Right):
        self.op = op
        self.Right = Right

    def __repr__(self):
        return str(self.op) + " " + str(self.Right)

    def simplyfy(self):
        if(self.op.type == Token.Plus):
            return NumberNode(self.Right.val)
        elif(self.op.type == Token.Minus):
            return NumberNode(-self.Right.val)


class NumberNode(Node):
    def __init__(self, val):
        self.val = val

    def __repr__(self):
        return str(self.val)

    def simplyfy(self):
        return self


class VarNode(Node):

    def __init__(self, var):
        self.var = var

    def __repr__(self):
        return str(self.var)

    def simplyfy(self):
        return self
