import React from "react";
import Block from "./Block";

import { v4 as uuidv4 } from "uuid";

export default function Field({ dims, boxes, handleClick }) {
    const style = {
        gridTemplateColumns: `${"1fr ".repeat(dims[0])}`
    };

    return (
        <div className="row">
            <div className="col l10 offset-l1">
                <div className="grid-container" style={style}>
                    {boxes.map((box) => {
                        return (
                            <Block
                                key={uuidv4()}
                                box={box}
                                handleClick={handleClick}
                            />
                        );
                    })}
                </div>
            </div>
        </div>
    );
}
