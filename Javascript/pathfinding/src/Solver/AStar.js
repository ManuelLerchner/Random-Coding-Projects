export default class AStar {
    constructor(startIndex, endIndex, graph) {
        this.startIndex = startIndex;
        this.endIndex = endIndex;
        this.Graph = graph;

        this.nodes = [...this.Graph.nodes];

        this.nodes.forEach((node) => {
            node.f = Infinity;
            node.g = Infinity;
        });

        const startNode = this.nodes[startIndex];
        startNode.g = 0;
        startNode.f = this.hCost(startNode);

        this.open = [startNode];
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

            if (currentNode.index === this.endIndex) {
                return currentNode;
            }

            currentNode.visitedCount = visitedCount;
            visitedCount++;

            this.open = this.open.filter((item) => item !== currentNode);
            this.closed.push(currentNode);

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

        this.nodes = this.open;
    }

    heuristic([x1, y1], [x2, y2]) {
        return Math.sqrt((x1 - x2) ** 2 + (y1 - y2) ** 2);
    }

    hCost(Node) {
        return this.edgeCost(Node, this.nodes[this.endIndex]);
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
