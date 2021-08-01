const express = require("express");
const router = express.Router();

//  Get /notify
router.get("/", function (req, res) {
    res.render("contact");
});

//  Post /notify/api
router.post("/api", function (req, res) {
    console.log(req.body);
});

module.exports = router;
