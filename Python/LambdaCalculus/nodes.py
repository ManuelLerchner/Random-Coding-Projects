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
    def createDependencies(self):
        """
        Links a Function Variable to all its occurences
        """
        pass

    @abstractmethod
    def plot(self, idx, dot):
        """
        Plots current Node into GraphViz Diagram
        """
        pass

    @abstractmethod
    def replace(self, variable, new):
        """
        Replaces given Variable with new Node
        """
        pass


class FunctionNode(Node):

    def __init__(self, var: Node, exp: Node):
        self.variable = var
        self.exp = exp
        self.dependencies = []

    def __repr__(self):
        return "λ"+str(self.variable)+"."+str(self.exp)

    def debugPrint(self):
        return "{FUNCTION: λ"+str(self.variable.debugPrint())+"."+str(self.exp.debugPrint())+"}"

    def replace(self, varNode, new):
        if self.exp.replace(varNode, new):
            self.exp = new

    def createDependencies(self, Caller):
        self.exp.createDependencies(Caller)

    def plot(self, idx, dot):
        dot.node(f"{idx}", "FUN "+str(self))

        dot.edge(f"{idx}", f"{2*idx+1}")
        dot.edge(f"{idx}", f"{2*idx+2}")

        self.variable.plot(2*idx+1, dot)
        self.exp.plot(2*idx+2, dot)


class ApplicationNode(Node):

    def __init__(self, expA: Node, expB: Node):
        self.expA = expA
        self.expB = expB

    def __repr__(self):
        return "("+str(self.expA)+" "+str(self.expB)+")"

    def debugPrint(self):
        return "(APPLICATION: "+str(self.expA.debugPrint())+" "+str(self.expB.debugPrint())+")"

    def replace(self, varNode, new):
        if self.expA.replace(varNode, new):
            self.expA = new
        if self.expB.replace(varNode, new):
            self.expB = new

    def createDependencies(self, Caller: FunctionNode):
        self.expA.createDependencies(Caller)
        self.expB.createDependencies(Caller)

    def plot(self, idx, dot):
        dot.node(f"{idx}", "APP "+str(self))

        dot.edge(f"{idx}", f"{2*idx+1}")
        dot.edge(f"{idx}", f"{2*idx+2}")

        self.expA.plot(2*idx+1, dot)
        self.expB.plot(2*idx+2, dot)


class VarNode(Node):

    def __init__(self, var: Token):
        self.var = var

    def __repr__(self):
        return str(self.var.value)

    def debugPrint(self):
        return "[VAR: "+str(self.var.value)+"]"

    def replace(self, varNode, new):
        return varNode.var.value == self.var.value

    def createDependencies(self, Caller: FunctionNode):
        pass

    def plot(self, idx, dot):
        dot.node(f"{idx}", "VAR "+str(self))
