void Koord(){
  
  background(0);
  
  //Axis
  pushMatrix();
  translate(width/2,height/2);
  stroke(255);
    strokeWeight(3);
  line(0,height/2,0,-height/2);
  line(width/2,0,-width,0);
  popMatrix();
  
  strokeWeight(1);
  stroke(180,120,20,40-(xrange*yrange)/300);
  
  
  //Grid
  for(int i=0; i < xrange*yrange; i+=1){
    
  line(0,i*height/yrange,width,i*height/yrange);
    line(i*width/xrange,0,i*width/xrange,height);
 
   
  }
   
  
}
