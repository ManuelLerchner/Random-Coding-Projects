const express = require("express");
const dotenv = require("dotenv");
const path = require("path");
const exphbs = require("express-handlebars");

const app = express();

//Dotenv
dotenv.config({ path: "./config/config.env" });

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
app.use("/", require("./routes/main"));

//App
PORT = process.env.PORT || 5000;

app.listen(
    PORT,
    console.log(
        `Server running in ${process.env.NODE_ENV} mode on http://localhost:${PORT}`
    )
);
