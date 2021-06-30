const express = require("express");
var fs = require("fs");
var request = require("request");

var download = function (uri, filename, callback) {
    request.head(uri, function (err, res, body) {
        request(uri).pipe(fs.createWriteStream(filename)).on("close", callback);
    });
};

app = express();

app.get("/", (req, res) => {
    console.log("rest");
    download("http://192.168.0.189:8080/video/jpeg", "google.jpeg", () => {
        console.log("downloaded");
    });
    res.send(200);
});

app.listen(3000, () => {
    console.log("started");
});
