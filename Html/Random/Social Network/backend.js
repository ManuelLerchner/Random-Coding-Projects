
var name = document.getElementById("name").value;
var address = document.getElementById("address").value;
var age = document.getElementById("age").value;

$.ajax({
    type: "GET",
    url: "http://hostname/projectfolder/webservicename.php?callback=jsondata&web_name=" + name + "&web_address=" + address + "&web_age=" + age,
    crossDomain: true,
    dataType: 'jsonp',
    success: function jsondata(data) {

        var parsedata = JSON.parse(JSON.stringify(data));
        var logindata = parsedata["Status"];

        if ("sucess" == logindata) {
            alert("success");
        }
        else {
            alert("failed");
        }
    }
}); 


function println(){
    var p = document.getElementById("abc");

    p.innerHTML="213"
}
