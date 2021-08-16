import { ToDoType } from "./App";

import ToDo from "./ToDo";

export default function ToDoList({
    todos,
    toggleTodo
}: {
    todos: ToDoType[];
    toggleTodo: (id: number) => void;
}) {
    return (
        <ol>
            {" "}
            {todos.map((todo: ToDoType) => {
                return (
                    <ToDo key={todo.id} toDo={todo} toggleTodo={toggleTodo} />
                );
            })}
        </ol>
    );
}
