import React, { useState } from "react";
import Home from "./Home";

import BottomBar from "../components/bottomBar/BottomBar";

import "./App.css";
import Navbar from "../components/Navbar";

export default function App() {
    let [players, setPlayers] = useState([]);

    return (
        <header className="App-header">
            <Navbar />
            <Home players={players} setPlayers={setPlayers} />

            <BottomBar players={players} />
        </header>
    );
}
