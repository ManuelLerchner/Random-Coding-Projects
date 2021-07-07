from lambdaToken import Token
from nodes import ApplicationNode, FunctionNode, Node, VarNode


class Interpreter:

    def reduce(self, AST: Node):
        return self.evaluate(AST)

    def evaluate(self, Node):

        def isFunction(N): return type(N) == FunctionNode
        def isVar(N): return type(N) == VarNode

        while True:

            if type(Node) == ApplicationNode:

                # Replace VAR with Function or Variable
                if isFunction(Node.expA) and (isFunction(Node.expB) or isVar(Node.expB)):
                    Node.replace(Node.expA.variable, Node.expB)
                    Node = Node.expA.exp

                # If Function on Left Side, simplify Right side
                elif isFunction(Node.expA):
                    newExpB = self.evaluate(Node.expB)
                    Node.expB = newExpB
                    if Node.expB == newExpB:  # no Changes
                        return Node

                # Simplify Left side
                else:
                    Node.expA = self.evaluate(Node.expA)

            else:
                # No simplification possible
                return Node
