import { useState, useRef, useEffect } from "react";
import ToDoList from "./ToDoList";

import { v4 as uuidv4 } from "uuid";

const LOCAL_STORAGE_KEY = "toDoApp.todos";

export type ToDoType = {
    id: number;
    name: String;
    completed: boolean;
};

function App() {
    const [todos, setTodos] = useState<ToDoType[]>([]);

    const toDoNameRef = useRef<HTMLInputElement>(null);

    useEffect(() => {
        const storedTodos = JSON.parse(
            localStorage.getItem(LOCAL_STORAGE_KEY) || "[]"
        );
        if (storedTodos) {
            setTodos(storedTodos);
        }
    }, []);

    useEffect(() => {
        localStorage.setItem(LOCAL_STORAGE_KEY, JSON.stringify(todos));
    }, [todos]);

    function toggleTodo(id: number) {
        const newTodos = [...todos];
        const todo = newTodos.find((todo: ToDoType) => todo.id === id);
        if (todo) {
            todo.completed = !todo.completed;
            setTodos(newTodos);
        }
    }

    function clearTodo() {
        const newTodos = todos.filter(
            (todo: ToDoType) => todo.completed === false
        );
        setTodos(newTodos);
    }

    function handleAddTodo() {
        const nameElement = toDoNameRef.current;
        if (nameElement) {
            const name = nameElement.value;

            if (name === "") return;
            setTodos((prevTodos: any) => {
                return [
                    ...prevTodos,
                    { id: uuidv4(), name: name, completed: false }
                ];
            });
            nameElement.value = "";
        }
    }

    return (
        <div className="container">
            <ToDoList todos={todos} toggleTodo={toggleTodo} />
            <input ref={toDoNameRef} type="text" />
            <button
                className="btn-flat btn-large waves-effect waves-light green"
                onClick={handleAddTodo}
            >
                Add Todo
            </button>
            <button
                className="btn-flat btn-large waves-effect waves-light red"
                onClick={clearTodo}
            >
                Clear Checked Todos
            </button>
            <div>
                {todos.filter((todo) => !todo.completed).length} left to do
            </div>
        </div>
    );
}

export default App;
