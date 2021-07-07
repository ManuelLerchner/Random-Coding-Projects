import os

from graphviz import Digraph

from nodes import Node


def visualizeAST(Node: Node, idx=""):
    dot = Digraph(comment='Abstract Syntax Tree')

    Node.plot(0, dot)

    dot.render(f'Visuals/AST_{idx}.gv')
    os.remove(f'Visuals/AST_{idx}.gv')
