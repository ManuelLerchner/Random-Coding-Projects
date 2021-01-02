float s=0.1;
int rc =255;
int gc =255;
int bc =255;
int pv;

float px;
float py;


void setup() {
  size(600, 600);
  background(10);
  px=width/2;
  py=height/2;
  noFill();
}

void draw() {

 

for(int i=0; i < 10000; i++){
   
  strokeWeight(s);
  stroke(rc, gc, bc);
    newPoint();
  point(px, py);

}

if(mousePressed){
  
  background(10);
}
}
