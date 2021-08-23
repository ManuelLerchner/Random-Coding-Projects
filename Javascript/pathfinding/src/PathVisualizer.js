import { Graph } from "./Solver/Graph";
import React, { Component } from "react";

import NavBar from "./NavBar/NavBar";
import Field from "./Game/Field";

import Dijkstra from "./Solver/Dijkstra";
import AStar from "./Solver/AStar";
import BFS from "./Solver/BFS";
import DFS from "./Solver/DFS";
import SelectorSmall from "./NavBar/SelectorSmall";

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
    constructor() {
        super();

        this.mousePressed = false;
        this.animating = false;
        this.calculating = false;

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
        this.animateWalls = this.animateWalls.bind(this);
        this.setGridDims = this.setGridDims.bind(this);
        this.createGrid = this.createGrid.bind(this);

        this.randomize(0.25, true);
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

            clearInterval(this.wallInterval);

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
    randomize(wallProbability, setStartEnd) {
        if (this.animating === false) {
            const emptyBoxes = Array.from(
                { length: this.dims[0] * this.dims[1] },
                (_, i) => {
                    return new BlockClass(i);
                }
            );

            for (
                let i = 0;
                i < Math.floor(emptyBoxes.length * wallProbability);
                i++
            ) {
                emptyBoxes[getRandomInt(0, emptyBoxes.length)].type = "wall";
            }

            if (setStartEnd) {
                this.startIndex =
                    getRandomInt(1, 4) * this.dims[0] +
                    getRandomInt(0, Math.ceil(this.dims[0] / 2));

                this.endIndex =
                    emptyBoxes.length -
                    getRandomInt(1, 4) * this.dims[0] -
                    getRandomInt(0, Math.ceil(this.dims[0] / 2));

                emptyBoxes[this.startIndex].type = "start";
                emptyBoxes[this.endIndex].type = "end";
            }

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

            let Solver = null;

            switch (algorithm) {
                case "AStar":
                    Solver = new AStar(startNode, endNode, graph);
                    break;
                case "Dijkstra":
                    Solver = new Dijkstra(startNode, endNode, graph);
                    break;
                case "BFS":
                    Solver = new BFS(startNode, endNode, graph);
                    break;
                case "DFS":
                    Solver = new DFS(startNode, endNode, graph);
                    break;
                default:
                    break;
            }

            const target = Solver.solve();

            const path = graph.traceBack(target);
            const visited = graph.getVisited(Solver.nodes);

            var tEnd = performance.now();

            this.calculating = false;

            const timeTaken = tEnd - tStart;

            this.text = (
                <>
                    <span className="left">
                        {Math.round(timeTaken * 100) / 100} ms
                    </span>

                    <i className="material-icons right hide-on-med-and-down">
                        timer
                    </i>
                </>
            );
            this.setState({ state: this.state });

            this.animating = true;
            this.animate(visited, path);
        }
    }

    animate(visited, path) {
        if (visited.length !== 0) {
            this.visitedInterval = setInterval(
                animate.bind(this),
                15 + 300 / this.dims[0]
            );

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
            this.pathInterval = setInterval(
                animate.bind(this),
                80 + 300 / this.dims[0]
            );

            var iterations = 1;
            function animate() {
                const el = document.getElementById(`node-${path[iterations]}`);
                this.setCSS(el, "path");

                if (iterations === path.length - 2) {
                    this.animating = false;
                }

                if (iterations === path.length - 2)
                    clearInterval(this.pathInterval);

                iterations++;
            }
        } else {
            this.animating = false;
            this.text = "";
        }
    }

    animateWalls(walls, emptyBoxes) {
        if (walls.length !== 0) {
            this.wallInterval = setInterval(
                animate.bind(this),
                15 + 200 / this.dims[0]
            );

            var iterations = 0;
            function animate() {
                const el = document.getElementById(`node-${walls[iterations]}`);
                this.setCSS(el, "wall");

                if (iterations === walls.length - 1) {
                    clearInterval(this.wallInterval);
                    this.startIndex = this.vectorToIndex(1, 1);
                    this.endIndex = this.vectorToIndex(
                        this.dims[0] - 2,
                        this.dims[1] - 2
                    );
                    emptyBoxes[this.startIndex].type = "start";
                    emptyBoxes[this.endIndex].type = "end";

                    this.setboxes(emptyBoxes);
                    this.animating = false;
                    this.setState({ state: this.state });
                }
                iterations++;
            }
        } else {
            this.animating = false;
        }
    }

    setGridDims() {
        const dimensions = getWindowDimensions();

        const ratio = dimensions.width / dimensions.height;

        this.dims = [
            Math.round(dimensions.width / 40),
            Math.round(dimensions.width / 42 / ratio)
        ];

        if (this.dims[0] % 2 === 0) {
            this.dims[0]++;
        }

        if (this.dims[1] % 2 === 0) {
            this.dims[1]++;
        }
    }

    indexToVector(index) {
        const x = index % this.dims[0];
        const y = index / this.dims[0];
        return [x, y];
    }

    vectorToIndex(x, y) {
        const index = y * this.dims[0] + x;
        return index;
    }

    addOuterWalls(emptyBoxes, dims, walls) {
        for (var i = 0; i < dims[0]; i++) {
            if (i === 0 || i === dims[0] - 1) {
                for (var j = 0; j < dims[1]; j++) {
                    emptyBoxes[this.vectorToIndex(i, j)].type = "wall";
                    walls.push(this.vectorToIndex(i, j));
                }
            } else {
                emptyBoxes[this.vectorToIndex(i, 0)].type = "wall";
                emptyBoxes[this.vectorToIndex(i, dims[1] - 1)].type = "wall";
                walls.push(this.vectorToIndex(i, 0));
                walls.push(this.vectorToIndex(i, dims[1] - 1));
            }
        }
    }

    addInnerWalls(emptyBoxes, h, minX, maxX, minY, maxY, walls) {
        if (h) {
            if (maxX - minX < 2) {
                return;
            }

            var y = Math.floor(randomNumber(minY, maxY) / 2) * 2;
            this.addHWall(emptyBoxes, minX, maxX, y, walls);

            this.addInnerWalls(emptyBoxes, !h, minX, maxX, minY, y - 1, walls);
            this.addInnerWalls(emptyBoxes, !h, minX, maxX, y + 1, maxY, walls);
        } else {
            if (maxY - minY < 2) {
                return;
            }

            var x = Math.floor(randomNumber(minX, maxX) / 2) * 2;
            this.addVWall(emptyBoxes, minY, maxY, x, walls);

            this.addInnerWalls(emptyBoxes, !h, minX, x - 1, minY, maxY, walls);
            this.addInnerWalls(emptyBoxes, !h, x + 1, maxX, minY, maxY, walls);
        }
    }

    addHWall(emptyBoxes, minX, maxX, y, walls) {
        var hole = Math.floor(randomNumber(minX, maxX) / 2) * 2 + 1;

        for (var i = minX; i <= maxX; i++) {
            const index = this.vectorToIndex(i, y);
            if (i !== hole) {
                emptyBoxes[index].type = "wall";
                walls.push(index);
            } else {
                emptyBoxes[index].type = "empty";
            }
        }
    }

    addVWall(emptyBoxes, minY, maxY, x, walls) {
        var hole = Math.floor(randomNumber(minY, maxY) / 2) * 2 + 1;

        for (var i = minY; i <= maxY; i++) {
            const index = this.vectorToIndex(x, i);
            if (i !== hole) {
                emptyBoxes[index].type = "wall";
                walls.push(index);
            } else {
                emptyBoxes[this.vectorToIndex(x, i)].type = "empty";
            }
        }
    }

    createMaze() {
        const emptyBoxes = Array.from(
            { length: this.dims[0] * this.dims[1] },
            (_, i) => {
                return new BlockClass(i);
            }
        );

        let walls = [];

        this.addOuterWalls(emptyBoxes, this.dims, walls);

        this.addInnerWalls(
            emptyBoxes,
            false,
            1,
            this.dims[0] - 2,
            1,
            this.dims[1] - 2,
            walls
        );

        emptyBoxes.forEach((box) => {
            if (box.type === "empty") {
                walls = walls.filter((index) => index !== box.index);
            }
        });

        this.animating = true;
        this.animateWalls(walls, emptyBoxes);
    }

    createGrid(type) {
        if (this.animating === false) {
            switch (type) {
                case "Empty":
                    this.randomize(0, true);
                    break;

                case "Maze":
                    this.randomize(0, false);
                    this.createMaze();
                    break;

                default:
                    break;
            }
        }
    }

    render() {
        return (
            <div className="App">
                <NavBar
                    solve={this.solve}
                    createGrid={this.createGrid}
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

                <SelectorSmall setselectedBrush={this.setselectedBrush} />
            </div>
        );
    }
}

function getRandomInt(min, max) {
    min = Math.ceil(min);
    max = Math.floor(max);
    return Math.floor(Math.random() * (max - min)) + min;
}

function randomNumber(min, max) {
    return Math.floor(Math.random() * (max - min + 1) + min);
}
