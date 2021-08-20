import React from "react";

export default function Block({ box, handleClick }) {
    const handleOnMouseDown = (e) => {
        handleClick(e.target, "down", box.index);
    };

    const handleOnMouseUp = (e) => {
        handleClick(e.target, "up", box.index);
    };

    const handleOnMouseDrag = (e) => {
        handleClick(e.target, "drag", box.index);
    };

    const style = `grid-item ${box.type} ${
        box.type === "empty" ? box.overlay : ""
    }`;

    return (
        <div
            className={style}
            onMouseDown={handleOnMouseDown}
            onMouseUp={handleOnMouseUp}
            onMouseMove={handleOnMouseDrag}
        >
            {box.symbol}
        </div>
    );
}
