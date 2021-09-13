import React from "react";

import AddPlayersForm from "../components/home/AddPlayersForm";
import Logo from "../components/home/Logo";

export default function Home({  setPlayers }) {
    return (
        <>
            <Logo />
            <AddPlayersForm setPlayers={setPlayers} />
        </>
    );
}
