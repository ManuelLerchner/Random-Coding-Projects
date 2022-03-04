const express = require("express");
var manifest = require("express-manifest");
const path = require("path");

const app = express();

app.use(
    manifest({
        manifest: path.join(__dirname, "public") + "/rev-manifest.json",
        prepend: path.join(__dirname, "public"),
        reqPathFind: /^(\/?)/,
        reqPathReplace: "",
        debug: true,
    })
);

app.use(express.static(path.join(__dirname, "public")));

app.get("/", function (req, res) {
    res.sendFile(path.join(__dirname + "/index.html"));
    //__dirname : It will resolve to your project folder.
});

app.listen(3000, () => {
    console.log("Server started on port http://localhost:3000");
});
