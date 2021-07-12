from colorama import Fore

from lambdaToken import Token
from nodes import ApplicationNode, FunctionNode, Node, VarNode
from utility import printColor


class Interpreter:

    def __init__(self, MAX_STEPS=10):
        self.MAX_STEPS = MAX_STEPS

    def reduce(self, AST: Node, debug):
        """
        Reduces the given node as far as possible
        """
        if(debug):
            printColor("Trying to interpret AST:", Fore.YELLOW)
            printColor(AST, Fore.GREEN, end="\n\n")

        reduced = self.evaluate(AST)
        if(debug):
            printColor("Got following result:", Fore.YELLOW)
            printColor(reduced, '\033[1m'+Fore.GREEN, end="\n\n")

        return reduced

    def isFunction(self, N): return type(N) == FunctionNode
    def isVariable(self, N): return type(N) == VarNode
    def isApplication(self, N): return type(N) == ApplicationNode

    def evaluate(self, Node: Node):

        for _ in range(self.MAX_STEPS):
            if self.isApplication(Node):

                if self.isVariable(Node.expA):
                    Node.expB = self.evaluate(Node.expB)
                    return Node

                elif self.isFunction(Node.expA):
                    Node.expA.replace(Node.expA.variable, Node.expB,
                                      Node.expA.variable.token.internalIDX)
                    Node = Node.expA.exp

                elif self.isApplication(Node.expA) and self.isVariable(Node.expB):
                    prev = Node.expA
                    Node.expA = self.evaluate(Node.expA)
                    if prev == Node.expA:
                        return Node

                else:
                    prev = Node.expA
                    Node.expA = self.evaluate(Node.expA)
                    if prev == Node.expA:
                        return Node

            elif self.isFunction(Node):
                Node.exp = self.evaluate(Node.exp)
                return Node

            else:
                return Node

        printColor(
            f"Reached the maximum steps of reducing cycles, while simpifiying {Node}", Fore.RED)

        return Node
