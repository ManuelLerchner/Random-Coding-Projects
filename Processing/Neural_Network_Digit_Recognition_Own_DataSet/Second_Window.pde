
class ChildApplet extends PApplet {
  public ChildApplet() {
    super();
    PApplet.runSketch(new String[]{this.getClass().getName()}, this);
  }

  float len;
  float SumX;
  float SumY;
  boolean update=true;
  boolean DrawMode;
  float[]   drawArray=new float[dim*dim];
  float[] result=new float[dim*dim];
  float[] copy=new float[dim*dim];


  public void settings() {
    size(200, 200);
    len=width/(float)dim;
  }

  public void setup() { 
    surface.setTitle("Input");
    rectMode(CENTER);
    colorMode(RGB, 1, 1, 1);
  }

  public void draw() {
    if (update &&!DrawMode) {
      for (int i=0; i < dim*dim; i++) {
        float val=NN.currentInputs[i];
        int col = i%dim;
        int row = floor(i/dim);
        fill((1+val)/2);
        rect(len/2+len*col, len/2+len*row, len, len);
        update=false;
      }
    }
    if (DrawMode) {
      //DrawInputs
      copy =  CenterImage(blurr(drawArray.clone(), GaussianBlurr)).clone();
      for (int i=0; i < dim*dim; i++) {
        float val=result[i];
        int col = i%dim;
        int row = floor(i/dim);
        fill(val);
        rect(len/2+len*col, len/2+len*row, len, len);
      }
      for (int i=0; i < dim*dim; i++) {
        copy[i]=constrain(copy[i], 0, 1);
        copy[i]*=2;
        copy[i]-=1;
      }
      NN.respond(copy);
      fill(0, 1, 0);
      text("DrawEnabled", width*0.05, height*0.95);
    }
    //Center
    CalcCenterOfMass();
    fill(255, 0, 0);
    rect(SumX*len, SumY*len, len, len);
    //Button
    fill(1);
    if (DrawMode) fill(1, 1, 0);
    ellipse(width*0.93, height*0.93, 2*rad, 2*rad);
    fill(0, 1, 0);
    text("Draw", width*0.75, height*0.95);
  }

  void CalcCenterOfMass() {
    SumX = 0;
    SumY = 0;
    float numA  = 0; 
    for (int i=0; i<dim; i++) {
      for (int j=0; j<dim; j++) {
        float currentCell=result[i+j*dim];
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

  float[] CenterImage(float[] in) {
    int dx=round(SumX-dim/2);
    int dy=round(SumY-dim/2);
    float[] translated=new float[dim*dim];
    for (int i=0; i < dim; i++) {
      for (int j=0; j < dim; j++) {
        if (in[i+j*dim]!=0) {
          if ((i-dx)+(j-dy)*dim>=0 && (i-dx)+(j-dy)*dim<dim*dim-1) {
            translated[(i-dx)+(j-dy)*dim]=in[i+j*dim];
          }
        }
      }
    }
    return translated;
  }


  public void mouseDragged() {
    if (DrawMode) {
      int x=constrain(floor(dim*mouseX/(float)width), 0, dim-1);
      int y=constrain(floor(dim*mouseY/(float)height), 0, dim-1);
      int loc = x+y*dim;
      if (mouseButton==LEFT) {
        drawArray[loc]=2;
      } else {
        IntList Neighbours=new IntList();
        for (int k=-3; k <=3; k++) {
          for (int l=-3; l <=3; l++) {
            Neighbours.append(constrain((x+k)+(y+l)*dim, 0, dim*dim-1));
          }
        }
        for (int i : Neighbours) {
          drawArray[i]=0;
        }
      }
    }
    result=blurr(drawArray, GaussianBlurr);
  }

  public void keyPressed() {
    if (key=='r') {
      for (int i=0; i < dim*dim; i++) {
        drawArray[i]=0;
      }
      result=blurr(drawArray, GaussianBlurr);
    }
  }

  public void mousePressed() {
    if (dist(width*0.93, height*0.93, mouseX, mouseY)<rad) {
      DrawMode=!DrawMode;
      background(0);
    }
  }
}
