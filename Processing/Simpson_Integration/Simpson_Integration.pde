
void setup() {


  println("res1: "+simpson_2(0, 1, 4));






  exit();
}

void draw() {
}




double simpson_1(double a, double b, int n) {

  double deltaX=(b-a)/(n*2);
  double sum=0;

  sum+=f(a);
  sum+=f(b);

  for (int i=1; i <= n*2-1; i++) {

    double x=deltaX*i+a;

    if (i%2==0) {
      sum+=2*f(x);
    } else {
      sum+=4*f(x);
    }
  }

  return sum *(b-a)/(6*n);
}



double simpson_2(double a, double b, int n) {

  double sum=0;
  double deltaX= (b-a)/(2*n);

  for (int i=0; i <= n-1; i+=1) {

    double x_0= deltaX*(2*i)+a;
    double x_1= deltaX*(2*i+1)+a;
    double x_2= deltaX*(2*i+2)+a;

    sum+= f(x_0);
    sum+= 4*f(x_1);
    sum+= f(x_2);
  }


  return sum*(b-a)/(6*n);
}




double f(double x) {
  return Math.sqrt(x)*Math.exp(x*x);
}
