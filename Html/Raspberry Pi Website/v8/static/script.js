var t = setInterval(blink, 750);
var empty = false;

function blink() {
    var elements = document.getElementsByClassName("toBlink");

    for (var i = 0; i < elements.length; i++) {
        var el = elements[i];
        if (empty) {
            el.innerHTML = "&gt|";
            empty;
        } else {
            el.innerHTML = "&gt";
        }
    }

    empty = !empty;
}

var e = setInterval(hightlightPassword, 750);
var toggle = false;

function hightlightPassword() {
    var elements = document.getElementsByClassName("PasswordField");

    for (var i = 0; i < elements.length; i++) {
        var el = elements[i];
        if (toggle) {
            el.placeholder = "_";
        } else {
            el.placeholder = " ";
        }
    }

    toggle = !toggle;
}

for (let index = 0; index < array.length; index++) {
    const element = array[index];
}
