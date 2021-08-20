export default class AStar {
    constructor(start, end, graph) {
        this.start = start;
        this.end = end;
        this.Graph = graph;

        this.CONNECTION_WEIGHT = 10;
        this.Graph.nodes[this.start.index].setDist(0);
    }

    solve() {
        let remaining = [...this.Graph.nodes];

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
                if (bestCandidate.index === this.end.index) {
                    return bestCandidate;
                }

                remaining = remaining.filter((node) => node !== bestCandidate);
                bestCandidate.visited = true;

                bestCandidate.neighbours.forEach((neighbour) => {
                    const newDist = bestCandidate.dist + this.CONNECTION_WEIGHT;

                    if (newDist < neighbour.dist) {
                        neighbour.setDist(
                            bestCandidate.dist + this.CONNECTION_WEIGHT
                        );
                        neighbour.prev = bestCandidate;
                    }
                });
            }
        }
    }
}
