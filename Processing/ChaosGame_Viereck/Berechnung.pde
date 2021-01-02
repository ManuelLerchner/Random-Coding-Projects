void NeuerPunkt() {

  float r = random(1);

  if (r<0.25 && pv!=4 ) {
    px = (50+px)/2;
    py = (50+py)/2;
    pv=1;

    rc = 255;
    gc = 0;
    bc = 0;
  } else if (r<0.5 && pv!=3) {
    px = (width-50+px)/2;
    py = (50+py)/2;
    pv=2;

    rc = 0;
    gc = 255;
    bc = 0;
  } else if (r<0.75 && pv!=2) {
    px = (50+px)/2;
    py = (height-50+py)/2;
    pv=3;

    rc = 0;
    gc = 0;
    bc = 255;
  } else  if (r<1 && pv!=1) {
    px = (width-50+px)/2;
    py = (height-50+py)/2;
    pv=4;

    rc = 255;
    gc = 255;
    bc = 255;
  }
}
