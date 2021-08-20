import React from "react";
import Selector from "./Selector";

import "../css/navbar.css";

export default function NavBar({ randomize, setselectedBrush, solve, clear }) {
    return (
        <div className="navbar-fixed">
            <nav>
                <div className="nav-wrapper">
                    <ul className="left">
                        <Selector setselectedBrush={setselectedBrush} />
                    </ul>

                    <ul className="right hide-on-med-and-down">
                        <li>
                            <a
                                className="waves-effect waves-light btn-large"
                                href="#!"
                                onClick={randomize}
                            >
                                Randomize
                                <i className="material-icons right">shuffle</i>
                            </a>
                        </li>
                        <li>
                            <a
                                className="waves-effect waves-light btn-large"
                                href="#!"
                                onClick={solve}
                            >
                                Solve{" "}
                                <i className="material-icons right">
                                    emoji_objects
                                </i>
                            </a>
                        </li>

                        <li>
                            <a
                                className="waves-effect waves-light btn-large"
                                href="#!"
                                onClick={clear}
                            >
                                Clear
                                <i className="material-icons right">
                                    format_color_reset
                                </i>{" "}
                            </a>
                        </li>
                    </ul>
                </div>
            </nav>
        </div>
    );
}
