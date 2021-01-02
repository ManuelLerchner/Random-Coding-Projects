float x = 0;
float y = 0;
float r;
float t=0;

float g = 0.01;
float m =200;

float xp=0;
float yp=0;

void setup(){
  size(500,500);
  background(100); 
  frameRate(1000);
}

void draw(){
  
  translate(250,250);
 
 //Umwandlung Pol-Kart
x=r*cos(radians(t));
y=r*sin(radians(t));


//Zeichnen
  stroke(255,100,255,50);
  strokeWeight(1);
line(x,y,xp,yp);
stroke(255,165,0);
strokeWeight(2);
point(x,y);

//Kordinatensystem
 stroke(0);
 strokeWeight(0.5);
   line(-width/2,0,width/2,0);
   line(0,-height/2,0,height/2);
   
   
 //Funktion von t
 t=radians(t);
 
 r=m*(     sin(tan(t))        );
 
 t=degrees(t);

//Winkel ++
t+=g;
if(t>360){
t=0;
background(100);
};

//XY Prev
xp=x;
yp=y;
}
