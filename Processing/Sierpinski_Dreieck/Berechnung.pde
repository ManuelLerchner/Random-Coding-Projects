void neuerPunkt() {

  r= random(1);

  if (r<0.333333) {
    px = (px +50)/2;
    py = (py+height-50)/2;
  } else if (r<0.666666) {
    px = (px +width-50)/2;
    py = (py+height-50)/2;
  } else if (r<1){
    px = (px +width/2)/2;
    py = (py+height-50-sqrt(3)/2*(height-100))/2;
}
}
