

class Node:

    def __init__(self, value):
        self.left = None
        self.right = None
        self.value = value


root = Node(1)

root.left = Node(2)
root.right = Node(8)

root.left.left = Node(3)
root.left.right = Node(7)

root.right.left = Node(9)

root.left.left.left = Node(4)
root.left.left.right = Node(6)

root.left.left.left.left = Node(5)


Set = []


def printNode(root, sum):

    if root is None:
        return

    printNode(root.left, sum - 1)

    if not sum in Set:
        print(str(root.value) + "  " + str(sum))
        Set.append(sum)
    printNode(root.right, sum + 1)


printNode(root, 0)
