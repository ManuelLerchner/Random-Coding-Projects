void CalcCenterOfMass() {
  SumX = 0;
  SumY = 0;
  float numA  = 0; 
  for (int i=0; i<grid; i++) {
    for (int j=0; j<grid; j++) {
      float currentCell=result[i+j*grid]/255.0;
      if (currentCell!=0) {
        SumX+= i*currentCell;
        SumY+= j*currentCell; 
        numA+=currentCell;
      }
    }
  }
  SumX = SumX / numA;
  SumY = SumY / numA;
}


void CenterImage() {
  int dx=round(SumX-grid/2);
  int dy=round(SumY-grid/2);
  float[] translated=new float[grid*grid];
  for (int i=0; i < grid; i++) {
    for (int j=0; j < grid; j++) {
      if (drawArray[i+j*grid]!=0) {
        if ((i-dx)+(j-dy)*grid>=0 && (i-dx)+(j-dy)*grid<grid*grid-1) {
          translated[(i-dx)+(j-dy)*grid]=drawArray[i+j*grid];
        }
      }
    }
  }
  drawArray=translated;
  result=blurr(translated, GaussianBlurr);
}
