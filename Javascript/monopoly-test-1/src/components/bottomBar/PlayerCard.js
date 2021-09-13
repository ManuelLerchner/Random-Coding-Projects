import React from "react";

import "./PlayerCard.css";

export default function PlayerCard({ player }) {
    return (
        <div className="carousel-item">
            <div className="playerCard">
                <p>{player}</p>
            </div>
        </div>
    );
}
