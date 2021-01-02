class Color {

  float r, g, b, a;

  Color(float r, float g, float b, float a) {
    this.r=r;
    this.g=g;
    this.b=b;
    this.a=a;
  }





  String toString() {
    return str(r)+" "+str(g)+" "+str(b)+" "+str(a);
  }
}


float blendColorValue(float a, float b, float t) {
  return sqrt((1 - t) * a*a + t * b*b);
}

float blendAlphaValue(float a, float b, float t) {
  return (1-t)*a + t*b;
}

Color rgbaSum(Color c1, Color c2, float t) {



  float r= blendColorValue(c1.r, c2.r, t);
  float g= blendColorValue(c1.g, c2.g, t);

  float b= blendColorValue(c1.b, c2.b, t);


  float a = blendAlphaValue(c1.a, c2.a, t);
  return new Color(r, g, b, a);
} 


Color mult(Color A, float s) {
  return new Color(A.r*s, A.g*s, A.b*s, A.a);
}



void fill(Color c) {
  fill(255*c.r, 255*c.g, 255*c.b, 255*c.a);
}

void stroke(Color c) {
  stroke(255*c.r, 255*c.g, 255*c.b, 255*c.a);
}
