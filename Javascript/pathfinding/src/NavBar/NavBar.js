import React from "react";
import Selector from "./Selector";

import "../css/navbar.css";

export default function NavBar({
    randomize,
    text,
    setselectedBrush,
    solve,
    createGrid,
    clear
}) {
    const solveDijkstra = () => {
        solve("Dijkstra");
    };
    const solveAStar = () => {
        solve("AStar");
    };
    const solveBFS = () => {
        solve("BFS");
    };
    const solveDFS = () => {
        solve("DFS");
    };

    const createMaze = () => {
        createGrid("Maze");
    };

    const createEmpty = () => {
        createGrid("Empty");
    };

    const createRandom = () => {
        randomize(0.25, true);
    };

    let ErrorMsg = "";
    if (text !== "") {
        ErrorMsg = (
            <li>
                <a
                    className="waves-effect waves-light btn-large red darken-4 "
                    href="#!"
                >
                    {text}
                </a>
            </li>
        );
    }

    return (
        <div className="navbar-fixed">
            <nav>
                <div className="nav-wrapper grey darken-4">
                    <ul className="left hide-on-med-and-down">
                        <Selector setselectedBrush={setselectedBrush} />
                    </ul>

                    <ul className="right">
                        {ErrorMsg}

                        <li
                            className="dropdown-trigger  waves-effect waves-light  green darken-1"
                            data-target="dropdown1"
                        >
                            <a href="#!">
                                <span className="hide-on-small-only left">
                                    Visualize Path
                                </span>
                                <i className="material-icons right hide-on-med-and-down">
                                    emoji_objects
                                </i>
                                <i className="material-icons hide-on-med-and-up">
                                    emoji_objects
                                </i>
                            </a>
                        </li>

                        <li
                            className="waves-effect waves-light blue lighten-1"
                            onClick={clear}
                        >
                            <a href="#!">
                                <span className="hide-on-small-only left">
                                    Reset
                                </span>
                                <i className="material-icons right hide-on-med-and-down">
                                    loop
                                </i>

                                <i className="material-icons hide-on-med-and-up">
                                    loop
                                </i>
                            </a>
                        </li>

                        <li
                            className="dropdown-trigger  waves-effect waves-light orange darken-4"
                            data-target="dropdown2"
                        >
                            <a href="#!">
                                <span className="hide-on-small-only left">
                                    World Presets
                                </span>
                                <i className="material-icons right hide-on-med-and-down">
                                    public
                                </i>

                                <i className="material-icons hide-on-med-and-up">
                                    public
                                </i>
                            </a>
                        </li>
                    </ul>
                </div>
            </nav>

            <ul id="dropdown1" className="dropdown-content blue-grey darken-2 ">
                <li>
                    <a href="#!" className="white-text" onClick={solveAStar}>
                        <i className="material-icons">star</i>
                        AStar
                    </a>
                </li>
                <li>
                    <a href="#!" className="white-text" onClick={solveDijkstra}>
                        <i className="material-icons">pages</i>
                        Dijkstra
                    </a>
                </li>
                <li>
                    <a href="#!" className="white-text" onClick={solveBFS}>
                        <i className="material-icons">line_style</i>
                        BFS
                    </a>
                </li>
                <li>
                    <a href="#!" className="white-text" onClick={solveDFS}>
                        <i className="material-icons">filter_list</i>
                        DFS
                    </a>
                </li>
            </ul>

            <ul id="dropdown2" className="dropdown-content blue-grey darken-2 ">
                <li>
                    <a href="#!" className="white-text" onClick={createMaze}>
                        <i className="material-icons">grid_on</i>
                        Maze
                    </a>
                </li>
                <li>
                    <a href="#!" className="white-text" onClick={createEmpty}>
                        <i className="material-icons">
                            check_box_outline_blank
                        </i>
                        Empty
                    </a>
                </li>
                <li>
                    <a href="#!" className="white-text" onClick={createRandom}>
                        <i className="material-icons">shuffle_on</i>
                        Random
                    </a>
                </li>
            </ul>
        </div>
    );
}
