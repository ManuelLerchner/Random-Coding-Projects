import React from "react";

export default function Selector({ setselectedBrush }) {
    function handleChange(e) {
        setselectedBrush(e.target.id);
    }

    return (
        <>
            <form className="drawSelector">
                <div>
                    <label htmlFor="wall">
                        <input
                            type="radio"
                            name="selector"
                            className="wall"
                            id="wall"
                            value="wall"
                            onChange={handleChange}
                        />
                        <i className="large material-icons md-40  green-text text-accent-1">
                            dashboard
                        </i>
                    </label>
                </div>

                <div>
                    <label htmlFor="empty">
                        <input
                            type="radio"
                            name="selector"
                            className="empty"
                            id="empty"
                            value="empty"
                            onChange={handleChange}
                        />
                        <i className="large material-icons md-40  green-text text-accent-1">
                            check_box_outline_blank
                        </i>
                    </label>
                </div>

                <div>
                    <label htmlFor="start">
                        <input
                            type="radio"
                            name="selector"
                            className="start"
                            id="start"
                            value="start"
                            onChange={handleChange}
                        />
                        <i className="large material-icons md-40  green-text text-accent-1">
                            double_arrow
                        </i>
                    </label>
                </div>

                <div>
                    <label htmlFor="end">
                        <input
                            type="radio"
                            name="selector"
                            className="end"
                            id="end"
                            value="end"
                            onChange={handleChange}
                        />
                        <i className="large material-icons md-40 green-text text-accent-1">
                            sports_score
                        </i>
                    </label>
                </div>
            </form>
        </>
    );
}
