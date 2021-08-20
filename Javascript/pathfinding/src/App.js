import { useEffect, useState } from "react";
import Field from "./Game/Field";

import NavBar from "./NavBar/NavBar";

import { PathVisualizer } from "./PathVisualizer";

function App() {
    const [dims, setdims] = useState([50, 25]);
    const [boxes, setboxes] = useState([]);
    const [selectedBrush, setselectedBrush] = useState("");

    const AStar = new PathVisualizer(
        dims,
        setdims,
        boxes,
        setboxes,
        selectedBrush
    );

    //Initialize
    useEffect(() => {
        AStar.randomize();
        // eslint-disable-next-line react-hooks/exhaustive-deps
    }, []);

    return (
        <div className="App">
            <NavBar
                solve={AStar.solve}
                randomize={AStar.randomize}
                setselectedBrush={setselectedBrush}
                clear={AStar.clear}
            />
            <Field dims={dims} boxes={boxes} handleClick={AStar.handleClick} />
        </div>
    );
}

export default App;
