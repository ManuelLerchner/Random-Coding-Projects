const express = require("express");
const path = require("path");
const dotenv = require("dotenv");
var exphbs = require("express-handlebars");
const io = require("socket.io")(5000);

dotenv.config({ path: "./config/config.env" });
const { addMessage, readAllMessages } = require("./config/db");

app = express();

app.use(express.urlencoded({ extended: false }));
app.use(express.json());

app.engine(
    "handlebars",
    exphbs({
        helpers: {
            isNotId: function (value) {
                return value !== "_id";
            }
        }
    })
);

app.set("view engine", "handlebars");

app.use(express.static(path.join(__dirname, "public")));

let data = [];

app.get("/", (req, res) => {
    res.render("home", { data: data });
});

readAllMessages().then((res) => {
    data = res;
    app.listen(3000, () => {
        console.log("Server listening at http://manuellerchner.ddns.net:3000");
    });
});

io.on("connection", (socket) => {
    socket.on("send-chat-message", (dateTime, name, message) => {
        data.push({ dateTime, name, message });

        addMessage({ dateTime, name, message });

        socket.broadcast.emit("chat-message", { dateTime, name, message });
    });
});
