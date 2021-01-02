class ChildApplet extends PApplet {
  public ChildApplet() {
    super();
    PApplet.runSketch(new String[]{this.getClass().getName()}, this);
  }

  int len=20;
  boolean update=true;
  boolean DrawMode;
  float[] drawArray;
  float[] result=new float[196];

  public void settings() {
    size(14*len, 14*len);
  }

  public void setup() { 
    surface.setTitle("Input");
    rectMode(CENTER);
    colorMode(RGB, 1, 1, 1);
    noStroke();
    drawArray=new float[196];
  }

  public void draw() {
    if (update &&!DrawMode) {
      for (int i=0; i < 196; i++) {
        float val=NN.currentInputs[i];
        int col = i%14;
        int row = floor(i/14);
        fill((1+val)/2);
        rect(len/2+len*col, len/2+len*row, len, len);
        update=false;
      }
    }
    if (DrawMode) {
      //DrawInputs
      for (int i=0; i < 196; i++) {
        float val=result[i];
        int col = i%14;
        int row = floor(i/14);
        fill(val);
        rect(len/2+len*col, len/2+len*row, len, len);
      }
      if (mousePressed) {
        int x=constrain(floor(14*mouseX/(float)width), 0, 13);
        int y=constrain(floor(14*mouseY/(float)height), 0, 13);
        int loc = x+y*14;
        result=blurr(drawArray, GaussianBlurr);
        if (mouseButton==LEFT) {
          drawArray[loc]=2;
        } else {
          IntList Neighbours=new IntList();
          for (int k=-1; k <=1; k++) {
            for (int l=-1; l <=1; l++) {
              Neighbours.append(constrain((x+k)+(y+l)*14, 0, 195));
            }
          }
          for (int i : Neighbours) {
            drawArray[i]=0;
          }
        }
      }
      float[] copy =result.clone();
      for (int i=0; i < 196; i++) {
        copy[i]*=2;
        copy[i]-=1;
      }
      NN.respond(copy);
      fill(0, 1, 0);
      text("DrawEnabled", width*0.05, height*0.95);
    }
    fill(1);
    if (DrawMode) fill(1, 1, 0);
    ellipse(width*0.93, height*0.93, 2*rad, 2*rad);
    fill(0, 1, 0);
    text("Draw", width*0.75, height*0.95);
  }

  public void mousePressed() {
    if (dist(width*0.93, height*0.93, mouseX, mouseY)<rad) {
      DrawMode=!DrawMode;
      background(0);
    }
  }
}
