import React from "react";
import Selector from "./Selector";

import "../css/navbar.css";

export default function NavBar({
    randomize,
    text,
    setselectedBrush,
    solve,
    clear
}) {
    const solveDijkstra = () => {
        solve("Dijkstra");
    };
    const solveAStar = () => {
        solve("AStar");
    };

    let ErrorMsg = "";
    if (text !== "") {
        ErrorMsg = (
            <li>
                <a
                    className="waves-effect waves-light btn-large red darken-4"
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
                <div className="nav-wrapper">
                    <ul className="left hide-on-med-and-down">
                        <Selector setselectedBrush={setselectedBrush} />
                    </ul>

                    <ul className="right">
                        {ErrorMsg}
                        <li>
                            <a
                                className="waves-effect waves-light btn-large orange darken-4"
                                href="#!"
                                onClick={randomize}
                            >
                                Randomize
                                <i className="material-icons right">
                                    shuffle_on
                                </i>
                            </a>
                        </li>
                        <li>
                            <a
                                className="dropdown-trigger  waves-effect waves-light btn-large green darken-1"
                                href="#!"
                                data-target="dropdown1"
                            >
                                Solve
                                <i className="material-icons right">
                                    emoji_objects
                                </i>
                            </a>

                            <ul
                                id="dropdown1"
                                className="dropdown-content blue-grey darken-4 "
                            >
                                <li>
                                    <a
                                        href="#!"
                                        className="white-text"
                                        onClick={solveDijkstra}
                                    >
                                        <i className="material-icons">
                                            view_module
                                        </i>
                                        Dijkstra
                                    </a>
                                </li>
                                <li>
                                    <a
                                        href="#!"
                                        className="white-text"
                                        onClick={solveAStar}
                                    >
                                        <i className="material-icons">
                                            view_module
                                        </i>
                                        AStar
                                    </a>
                                </li>
                            </ul>
                        </li>

                        <li>
                            <a
                                className="waves-effect waves-light btn-large"
                                href="#!"
                                onClick={clear}
                            >
                                Reset
                                <i className="material-icons right">
                                    loop
                                </i>{" "}
                            </a>
                        </li>
                    </ul>
                </div>
            </nav>
        </div>
    );
}
