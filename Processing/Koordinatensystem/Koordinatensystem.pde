float xrange =2*5;
float yrange =2*5;



void setup() {
   size(900, 900);
   background(0);
   
}

void draw() {
  
Koord();
  
  
 translate(width/2,height/2);
 
 //FORMELN Rot
    
    for(float i=-width/2; i < width/2 ; i+=0.01){
       
     float x = i/(width/xrange);;
  
     float f= sin(x);
    
    stroke(255,0,0);
   point(i,(height/(yrange))*-f);
    }
 
 
 
 
 
 ////Grün
 
  for(float i=-width/2; i < width/2 ; i+=0.1){
       
   
     float x = i/(width/xrange);;
  
     float f=  sin(x-2*PI/3);
    
    
    stroke(0,255,0);
   point(i,(height/(yrange))*-f);
}

 
 ////Blau
 
  for(float i=-width/2; i < width/2 ; i+=0.1){
       
   
     float x = i/(width/xrange);;
  
     float f=  sin(x-4*PI/3);
    
    
    stroke(0,0,255);
   point(i,(height/(yrange))*-f);
}
}
