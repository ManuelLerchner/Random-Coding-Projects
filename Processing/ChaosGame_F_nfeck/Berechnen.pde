void newPoint () {
  float r = random(1);

  if (r<0.2 && pv !=1) {
    px=(px+14.6830)/2;
    py =(py+215.5899)/2;
    pv=1;
    
    rc = 255;
    gc = 0;
    bc = 0;
    
  } else if (r<0.4 && pv !=2) {
    px=(px+123.6644)/2;
    py =(py+height-50)/2;
    pv=2;
    
    rc = 0;
    gc = 255;
    bc = 0;
    
  } else if (r<0.6 && pv !=3) {
    px=(px+width-123.6644)/2;
    py =(py+height-50)/2;
    pv=3;
    
    rc = 0;
    gc = 0;
    bc = 255;
   
  } else if (r<0.8 && pv !=4) {
    px=(px+width-13.6830)/2;
    py =(py+214.5899)/2;
    pv=4;
    
    rc = 255;
    gc = 255;
    bc = 0;
    
  } else if (r<1 && pv !=5) {
    px=(px+width/2)/2;
    py =(py+7.2949)/2;
    pv=5;
    
    rc = 0;
    gc = 255;
    bc = 255;
    
  }
}
