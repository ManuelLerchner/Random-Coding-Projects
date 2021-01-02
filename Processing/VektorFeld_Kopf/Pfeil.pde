class Pfeil {

  float x, y, alpha;

  Pfeil(float xt, float yt, float alphat) {

    x=xt;
    y=yt;
    alpha = alphat;
  }


  void update() {
    //strokeWeight(0.5);
    //stroke(0,100);
    //    line(x, y, mouseX, mouseY);

    pushMatrix();

    translate(x, y);

    //fill(0);
    //textSize(8);
    //text(  round(degrees(alpha)), 10, 20);




    rotate (-alpha);

    stroke(0);
    strokeWeight(1);

    line(0, 0, constrain(width/2/map(dist(x,y,px,py),0,sqrt(width*width+height*height),0,width/4/2),width/n/7,width/n/4), 0);
    stroke(degrees(alpha), 1, 1,150);
    strokeWeight(constrain(width/2/map(dist(x,y,px,py),0,sqrt(width*width+height*height),0,width/15/1),width/n/7,width/n/3)/2);
    point(constrain(width/2/map(dist(x,y,px,py),0,sqrt(width*width+height*height),0,width/4/2),width/n/7,width/n/4), 0);






    popMatrix();
  }
}
