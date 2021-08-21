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
                    className="waves-effect waves-light btn-large red darken-4 hide-on-small-only"
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
                        <li>
                            <a
                                className="waves-effect waves-light btn-large orange darken-4"
                                href="#!"
                                onClick={randomize}
                            >
                                <span className="hide-on-small-only left">
                                    Randomize
                                </span>
                                <i className="material-icons right hide-on-med-and-down">
                                    shuffle_on
                                </i>
                                <i className="material-icons hide-on-med-and-up">
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
                                <span className="hide-on-small-only left">
                                    Solve
                                </span>

                                <i className="material-icons right hide-on-med-and-down">
                                    emoji_objects
                                </i>
                                <i className="material-icons hide-on-med-and-up">
                                    emoji_objects
                                </i>
                            </a>

                            <ul
                                id="dropdown1"
                                className="dropdown-content blue-grey darken-2 "
                            >
                                <li>
                                    <a
                                        href="#!"
                                        className="white-text"
                                        onClick={solveDijkstra}
                                    >
                                        <i className="material-icons">pages</i>
                                        Dijkstra
                                    </a>
                                </li>
                                <li>
                                    <a
                                        href="#!"
                                        className="white-text"
                                        onClick={solveAStar}
                                    >
                                        <i className="material-icons">star</i>
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
                    </ul>
                </div>
            </nav>
        </div>
    );
}
