
var t = setInterval(blink, 750);
var empty = false;

function blink() {
    var elements = document.getElementsByClassName("toBlink");

    for (var i = 0; i < elements.length; i++) {
        var el = elements[i];
        if (empty) {
            el.innerHTML = ">|"
            empty
        } else {
            el.innerHTML = ">"
        }
    }

    empty = !empty;

}



var e = setInterval(hightlightPassord, 750);
var toggle = false;

function hightlightPassord() {
    var elements = document.getElementsByClassName("PasswordField");

    for (var i = 0; i < elements.length; i++) {
        var el = elements[i];
        if (toggle) {
            el.placeholder = "_";
        } else {
            el.placeholder = " "
        }
        

    }

    toggle = !toggle;

}

