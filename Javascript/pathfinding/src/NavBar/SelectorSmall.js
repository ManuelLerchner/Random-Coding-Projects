import React from "react";

export default function Selector({ setselectedBrush }) {
    function handleChange(e) {
        setselectedBrush(e.target.className);
    }

    return (
        <form className="drawSelector centered container hide-on-large-only">
            <div>
                <label htmlFor="wallS">
                    <input
                        type="radio"
                        name="selector"
                        className="wall"
                        id="wallS"
                        value="wall"
                        onChange={handleChange}
                    />
                    <i className="large material-icons md-40  green-text text-accent-1">
                        dashboard
                    </i>
                </label>
            </div>

            <div>
                <label htmlFor="emptyS">
                    <input
                        type="radio"
                        name="selector"
                        className="empty"
                        id="emptyS"
                        value="empty"
                        onChange={handleChange}
                    />
                    <i className="large material-icons md-40  green-text text-accent-1">
                        check_box_outline_blank
                    </i>
                </label>
            </div>

            <div>
                <label htmlFor="startS">
                    <input
                        type="radio"
                        name="selector"
                        className="start"
                        id="startS"
                        value="start"
                        onChange={handleChange}
                    />
                    <i className="large material-icons md-40  green-text text-accent-1">
                        double_arrow
                    </i>
                </label>
            </div>

            <div>
                <label htmlFor="endS">
                    <input
                        type="radio"
                        name="selector"
                        className="end"
                        id="endS"
                        value="end"
                        onChange={handleChange}
                    />
                    <i className="large material-icons md-40 green-text text-accent-1">
                        sports_score
                    </i>
                </label>
            </div>
        </form>
    );
}
