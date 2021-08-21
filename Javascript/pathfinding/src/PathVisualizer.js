import { Graph } from "./Solver/Graph";
import React, { Component } from "react";

import NavBar from "./NavBar/NavBar";
import Field from "./Game/Field";

import Dijkstra from "./Solver/Dijkstra";
import AStar from "./Solver/AStar";

class BlockClass {
    constructor(index) {
        this.index = index;
        this.type = "empty";
        this.overlay = "";
    }
}

function getWindowDimensions() {
    const { innerWidth: width, innerHeight: height } = window;
    return {
        width,
        height
    };
}

export class PathVisualizer extends Component {
    constructor({ getWindowDimensions }) {
        super();

        this.mousePressed = false;
        this.animating = false;
        this.calculating = false;
        this.interuptedAnimating = false;

        this.text = "";

        this.startIndex = null;
        this.endIndex = null;

        this.dims = [50, 25];

        this.boxes = [];
        this.selectedBrush = "";

        this.setboxes = (a) => {
            this.boxes = a;
        };

        this.setselectedBrush = (a) => {
            this.selectedBrush = a;
        };

        this.setGridDims();

        this.handleClick = this.handleClick.bind(this);
        this.clear = this.clear.bind(this);
        this.randomize = this.randomize.bind(this);
        this.solve = this.solve.bind(this);
        this.animate = this.animate.bind(this);
        this.setGridDims = this.setGridDims.bind(this);

        this.randomize();
    }

    //Draw
    handleClick(element, state, index) {
        if (state === "down") {
            this.mousePressed = true;
            this.clone = [...this.boxes];
            if (this.selectedBrush) this.setCSS(element, this.selectedBrush);

            if (this.selectedBrush === "start") {
                if (this.startIndex !== index) {
                    this.setCSS(
                        document.getElementById(`node-${this.startIndex}`),
                        "empty"
                    );
                    this.startIndex = index;
                }
            }

            if (this.selectedBrush === "end") {
                if (this.endIndex !== index) {
                    this.setCSS(
                        document.getElementById(`node-${this.endIndex}`),
                        "empty"
                    );
                    this.endIndex = index;
                }
            }
        } else if (state === "up") {
            this.mousePressed = false;

            if (!this.clone) return;

            try {
                if (this.selectedBrush === "start")
                    this.clone.find((box) => box.type === "start").type =
                        "empty";

                if (this.selectedBrush === "end")
                    this.clone.find((box) => box.type === "end").type = "empty";
            } catch {}

            if (this.selectedBrush) this.clone[index].type = this.selectedBrush;

            this.setboxes(this.clone);
        } else if (state === "drag") {
            if (this.selectedBrush && this.mousePressed) {
                if (
                    this.selectedBrush === "wall" ||
                    this.selectedBrush === "empty"
                ) {
                    this.clone[index].type = this.selectedBrush;
                    this.setCSS(element, this.selectedBrush);
                }
            }
        }
    }

    //Preset Css
    setCSS(element, value) {
        const currentState = element.classList[element.classList.length - 1];
        element.classList.remove(currentState);
        element.classList.add(value);
    }

    clear() {
        if (this.animating) {
            clearInterval(this.pathInterval);

            clearInterval(this.visitedInterval);

            this.animating = false;
        }
        const copy = [...this.boxes];

        copy.forEach((box) => {
            box.overlay = "";
        });
        this.setboxes(copy);
        this.text = "";
        this.setState({ state: this.state });
    }

    //Randomize
    randomize() {
        if (this.animating === false) {
            const emptyBoxes = Array.from(
                { length: this.dims[0] * this.dims[1] },
                (_, i) => {
                    return new BlockClass(i);
                }
            );

            for (let i = 0; i < Math.floor(emptyBoxes.length * 0.25); i++) {
                emptyBoxes[getRandomInt(0, emptyBoxes.length)].type = "wall";
            }

            this.startIndex =
                getRandomInt(1, 4) * this.dims[0] +
                getRandomInt(0, Math.ceil(this.dims[0] / 2));

            this.endIndex =
                emptyBoxes.length -
                getRandomInt(1, 4) * this.dims[0] -
                getRandomInt(0, Math.ceil(this.dims[0] / 2));

            emptyBoxes[this.startIndex].type = "start";
            emptyBoxes[this.endIndex].type = "end";

            this.setboxes(emptyBoxes);
            this.setState({ state: this.state });
        }
    }

    //Solve for Path
    solve(algorithm) {
        if (this.animating === true) {
            this.clear();
        }

        if (this.calculating === false) {
            this.calculating = true;

            var tStart = performance.now();

            const graph = new Graph(this.boxes, this.dims);

            const startNode = graph.findStartNode();
            const endNode = graph.findEndNode();

            if (!endNode || !startNode) {
                this.text = !endNode ? "No End Node!" : "No Start Node!";
                this.calculating = false;
                this.setState({ state: this.state });
                return;
            }

            let Solver =
                algorithm === "AStar"
                    ? new AStar(startNode, endNode, graph)
                    : new Dijkstra(startNode, endNode, graph);

            const target = Solver.solve();

            const path = graph.traceBack(target);
            const visited = graph.getVisited(Solver.nodes);

            var tEnd = performance.now();

            this.calculating = false;

            const timeTaken = tEnd - tStart;

            this.text = (
                <>
                    <span className="hide-on-small-only left">
                        {Math.round(timeTaken * 100) / 100} ms
                    </span>

                    <i className="material-icons right hide-on-med-and-down">
                        timer
                    </i>
                    <i className="material-icons hide-on-med-and-up">timer</i>
                </>
            );
            this.setState({ state: this.state });

            this.animating = true;
            this.animate(visited, path);
        }
    }

    animate(visited, path) {
        if (visited.length !== 0) {
            this.visitedInterval = setInterval(animate.bind(this), 15);

            var iterations = 0;
            function animate() {
                const el = document.getElementById(
                    `node-${visited[iterations]}`
                );
                this.setCSS(el, "visited");

                if (iterations === visited.length - 1) {
                    this.animatePath(path);
                }

                if (iterations === visited.length - 1)
                    clearInterval(this.visitedInterval);

                iterations++;
            }
        }
    }

    animatePath(path) {
        if (path.length !== 0) {
            this.pathInterval = setInterval(animate.bind(this), 80);

            var iterations = 1;
            function animate() {
                const el = document.getElementById(`node-${path[iterations]}`);
                this.setCSS(el, "path");

                if (iterations === path.length - 2) {
                    this.animating = false;
                    this.interuptedAnimating = false;
                }

                if (iterations === path.length - 2)
                    clearInterval(this.pathInterval);

                iterations++;
            }
        } else {
            this.animating = false;
            this.interuptedAnimating = false;
            this.text = "";
        }
    }

    setGridDims() {
        const dimensions = getWindowDimensions();

        const ratio = dimensions.width / dimensions.height;

        this.dims = [
            Math.round(dimensions.width / 40),
            Math.round(dimensions.width / 42 / ratio)
        ];
    }

    render() {
        return (
            <div className="App">
                <NavBar
                    solve={this.solve}
                    randomize={this.randomize}
                    text={this.text}
                    setselectedBrush={this.setselectedBrush}
                    clear={this.clear}
                />
                <Field
                    dims={this.dims}
                    boxes={this.boxes}
                    handleClick={this.handleClick}
                />
            </div>
        );
    }
}

function getRandomInt(min, max) {
    min = Math.ceil(min);
    max = Math.floor(max);
    return Math.floor(Math.random() * (max - min)) + min;
}
