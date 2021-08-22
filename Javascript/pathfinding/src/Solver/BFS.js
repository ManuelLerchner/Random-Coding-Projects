export default class BFS {
    constructor(startNode, endNode, graph) {
        this.startNode = startNode;
        this.endNode = endNode;
        this.Graph = graph;

        this.nodes = [...this.Graph.nodes];

        this.visitedCount = 1;
    }

    solve() {
        const Start = this.nodes[this.startNode.index];
        Start.visitedCount = 0;

        let queue = [Start];

        while (queue.length > 0) {
            const node = queue.shift();

            if (node === this.endNode) {
                return node;
            }

            this.Graph.findNeighbour(node);

            node.neighbours.forEach((child) => {
                if (child.visitedCount === null) {
                    child.prev = node;
                    queue.push(child);
                    child.visitedCount = this.visitedCount;
                    this.visitedCount++;
                }
            });
        }
    }
}
