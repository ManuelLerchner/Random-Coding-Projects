class ChildApplet extends PApplet {
  public ChildApplet() {
    super();
    PApplet.runSketch(new String[]{this.getClass().getName()}, this);
  }

  float[] hei =new float[2*P1.res];
  Color[] col =new Color[2*P1.res];

  PVector pos=new PVector(200, 200);

  public void settings() {
    size(400, 400);
  }

  public void setup() { 
    surface.setTitle("Player View");
    rectMode(CENTER);
    surface.setLocation(1300, 300);
  }

  void draw() {

    background(30);
    fill(20);
    noStroke();
    rect(width/2, 3*height/4, width, height/2);
    noStroke();
    float len = width/(float)P1.res;
    for (int i=0; i < P1.res; i++) {
      float x = map(i, 0, P1.res, 0, width);
   
      float h = map(hei[i], 0, SceneSize, height-20, 2);
 
      if (hei[i]<SceneSize*sqrt(2)) {           
        Color c=col[i];
  
        if (c!=null) {
           
          fill(255*c.r, 255*c.g, 255*c.b, 255*c.a);
          rect(0.5*len+x, height/2, len, h);
        }
      }
    }
  }
}
