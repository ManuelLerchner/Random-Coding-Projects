import { Graph } from "./Solver/Graph";

import Dijkstra from "./Solver/Dijkstra";

class BlockClass {
    constructor(index) {
        this.index = index;
        this.type = "empty";
        this.symbol = "";
        this.overlay = "";
    }
}

export class PathVisualizer {
    constructor(dims, setdims, boxes, setboxes, selectedBrush) {
        this.mousePressed = false;
        this.clone = null;

        this.dims = dims;
        this.setdims = setdims;
        this.setboxes = setboxes;
        this.boxes = boxes;
        this.selectedBrush = selectedBrush;

        this.startPos = 0;
        this.endPos = 0;

        this.handleClick = this.handleClick.bind(this);
        this.randomize = this.randomize.bind(this);
        this.solve = this.solve.bind(this);
        this.clear = this.clear.bind(this);
    }

    //Draw
    handleClick(element, state, index) {
        if (state === "down") {
            this.mousePressed = true;
            this.clone = [...this.boxes];
            if (this.selectedBrush) this.setCSS(element);
        } else if (state === "up") {
            this.mousePressed = false;

            if (!this.clone) return;

            if (this.selectedBrush === "start")
                this.clone.find((box) => box.type === "start").type = "empty";

            if (this.selectedBrush === "end")
                this.clone.find((box) => box.type === "end").type = "empty";

            if (this.selectedBrush) this.clone[index].type = this.selectedBrush;

            this.setboxes(this.clone);
        } else if (state === "drag") {
            if (this.selectedBrush && this.mousePressed) {
                if (
                    this.selectedBrush === "wall" ||
                    this.selectedBrush === "empty"
                ) {
                    this.clone[index].type = this.selectedBrush;
                    this.setCSS(element);
                }
            }
        }
    }

    clear() {
        const copy = [...this.boxes];

        copy.forEach((box) => {
            box.overlay = "";
        });
        this.setboxes(copy);
    }

    //Preset Css
    setCSS(element) {
        const currentState = element.classList[element.classList.length - 1];
        element.classList.remove(currentState);
        element.classList.add(this.selectedBrush);
    }

    //Randomize
    randomize() {
        const emptyBoxes = Array.from(
            { length: this.dims[0] * this.dims[1] },
            (_, i) => {
                return new BlockClass(i);
            }
        );

        for (let i = 0; i < Math.floor(emptyBoxes.length * 0.25); i++) {
            emptyBoxes[getRandomInt(0, emptyBoxes.length)].type = "wall";
        }

        this.startPos = getRandomInt(0, this.dims[0]);
        this.endPos = getRandomInt(
            emptyBoxes.length - this.dims[0],
            emptyBoxes.length
        );

        emptyBoxes[this.startPos].type = "start";
        emptyBoxes[this.endPos].type = "end";

        this.setboxes(emptyBoxes);
    }

    //Solve for Path
    solve() {
        const graph = new Graph(this.boxes, this.dims);

        const start = this.boxes.find((box) => box.type === "start");
        const end = this.boxes.find((box) => box.type === "end");

        const Solver = new Dijkstra(start, end, graph);

        const target = Solver.solve();
        const path = Solver.Graph.traceBack(target).slice(1, -1);
        const visited = Solver.Graph.getVisited();

        const copy = [...this.boxes];

        copy.forEach((box) => {
            box.overlay = "";
        });

        visited.forEach((i) => {
            copy[i].overlay = "visited";
        });

        path.forEach((i) => {
            copy[i].overlay = "path";
        });

        this.setboxes(copy);
    }
}

function getRandomInt(min, max) {
    min = Math.ceil(min);
    max = Math.floor(max);
    return Math.floor(Math.random() * (max - min)) + min;
}
