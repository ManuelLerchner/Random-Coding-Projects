class ChildApplet extends PApplet {
  public ChildApplet() {
    super();
    PApplet.runSketch(new String[]{this.getClass().getName()}, this);
  }

  public void settings() {
    size(400, 400);
  }

  public void setup() {
    surface.setTitle("Graph");
    surface.setLocation(1920/2+width/2+70, 1080/2-height/2);
  }

  public void draw() {
    background(51);

    stroke(0);
    strokeWeight(1.2);
    line(0, height/2, width, height/2);

    //Get Data
    FloatList mag=new FloatList();
    FloatList phase=new FloatList();
    IntList col = new IntList();
    StringList name=new StringList();

    float scaleCurrent=4;

    for (Arrow v : Arrows) {
      if (v.c!=color(255, 50, 125)) {
        mag.append((v.text.charAt(0)=='I')?scaleCurrent*v.val.mag():v.val.mag());
        phase.append(v.val.phase());
        col.append(v.c);
        name.append(str(v.text.charAt(0)));
      }
    }

    float maxMagV=height/2;
    float maxMagI=-1;
    if (Arrows.size()!=0) {
      maxMagV=mag.max();
    }

    for (int i =0; i<mag.size(); i++) { 
      if (name.get(i).equals("I")) {
        if (mag.get(i)/scaleCurrent>maxMagI) {
          maxMagI=mag.get(i)/scaleCurrent;
        }
      }
    }


    float maxVPos=-1;
    float maxIPos=1;
    noFill();
    strokeWeight(1.5);
    for (int i =0; i<mag.size(); i++) {
      beginShape();
      stroke(col.get(i));
      for (float x =0; x<width; x+=1) {
        float gx=map(x, 0, width, 0, TWO_PI);
        float y=-height/(2.3*maxMagV)*mag.get(i)*sin(gx+phase.get(i));
        if (name.get(i).equals("I")) {
          if (y>maxIPos) {
            maxIPos=y;
          }
        } else if (name.get(i).equals("U")) {
          if (y>maxVPos) {
            maxVPos=y;
          }
        }
        vertex(x, height/2+y);
      }
      endShape();
    }


    fill(255);
    stroke(#1ED328);
    strokeWeight(1.5);
    textAlign(LEFT, BOTTOM);
    text((round(100.0*maxMagV)/100.0)+"V", 0, height/2-maxVPos);
    line(0, height/2-maxVPos, 40, height/2-maxVPos);
    textAlign(RIGHT, BOTTOM);
    text((round(100.0*maxMagI)/100.0)+"A", width, height/2-maxIPos);
    line(width-40, height/2-maxIPos, width, height/2-maxIPos);

    if (maxMagI!=-1) {
      noLoop();
    }
  }
}
