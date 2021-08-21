export default class Dijkstra {
    constructor(startNode, endNode, graph) {
        this.startNode = startNode;
        this.endNode = endNode;
        this.Graph = graph;

        this.CONNECTION_WEIGHT = 1;

        this.nodes = [...this.Graph.nodes];

        this.nodes.forEach((node) => {
            node.dist = Infinity;
        });

        this.nodes[startNode.index].dist = 0;
    }

    solve() {
        let remaining = [...this.Graph.nodes];
        let visitedCount = 0;

        while (remaining.length > 0) {
            const minDist = Math.min.apply(Math, [
                ...remaining.map((node) => node.dist)
            ]);

            if (minDist === Infinity) {
                return null;
            }
            const bestCandidate = remaining.find(
                (node) => node.dist === minDist
            );

            if (bestCandidate) {
                if (bestCandidate === this.endNode) {
                    return bestCandidate;
                }

                remaining = remaining.filter((node) => node !== bestCandidate);
                bestCandidate.visitedCount = visitedCount;
                visitedCount++;

                this.Graph.findNeighbour(bestCandidate);

                bestCandidate.neighbours.forEach((neighbour) => {
                    const newDist = bestCandidate.dist + this.CONNECTION_WEIGHT;

                    if (newDist < neighbour.dist) {
                        neighbour.dist =
                            bestCandidate.dist + this.CONNECTION_WEIGHT;
                        neighbour.prev = bestCandidate;
                    }
                });
            }
        }
    }
}
