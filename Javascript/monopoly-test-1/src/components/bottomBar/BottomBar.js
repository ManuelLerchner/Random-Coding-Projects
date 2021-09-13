import React from "react";
import PlayerCard from "./PlayerCard";

import "./BottomBar.css";

export default function BottomBar({ players }) {
    return (
        <div className="stickBottom">
            <div className="carousel">
                {players.map((player) => {
                    return <PlayerCard key={player} player={player} />;
                })}
            </div>
        </div>
    );
}
