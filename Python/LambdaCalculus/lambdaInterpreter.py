from colorama import Fore

from lambdaToken import Token
from nodes import ApplicationNode, FunctionNode, Node, VarNode
from utility import printColor


class Interpreter:

    def __init__(self, MAX_STEPS=5):
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
    def isVar(self, N): return type(N) == VarNode
    def isApplication(self, N): return type(N) == ApplicationNode

    def evaluate(self, Node):
        """
        Recursive Function to evaluate Nodes
        """

        Copy = None

        for _ in range(self.MAX_STEPS):
            if self.isApplication(Node):

                # If Variable on Left Side
                if self.isVar(Node.expA):
                    # print("A", Node)
                    Node.expB = self.evaluate(Node.expB)
                    return Node

                # Replace VAR with Function or Variable
                elif self.isFunction(Node.expA) and (self.isFunction(Node.expB) or self.isVar(Node.expB) or self.isApplication(Node.expB)):
                    # print("B", Node)
                    Node.replace(Node.expA.variable, Node.expB, 0)
                    Node = Node.expA.exp
                    Copy = Node

                # If Function on Left Side, simplify Right side
                elif self.isFunction(Node.expA):
                    print("C", Node)
                    Node.expB = self.evaluate(Node.expB)
                    #Copy = Node
                    return Node

                # Simplify Left side
                elif self.isApplication(Node.expA) and self.isVar(Node.expB):
                    # print("D", Node)
                    newExpA = self.evaluate(Node.expA)
                    if Node.expA == newExpA:  # no Changes
                        return Node
                    Node.expA = newExpA
                    Copy = Node

                else:
                    # print("F", Node)
                    Node.expA = self.evaluate(Node.expA)
                    Copy = Node

            elif self.isFunction(Node):
                # print("G", Node)
                Node.exp = self.evaluate(Node.exp)
                return Node

            else:
                # print("H", Node)
                # No simplification possible
                return Node

        # printColor(
        #    f"Reached the maximum steps of reducing cycles, while simpifiying {Copy}", Fore.RED)

        return Copy
