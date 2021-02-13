float[] matmul(float[][] mat, float[] vec) {
  float[] out=new float[mat.length];
  for (int i=0; i < mat.length; i++) {
    for (int j=0; j < mat[0].length; j++) {
      out[i]+=mat[i][j]*vec[j];
    }
  }
  return out;
}






float[] projectDown(float[] in) {

  float w =120/(160-in[3]);


  float projection4x3[][]={
    {w, 0, 0, 0}, 
    {0, w, 0, 0}, 
    {0, 0, w, 0}, 
  };



  float dist=300;
  float fac=dist/(260+in[2]);

  //println(in[2]);
  fac=1;

  float unity3x2[][]={
    {fac, 0, 0}, 
    {0, fac, 0}, 
  };



  float out[]=in;
  out=matmul(projection4x3, out);
  //out=matmul(unity3x2, out);
  return out;
}




float rotXY[][], rotXZ[][], rotZW[][];

float alpha_z=0.6;
float alpha_y=0;

void setRotations() {
  //alpha_z+=ds/5;
  alpha_y-=ds;


  rotXY= new float[][]{
    {cos(alpha_y), sin(alpha_y), 0, 0}, 
    {-sin(alpha_y), cos(alpha_y), 0, 0}, 
    {0, 0, 1, 0}, 
    {0, 0, 0, 1}, 
  };

  rotXZ= new float[][]{
    {cos(alpha_z), 0, -sin(alpha_z), 0}, 
    {0, 1, 0, 0}, 
    {sin(alpha_z), 0, cos(alpha_z), 0}, 
    {0, 0, 0, 1}, 
  };

  rotZW=new float[][]{
    {1, 0, 0, 0}, 
    {0, 1, 0, 0}, 
    {0, 0, cos(alpha_y), -sin(alpha_y)}, 
    {0, 0, sin(alpha_y), cos(alpha_y)}, 
  };
}



void connect(int a, int b) {
  line(projected[a][0], projected[a][1], projected[a][2], projected[b][0], projected[b][1], projected[b][2]);
}
