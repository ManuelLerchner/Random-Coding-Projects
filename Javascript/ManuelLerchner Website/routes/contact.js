const express = require("express");
const router = express.Router();

//  Get /contact
router.get("/", function (req, res) {
    res.render("contact");
});

//  Post /contact/api
router.post("/api", function (req, res) {
    console.log(req.body);
});

module.exports = router;
