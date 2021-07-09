from abc import ABC, abstractmethod
from copy import deepcopy

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
    def renameVariables(self):
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
        Replaces given Variable with new Node --> recurses in all subNodes
        """
        pass


class FunctionNode(Node):

    def __init__(self, variable: Node, exp: Node):
        self.variable = variable
        self.exp = exp

    def __repr__(self):
        return "λ"+str(self.variable)+"."+str(self.exp)

    def debugPrint(self):
        return "{FUNCTION: λ"+str(self.variable.debugPrint())+"."+str(self.exp.debugPrint())+"}"

    def replace(self, varNode, new, newIdx):

        if self.exp.replace(varNode, new, newIdx):
            self.exp = new

    def renameVariables(self, idx):
        self.exp.renameVariables(2*idx+2)
        newVar = VarNode(
            Token(Token.VAR, self.variable.token.varName, 2*idx+2))
        self.replace(VarNode(self.variable.token), newVar, 2*idx+2)
        self.variable = newVar

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

    def replace(self, varNode, new, newIdx):
        NEW = deepcopy(new)

        NEW.renameVariables(newIdx)

        #print("...", newIdx, self, "---", varNode, "---", NEW)

        if self.expA.replace(varNode, NEW, 2*newIdx+1):
            self.expA = NEW

        if self.expB.replace(varNode, NEW, 2*newIdx+2):
            self.expB = NEW

        #print("-->", newIdx, self)

    def renameVariables(self, idx: FunctionNode):
        self.expA.renameVariables(2*idx+1)
        self.expB.renameVariables(2*idx+2)

    def plot(self, idx, dot):
        dot.node(f"{idx}", "APP "+str(self))

        dot.edge(f"{idx}", f"{2*idx+1}")
        dot.edge(f"{idx}", f"{2*idx+2}")

        self.expA.plot(2*idx+1, dot)
        self.expB.plot(2*idx+2, dot)


class VarNode(Node):

    def __init__(self, token: Token):
        self.token = token

    def __repr__(self):
        return str(self.token)

    def debugPrint(self):
        return "[VAR: "+str(self.token.varName)+"]"

    def replace(self, varNode, new, newIdx):
        return (varNode.token.varName == self.token.varName) and (
            varNode.token.internalIDX == self.token.internalIDX)

    def renameVariables(self, idx: FunctionNode):
        pass

    def plot(self, idx, dot):
        dot.node(f"{idx}", "VAR "+str(self))
