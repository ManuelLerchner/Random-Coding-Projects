class Node {
    constructor(type, index) {
        this.type = type;
        this.index = index;
        this.neighbours = [];
        this.prev = null;
        this.visitedCount = null;
    }

    setDist(dist) {
        this.dist = dist;
    }

    addNeighbour(neighbour) {
        this.neighbours.push(neighbour);
    }
}

export class Graph {
    constructor(boxes, dims) {
        this.boxes = boxes;
        this.dims = dims;

        this.nodes = Array.from(boxes, (box, i) => {
            return new Node(box.type, i);
        });
    }

    findStartNode() {
        return this.nodes.find((node) => node.type === "start");
    }

    findEndNode() {
        return this.nodes.find((node) => node.type === "end");
    }

    findNeighbour(node) {
        const index = node.index;
        if (index % this.dims[0] !== 0) {
            this.addNeighbour(node, index - 1);
        }
        if ((index + 1) % this.dims[0] !== 0) {
            this.addNeighbour(node, index + 1);
        }
        if (Math.floor(index / this.dims[0]) !== 0) {
            this.addNeighbour(node, index - this.dims[0]);
        }
        if (Math.ceil((index + 1) / this.dims[0]) !== this.dims[1]) {
            this.addNeighbour(node, index + this.dims[0]);
        }
    }

    addNeighbour(node, index) {
        const nodetype = this.boxes[index].type;
        if (nodetype !== "wall") {
            node.addNeighbour(this.nodes[index]);
        }
    }

    traceBack(node) {
        const pathIndices = [];

        while (node) {
            pathIndices.push(node.index);
            node = node.prev;
        }

        return pathIndices;
    }

    getVisited(nodes) {
        return nodes
            .filter((node) => node.visitedCount)
            .sort((a, b) => {
                return a.visitedCount - b.visitedCount;
            })
            .map((node) => node.index);
    }
}
