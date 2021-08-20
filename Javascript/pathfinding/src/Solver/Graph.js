class Node {
    constructor(index) {
        this.dist = Infinity;
        this.prev = null;
        this.index = index;
        this.neighbours = [];
        this.visited = false;
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

        this.nodes = Array.from(boxes, (_, i) => {
            return new Node(i);
        });

        this.findNeighbour(dims);
    }

    findNeighbour(dims) {
        this.nodes.forEach((node) => {
            const index = node.index;
            if (index % dims[0] !== 0) {
                this.addNeighbour(node, index - 1);
            }
            if ((index + 1) % dims[0] !== 0) {
                this.addNeighbour(node, index + 1);
            }
            if (Math.floor(index / dims[0]) !== 0) {
                this.addNeighbour(node, index - dims[0]);
            }
            if (Math.ceil((index + 1) / dims[0]) !== dims[1]) {
                this.addNeighbour(node, index + dims[0]);
            }
        });
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

    getVisited() {
        return this.nodes
            .filter((node) => node.visited)
            .map((node) => node.index);
    }
}
