const socket = io("http://manuellerchner.ddns.net:5000", { transports: ["websocket"] });

const messageForm = document.getElementById("Submit-Form");
const nameInput = document.getElementById("Name-Input");
const messageInput = document.getElementById("Message-Input");

const messageTable = document.getElementById("message-table");

socket.on("chat-message", ({ dateTime, name, message }) => {
    appendMessage(dateTime, name, message);
});

messageForm.addEventListener("submit", (e) => {
    e.preventDefault();
    const name = nameInput.value;
    const message = messageInput.value;

    date = new Date();

    weekdayNames = [
        "Sonntag",
        "Montag",
        "Dienstag",
        "Mittwoch",
        "Donnerstag",
        "Freitag",
        "Samstag"
    ];
    monthNames = [
        "Januar",
        "Februar",
        "März",
        "April",
        "Mai",
        "Juni",
        "Juli",
        "August",
        "September",
        "Oktober",
        "November",
        "Dezember"
    ];
    var dateTime =
        weekdayNames[date.getDay()] +
        " " +
        date.getDate() +
        " " +
        monthNames[date.getMonth()] +
        " " +
        date.getFullYear() +
        ", " +
        date.getHours() +
        ":" +
        ("00" + date.getMinutes()).slice(-2) +
        ":" +
        ("00" + date.getSeconds()).slice(-2);

    console.log(dateTime, name, message);

    appendMessage(dateTime, name, message);
    socket.emit("send-chat-message", dateTime, name, message);

    messageInput.value = "";
    nameInput.value = "";
});

function appendMessage(dateTime, name, message) {
    var row = messageTable.insertRow(-1);

    var cell1 = row.insertCell(0);
    var cell2 = row.insertCell(1);
    var cell3 = row.insertCell(2);

    cell1.innerHTML = dateTime;
    cell2.innerHTML = name;
    cell3.innerHTML = message;
}
