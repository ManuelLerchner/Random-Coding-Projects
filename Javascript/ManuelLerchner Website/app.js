const express = require("express");
const dotenv = require("dotenv");
const path = require("path");
const exphbs = require("express-handlebars");

var morgan = require("morgan");

const app = express();

//Dotenv
dotenv.config({ path: "./config/config.env" });

//Log
if (process.env.NODE_ENV === "developement") {
    app.use(morgan("dev"));
}

//BodyParser
app.use(express.urlencoded({ extended: false }));
app.use(express.json());

//Static
app.use(express.static(path.join(__dirname, "public")));

//Handlebars
app.set("view engine", "hbs");

app.engine(
    "hbs",
    exphbs({
        defaultLayout: "main",
        extname: "hbs"
    })
);

//Routes
app.use("/", require("./routes/home"));
app.use("/controller", require("./routes/controller"));
app.use("/contact", require("./routes/contact"));
app.use("/about", require("./routes/about"));

//App
PORT = process.env.PORT || 5000;

app.listen(
    PORT,
    console.log(
        `Server running in ${process.env.NODE_ENV} mode on http://localhost:${PORT}`
    )
);
