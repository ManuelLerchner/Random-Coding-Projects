class Plotter {

  ArrayList<PVector> top=new ArrayList();
  ArrayList<PVector> bot=new ArrayList();

  Plotter() {
  }


  void clear() {
    top.clear();
    bot.clear();
  }


  void plot() {

    stroke(100, 255, 100);
    drawGrid();


    noFill();
    stroke(255, 100, 100);

    beginShape();
    for (PVector P : top) {
      PVector mapped=mapToGrid(P);
      vertex(mapped.x, mapped.y);
    }
    endShape();

    beginShape();

    for (PVector P : bot) {
      PVector mapped=mapToGrid(P);



      vertex(mapped.x, mapped.y);
    }
    endShape();



    plotPoints();
  }


  PVector mapToGrid(PVector in) {
    float x=(in.x-center.x)*width/2/range;
    float y=-(in.y-center.y)*height/2/range;
    return new PVector(x, y);
  }

  PVector mapToCoords(PVector in) {

    float x= (in.x-width/2)/(width/2/range)+center.x;
    float y= -((in.y-height/2)/(width/2/range)-center.y);

    return new PVector(x, y);
  }



  void drawGrid() {

    PVector Zero=new PVector(0, 0);

    PVector ZeroM=mapToGrid(Zero);

    line(ZeroM.x, height, ZeroM.x, -height);
    line(-width, ZeroM.y, width, ZeroM.y);
  }

  void plotPoints() {
    for (int i=0; i < 5; i++) {
      Points[i].plot();
    }
  }
}
