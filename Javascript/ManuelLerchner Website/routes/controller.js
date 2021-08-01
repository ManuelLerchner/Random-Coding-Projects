const express = require("express");
const router = express.Router();

//  Get /controller
router.get("/", function (req, res) {
    res.render("controller");
});

//  Post /controller/api
router.post("/api", function (req, res) {
    console.log(req.body);
});

module.exports = router;
