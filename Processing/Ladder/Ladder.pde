float x = 200;
float y = 100;

float dx,dy;


void setup() {
   size(400, 400);
   strokeCap(PROJECT);
   
}

void draw() {
  background(100);
  
  strokeWeight(10);
  stroke(0);
  line(width-50+8,50,width-50+8,height-50);
  line(width-50+8,height-50+8,50,height-50+8);
  
  
  //Ladder
    strokeWeight(5);
  stroke(100,50,5);
  line(width-50,height-50-dy,width-50-dx,height-50);
  
  
  stroke(255,0,0);
  strokeWeight(10);
  point((width-50)-dx/2,height-50-dy/2);
  
  
  stroke(255);
  noFill();
  strokeWeight(1);
  arc(width-50,height-50,300,300,PI,1.5*PI);
  

  
  y=mouseY;
  
  dy=abs(height-50-map(mouseY,0,height,50,height-50));
  dx=sqrt(300*300-dy*dy);
  
 
  
 
   
}
