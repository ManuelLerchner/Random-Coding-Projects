class square{
  float x,y,s;
  
  square(float x_, float y_ , float s_){
    x=x_;
    y=y_;
    s=s_;  
  }
  
  void show(){
    fill( map(x,0,width,0,255), map(y,0,width,0,255), map(s,0,width/n,0,255));
   noStroke();
     ellipse(x, y, s,s);
  }
  
  
}
