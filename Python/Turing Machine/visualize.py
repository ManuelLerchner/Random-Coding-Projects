from graphviz import Digraph
import os


def visualize(name, Q, δ, F, q0):
    dot = Digraph()
    dot.attr(rankdir='LR')
    dot.attr('node', shape='circle')

    for node in Q:
        if node == q0:
            dot.node(node, node, shape='doubleoctagon')
        elif node in F:
            dot.node(node, node, shape='doublecircle')
        else:
            dot.node(node, node)

    for (key, val) in δ.transitionFunction.items():
        start = key[0]
        if val is not None:
            end = val[1]
            text = f"{key[1]}/{val[0]},{val[2]}"
            dot.edge(start, end, text)

    dot.render(f'Visuals/{name}.gv')
    os.remove(f'Visuals/{name}.gv')
