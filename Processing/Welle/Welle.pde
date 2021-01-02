float [] A;
float r;
float theta =0;
float f;

float n=600;

void setup() {
  size(600, 400);
  background(120);
  noFill();
  A = new float [round(n)];
    f = A.length/2;
  r=width/n;
}

void draw() {
  background(120);
  translate(0, height/2);


  line(-width/2, 0, width, 0);
  line(width/2, -height/2, width/2, height/2);
  
  stroke(255, 0, 0);
  strokeWeight(2);
  line(width/2,A[A.length/2-1], width/2, A[A.length/2+1]);
  line(width/2-r,A[A.length/2-1],width/2,A[A.length/2-1]);
  line(width/2+r,A[A.length/2+1],width/2,A[A.length/2+1]);
    
    
    fill(255,0,0);
    textSize(15);
    text("dy: " +   round((A[A.length/2-1]-A[A.length/2+1])),5,-height/2+20);
    text("angle: " +  round(theta),5,-height/2+40);
    
  strokeWeight(1);
  stroke(0);
  noFill();
  
  for (int i=0; i < A.length; i++) {
    if(i != A.length/2){
    ellipse((i)*r+r/2, A[i], r, r);
    }; 
  
    if (i<A.length/2) {
      A[i]=100*sin(radians(r*i+theta)-f);
    }else{
      A[i]=100*tan(radians(r*-i+theta+60)-f);
    }
    
    theta+=radians(r/4-(r/5)+map(mouseX,0,width,-2,2));
    
  }
}
