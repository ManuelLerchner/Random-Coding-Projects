from graphviz import Digraph
from nodes import Node


def visualize(Node: Node):
    dot = Digraph(comment='Syntax Tree')

    Node.plot(0, dot)

    dot.render('AST.gv')
