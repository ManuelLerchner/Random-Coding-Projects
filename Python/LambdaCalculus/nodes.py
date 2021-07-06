from abc import ABC, abstractmethod
from lambdaToken import Token


class Node(ABC):

    @abstractmethod
    def __init__(self):
        pass

    @abstractmethod
    def __repr__(self):
        """
        PrettyPrints current Node
        """
        pass

    @abstractmethod
    def debugPrint(self):
        """
        DebugPrints current Node
        """
        pass

    @abstractmethod
    def plot(self, idx, dot):
        """
        Plots current Node into GraphViz Diagram
        """
        pass


class VarNode(Node):

    def __init__(self, var: Token):
        self.var = var

    def __repr__(self):
        return str(self.var.value)

    def debugPrint(self):
        return "[VAR: "+str(self.var.value)+"]"

    def plot(self, idx, dot):
        dot.node(f"{idx}", "VAR "+str(self))


class FunctionNode(Node):

    def __init__(self, var: Node, exp: Node):
        self.var = var
        self.exp = exp

    def __repr__(self):
        return "λ"+str(self.var)+"."+str(self.exp)

    def debugPrint(self):
        return "{FUNCTION: λ"+str(self.var.debugPrint())+"."+str(self.exp.debugPrint())+"}"

    def plot(self, idx, dot):
        dot.node(f"{idx}", "FUN "+str(self))

        dot.edge(f"{idx}", f"{2*idx+1}")
        dot.edge(f"{idx}", f"{2*idx+2}")

        self.var.plot(2*idx+1, dot)
        self.exp.plot(2*idx+2, dot)


class ApplicationNode(Node):

    def __init__(self, expA: Node, expB: Node):
        self.expA = expA
        self.expB = expB

    def __repr__(self):
        return "("+str(self.expA)+" "+str(self.expB)+")"

    def debugPrint(self):
        return "(APPLICATION: "+str(self.expA.debugPrint())+" "+str(self.expB.debugPrint())+")"

    def plot(self, idx, dot):
        dot.node(f"{idx}", "APP "+str(self))

        dot.edge(f"{idx}", f"{2*idx+1}")
        dot.edge(f"{idx}", f"{2*idx+2}")

        self.expA.plot(2*idx+1, dot)
        self.expB.plot(2*idx+2, dot)
