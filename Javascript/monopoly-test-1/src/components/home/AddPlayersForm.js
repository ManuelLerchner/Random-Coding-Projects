import React, { useRef } from "react";

import "./AddPlayersForm.css";

export default function AddPlayersForm({ setPlayers }) {
    const nameRef = useRef();

    const handleSubmit = (evt) => {
        evt.preventDefault();
        const name = nameRef.current.value;

        setPlayers((prevPlayers) => {
            return [...prevPlayers, name];
        });

        setTimeout(function () {
            try {
                var elems = document.querySelectorAll(".carousel");

                // eslint-disable-next-line no-undef
                M.Carousel.init(elems, {
                    dist: -10,
                    padding: 100,
                    numVisible: 10
                });
            } catch (e) {
                console.log();
            }
        }, 0);

        nameRef.current.value = "";
    };

    return (
        <div className="row">
            <div className="col l4 offset-l4 m8 offset-m2 s12">
                <div className="card blue-grey darken-3 ">
                    <div className="card-content white-text">
                        {/*Title */}
                        <div className="section">
                            <div className="card-title orange-text center">
                                Add Players!
                            </div>
                        </div>

                        {/*Name Input */}

                        <div className="row">
                            <form className="col s12 " onSubmit={handleSubmit}>
                                <div className="row">
                                    <div className="input-field col s12">
                                        {/*Icon  */}

                                        <div className="input-field col s8">
                                            <i className="material-icons prefix">
                                                sentiment_satisfied
                                            </i>

                                            <select
                                                className="icons "
                                                defaultValue="desc"
                                            >
                                                <option value="desc" disabled>
                                                    Choose Icon
                                                </option>
                                                <option
                                                    value=""
                                                    data-icon="images/sample-1.jpg"
                                                >
                                                    example 1
                                                </option>
                                                <option
                                                    value=""
                                                    data-icon="images/office.jpg"
                                                >
                                                    example 2
                                                </option>
                                                <option
                                                    value=""
                                                    data-icon="images/yuna.jpg"
                                                >
                                                    example 3
                                                </option>
                                            </select>
                                        </div>
                                    </div>
                                </div>

                                <div className="row">
                                    {/*Name  */}
                                    <div className="input-field col s12">
                                        <div className="col s8">
                                            <i className="material-icons prefix">
                                                edit
                                            </i>
                                            <input
                                                id="icon_prefix"
                                                type="text"
                                                className="validate"
                                                ref={nameRef}
                                            />
                                            <label htmlFor="icon_prefix">
                                                Name
                                            </label>
                                        </div>

                                        {/*Add */}
                                        <div className="input-field col s1">
                                            <button
                                                className="btn waves-effect waves-light"
                                                type="submit"
                                                name="action"
                                            >
                                                Add!
                                            </button>
                                        </div>
                                    </div>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    );
}
