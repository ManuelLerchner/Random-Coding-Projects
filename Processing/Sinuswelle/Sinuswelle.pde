float x=0;
float y=0;
//
int n = 10;
int r = 8;
//
float theta = 0;
float [] A;

void setup() {
  size(600, 400);
  background(0);
  A = new float [width/n+r];
}

void draw() {
     background(0);
        
      translate(-40, height/2);
       YWert();
        noFill();
        
        //Zeichnen
        for (int i = 0; i< A.length-1; i++) {
          fill(255);
          ellipse(i*n, -A[i], r, r);
          ellipse((i*n)+4*n, -A[i], r, r);
          
          //Verbindung
          stroke(255);
          line((n*i)+4*n, -A[i], (n*(i+1)+4*n), -A[i+1]);
          line(n*i, -A[i], n*(i+1), -A[i+1]);
        
          line(n*(i+5), -A[i+1], n*(i+1), -A[i+1]);
          line(n*i, -A[i], n*(i+5), -A[i+1]); 
        }
 }

void YWert() {

  theta += 1;
  for (int i=0; i< A.length; i++) {

    A[i]= sin(radians(theta+i*10))*100;
  }
}
