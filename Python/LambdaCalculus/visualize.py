import os

from graphviz import Digraph

from nodes import Node


def visualizeAST(Node: Node, name, inputString):
    dot = Digraph(comment='Abstract Syntax Tree')

    Node.plot(0, dot)

    dot.render(f'Visuals/{inputString}/AST_{name}.gv')
    os.remove(f'Visuals/{inputString}/AST_{name}.gv')
