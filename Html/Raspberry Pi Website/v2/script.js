let currLink="empty";

function show(id) {
//Highlight Current Location
  document.getElementById(currLink).classList.remove("selected");
  currLink=id+"Link";
  document.getElementById(currLink).classList.add("selected");

//Update Main
  document.getElementById("main").innerHTML =  document.getElementById(id).innerHTML; 
}

