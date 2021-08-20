export default class Dijkstra {
    constructor(startIndex, endIndex, graph) {
        this.startIndex = startIndex;
        this.endIndex = endIndex;
        this.Graph = graph;

        this.CONNECTION_WEIGHT = 10;

        this.nodes = [...this.Graph.nodes];

        this.nodes.forEach((node) => {
            node.dist = Infinity;
        });

        this.Graph.nodes[this.startIndex].dist = 0;
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
                if (bestCandidate.index === this.endIndex) {
                    return bestCandidate;
                }

                remaining = remaining.filter((node) => node !== bestCandidate);
                bestCandidate.visitedCount = visitedCount;
                visitedCount++;

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
