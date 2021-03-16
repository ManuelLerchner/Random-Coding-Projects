import numpy as np
import matplotlib.pyplot as plt
from matplotlib.image import imread
import random
import timing


def heuristic(x1, y1, x2, y2):
    return round(10 * ((x1 - x2) ** 2 + (y1 - y2) ** 2) ** 0.5)


maze = imread("Python\Data\maze.png")
maze = maze[:, :, 0]
n, m = maze.shape
allowDiag = False
wallPercentage = 0.25

for i in range(m):
    if maze[0][i] == 1:
        startY = i
        break

for i in range(m):
    if maze[n - 1][i] == 1:
        endY = i
        break
startX = 0
endX = n - 1


class Node:

    def __init__(self, x, y):
        self.x, self.y = x, y

        self.fCost = self.gCost = self.hCost = 0
        self.isPath = self.isWall = False

        self.neighbours = []
        self.parent = None

        if maze[x][y] == 0:
            self.isWall = True

    def calcHCost(self):
        self.hCost = heuristic(self.x, self.y, endX, endY)
        self.fCost = self.gCost + self.hCost


grid = [[Node(_, h) for h in range(m)] for _ in range(n)]
timing.log("Grid created")


def neighbours(C):
    nei = []
    for x in range(-1, 2):
        for y in range(-1, 2):
            if x != 0 or y != 0:
                if 0 <= C.x + x < n and 0 <= C.y + y < m:
                    if x == 0 or y == 0 or allowDiag:
                        nei.append(grid[C.x + x][C.y + y])
    return nei


def explore(C):
    C.neighbours = neighbours(C)
    C.calcHCost()

    for N in C.neighbours:
        N.calcHCost()


startNode = grid[startX][startY]
endNode = grid[endX][endY]
startNode.isPath = endNode.isPath = True
startNode.isWall = endNode.isWall = False

openSet = [startNode]
closedSet = []
Path = []

while True:

    if len(openSet) == 0:
        break

    current = sorted(openSet, key=lambda N: N.fCost)[0]
    openSet.remove(current)
    closedSet.append(current)

    if current is endNode:
        # Backtrack
        current.isPath = True
        while current.parent is not None:
            current = current.parent
            current.isPath = True

        break

    explore(current)
    for N in current.neighbours:
        explore(N)
        if N in closedSet or N.isWall:
            continue

        distToNei = heuristic(current.x, current.y, N.x, N.y)
        if N not in openSet or N.gCost >= current.gCost + distToNei:
            N.gCost = current.gCost + distToNei
            N.fCost = N.gCost + N.hCost

            N.parent = current
            if N not in openSet:
                openSet.append(N)

# Plot
timing.log("Path calculated")
gridPlot = np.zeros((n, m))

for i in range(n):
    for j in range(m):
        curr = grid[i][j]

        if curr.isWall:
            gridPlot[i][j] = -1

        if curr.isPath:
            gridPlot[i][j] = 2

plt.imshow(gridPlot)
timing.log("Done")
plt.show()
