from colorama import Fore

from lambdaToken import Token
from nodes import ApplicationNode, FunctionNode, Node, VarNode
from utility import printColor


class Interpreter:

    def __init__(self, MAX_STEPS=100):
        self.MAX_STEPS = MAX_STEPS

    def reduce(self, AST: Node):
        """
        Reduces the given node as far as possible
        """

        printColor("Trying to interpret AST:", Fore.YELLOW)
        printColor(AST, Fore.GREEN, end="\n\n")

        reduced = self.evaluate(AST)
        printColor("\nGot following result:", Fore.YELLOW)
        printColor(reduced, '\033[1m'+Fore.GREEN, end="\n\n")

        return reduced

    def evaluate(self, Node):
        """
        Recursive Function to evaluate Nodes
        """

        def isFunction(N): return type(N) == FunctionNode
        def isVar(N): return type(N) == VarNode
        def isApplication(N): return type(N) == ApplicationNode

        Copy = None

        for _ in range(self.MAX_STEPS):
            if isApplication(Node):

                # If Variable on Left Side
                if isVar(Node.expA):
                    newExpB = self.evaluate(Node.expB)
                    Node.expB = newExpB
                    Copy = Node

                    if Node.expB == newExpB:  # no Changes
                        return Node

                # Replace VAR with Function or Variable
                elif isFunction(Node.expA) and (isFunction(Node.expB) or isVar(Node.expB)):
                    Node.replace(Node.expA.variable, Node.expB, 0)
                    Node = Node.expA.exp
                    Copy = Node

                # If Function on Left Side, simplify Right side
                elif isFunction(Node.expA):
                    newExpB = self.evaluate(Node.expB)
                    Node.expB = newExpB
                    Copy = Node
                    if Node.expB == newExpB:  # no Changes
                        return Node

                # Simplify Left side
                elif isApplication(Node.expA) and isVar(Node.expB):
                    Node.expA = self.evaluate(Node.expA)
                    Copy = Node

                else:
                    Node.expA = self.evaluate(Node.expA)
                    Copy = Node

            elif isFunction(Node):
                Node.exp = self.evaluate(Node.exp)
                return Node

            else:
                # No simplification possible
                return Node

        printColor(
            f"Reached the maximum stats of reducing cycles, while simpifiying {Copy}", Fore.RED)

        return Copy
