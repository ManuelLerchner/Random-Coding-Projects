class ChildApplet extends PApplet {
  public ChildApplet() {
    super();
    PApplet.runSketch(new String[]{this.getClass().getName()}, this);
  }

  float[] hei =new float[2*P1.res];
  int[] col =new int[2*P1.res];

  public void settings() {
    size(400, 400);
  }

  public void setup() { 
    surface.setTitle("Player View");
    rectMode(CENTER);
  }

  void draw() {
    surface.setLocation(1300, 300);
    background(30);
    fill(20);
    noStroke();
    rect(width/2, 3*height/4, width, height/2);
    noStroke();
    float len = width/(float)P1.res;
    for (int i=0; i < P1.res; i++) {
      float x = map(i, 0, P1.res, 0, width);
      float b = map(sqrt(hei[i]/(float)SceneSize), 0, 1, 255, 0);
      float h = map(hei[i], 0, SceneSize, height-20, 2);
      if (hei[i]<SceneSize*sqrt(2)) {           
        fill(col[i], b);
        rect(0.5*len+x, height/2, len, h);
      }
    }
  }
}
