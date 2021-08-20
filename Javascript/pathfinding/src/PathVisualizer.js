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

export class PathVisualizer extends Component {
    constructor({ dims }) {
        super();

        this.mousePressed = false;
        this.animating = false;
        this.calculating = false;
        this.interuptedAnimating = false;

        this.text = "";

        this.startIndex = null;
        this.endIndex = null;

        this.pathTimeouts = [];
        this.visitedTimeouts = [];

        this.handleClick = this.handleClick.bind(this);
        this.clear = this.clear.bind(this);
        this.randomize = this.randomize.bind(this);
        this.solve = this.solve.bind(this);
        this.animate = this.animate.bind(this);

        this.dims = dims;
        this.boxes = [];
        this.selectedBrush = "";

        this.setboxes = (a) => {
            this.boxes = a;
        };

        this.setselectedBrush = (a) => {
            this.selectedBrush = a;
        };

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
            this.pathTimeouts.forEach((timeout) => {
                clearTimeout(timeout);
            });

            this.visitedTimeouts.forEach((timeout) => {
                clearTimeout(timeout);
            });

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

            this.startIndex = getRandomInt(0, 4 * this.dims[0]);
            this.endIndex = getRandomInt(
                emptyBoxes.length - 4 * this.dims[0],
                emptyBoxes.length
            );

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

            this.clear();
            const graph = new Graph(this.boxes, this.dims);

            const startNode = this.boxes.find((box) => box.type === "start");
            const endNode = this.boxes.find((box) => box.type === "end");

            if (!startNode) {
                this.text = "No Start Node!";
                this.calculating = false;
                return;
            }

            if (!endNode) {
                this.text = "No End Node!";
                this.calculating = false;
                return;
            }

            const startIndex = startNode.index;
            const endIndex = endNode.index;

            let Solver = null;

            if (algorithm === "AStar") {
                Solver = new AStar(startIndex, endIndex, graph);
            }

            if (algorithm === "Dijkstra") {
                Solver = new Dijkstra(startIndex, endIndex, graph);
            }

            const target = Solver.solve();

            const path = graph.traceBack(target).slice(1, -1);
            const visited = graph.getVisited(Solver.nodes);

            this.calculating = false;

            this.animating = true;
            this.animate(visited, path);
        }
    }

    animate(visited, path) {
        this.visitedTimeouts = [];
        for (let i = 0; i < visited.length; i++) {
            this.visitedTimeouts.push(
                setTimeout(() => {
                    if (!this.interuptedAnimating) {
                        const el = document.getElementById(
                            `node-${visited[i]}`
                        );
                        this.setCSS(el, "visited");

                        if (i === visited.length - 1) {
                            this.animatePath(path);
                        }
                    }
                }, 10 * i)
            );
        }
    }

    animatePath(path) {
        this.pathTimeouts = [];

        if (path.length !== 0) {
            for (let i = 0; i < path.length; i++) {
                this.pathTimeouts.push(
                    setTimeout(() => {
                        if (!this.interuptedAnimating) {
                            const el = document.getElementById(
                                `node-${path[i]}`
                            );
                            this.setCSS(el, "path");

                            if (i === path.length - 1) {
                                this.animating = false;
                                this.interuptedAnimating = false;
                            }
                        }
                    }, 50 * i)
                );
            }
        } else {
            this.animating = false;
            this.interuptedAnimating = false;
            this.text = "";
        }
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
