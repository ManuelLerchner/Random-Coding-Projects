import React from "react";
import { ToDoType } from "./App";

export default function ToDo({
    toDo,
    toggleTodo
}: {
    toDo: ToDoType;
    toggleTodo: (id: number) => void;
}) {
    function handleToDoClick() {
        toggleTodo(toDo.id);
    }
    return (
        <li>
            <label>
                <input
                    type="checkbox"
                    className="filled-in"
                    checked={toDo.completed}
                    onChange={handleToDoClick}
                />
                <span>{toDo.name}</span>
            </label>
        </li>
    );
}
