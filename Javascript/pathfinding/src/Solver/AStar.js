export default class AStar {
    constructor(startNode, endNode, graph) {
        this.startNode = startNode;
        this.endNode = endNode;
        this.Graph = graph;

        this.nodes = [...this.Graph.nodes];

        this.nodes.forEach((node) => {
            node.f = Infinity;
            node.g = Infinity;
        });

        const Start = this.nodes[startNode.index];
        Start.g = 0;
        Start.f = this.hCost(Start);

        this.open = [Start];
        this.closed = [];
    }

    solve() {
        let visitedCount = 0;
        while (this.open.length > 0) {
            const minDist = Math.min.apply(
                Math,
                this.open.map((node) => node.f)
            );
            const currentNode = this.open.find((node) => node.f === minDist);

            if (currentNode === this.endNode) {
                this.nodes = this.closed;
                return currentNode;
            }

            currentNode.visitedCount = visitedCount;
            visitedCount++;

            this.open = this.open.filter((item) => item !== currentNode);
            this.closed.push(currentNode);

            this.Graph.findNeighbour(currentNode);

            currentNode.neighbours.forEach((successor) => {
                if (!this.closed.includes(successor)) {
                    const new_g_val =
                        currentNode.g + this.edgeCost(currentNode, successor);

                    if (
                        new_g_val < successor.g ||
                        !this.open.includes(successor)
                    ) {
                        successor.g = new_g_val;
                        successor.f = successor.g + this.hCost(successor);
                        successor.prev = currentNode;

                        if (!this.open.includes(successor)) {
                            this.open.push(successor);
                        }
                    }
                }
            });
        }

        this.nodes = this.closed;
    }

    heuristic([x1, y1], [x2, y2]) {
        return Math.sqrt((x1 - x2) ** 2 + (y1 - y2) ** 2);
    }

    hCost(Node) {
        return this.edgeCost(Node, this.endNode);
    }

    edgeCost(NodeA, NodeB) {
        const lenX = this.Graph.dims[0];

        const posA = this.indexToPos(NodeA.index, lenX);
        const posB = this.indexToPos(NodeB.index, lenX);

        return this.heuristic(posA, posB);
    }

    indexToPos(i, lenX) {
        const x = i % lenX;
        const y = Math.floor(i / lenX);
        return [x, y];
    }
}
