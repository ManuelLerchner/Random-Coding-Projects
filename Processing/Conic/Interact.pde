void mouseDragged() {

  center.x-=(float)(mouseX-pmouseX)/width*2*range;
  center.y+=(float)(mouseY-pmouseY)/width*2*range;
}


void mousePressed() {



  for (int i=0; i < 5; i++) {
    PVector mouse=Plotter.mapToCoords(new PVector(mouseX, mouseY));

    if (Points[i].pos.dist(mouse)<0.2) {
      Points[i].selected^=true;
    }
  }
}
