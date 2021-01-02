void neuerPunkt() {

  r= random(1);

  if (r<0.3333) {
    px = (px +50)/2;
    py = (py+height-50)/2;
  } else if (r<0.6666) {
    px = (px +width-50)/2;
    py = (py+height-50)/2;
  } else if (r<1){
    px = (px +width/2)/2;
    py = (py+height-50-sqrt(3)/2*(height-100))/2;
}
}
