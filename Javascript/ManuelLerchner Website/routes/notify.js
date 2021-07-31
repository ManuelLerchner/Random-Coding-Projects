const express = require("express");
const router = express.Router();

//  Get /notify
router.get("/", function (req, res) {
    res.render("notify");
});

module.exports = router;
