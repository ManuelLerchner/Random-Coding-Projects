export default class BFS {
    constructor(startNode, endNode, graph) {
        this.startNode = startNode;
        this.endNode = endNode;
        this.Graph = graph;

        this.nodes = [...this.Graph.nodes];

        this.visitedCount = 0;
    }

    solve() {
        return this.DFS(this.startNode, this.endNode);
    }

    DFS(node, goal) {
        if (node.index === goal.index) {
            return node;
        }

        node.visitedCount = this.visitedCount;
        this.visitedCount++;

        const stack = [];

        this.Graph.findNeighbour(node);

        node.neighbours.reverse().forEach((child) => {
            if (child.visitedCount === null) {
                child.prev = node;
                stack.push(child);
            }
        });

        while (stack.length > 0) {
            const curr = stack.pop();

            const res = this.DFS(curr, goal);

            if (res) {
                return res;
            }
        }
    }
}
