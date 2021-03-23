
void mouseWheel(MouseEvent e) {
  if (keyPressed) {
    fliesenRotation-=0.01*e.getCount();
  } else {
    scale*=1-e.getCount()/10.0;
  }
}


void mouseDragged() {

  float dx=(float)(mouseX-pmouseX)/scale;
  float dy=-(float)(mouseY-pmouseY)/scale;


  if (keyPressed) {
    fliesenOffset.add(dx*0.005, dy*0.005);
  } else {
    transOffset.add(dx, dy);
  }
}



Vertex selected;
void mousePressed() {

  if (measuringMode) {
    if (mouseButton!=LEFT) {
      measuringMode=false;
    }
  }

  if (!drawingMode) {

    Vertex toRemove=null;
    for (Vertex V : Vertices) {


      if (V.screenPos.dist(mouseGlobal)<15) {
        if (mouseButton==LEFT) {
          V.selected^=true;
          selected=V;
          drawingMode=true;
          measuringMode=false;
          return;
        } else if (mouseButton==RIGHT) {
          toRemove=V;
        } else {
          println("Selected Point at "+ V.pos);
          selected=V;
          notification="Selected Point at "+ V.pos;
          notificationSet=millis();
          measuringMode=true;
        }
      }
    }


    if (Vertices.size()!=1) {
      if (toRemove!=null) {
        if (toRemove.parent!=null) {
          toRemove.parent.child=toRemove.child;
        }
        if (toRemove.child!=null) {
          toRemove.child.parent=toRemove.parent;
        }
        Vertices.remove(toRemove);
      }
    }
  } 

  if (drawingMode) {
    try {
      Vertex newVertex=null;

      if (ortho) {
        newVertex=new Vertex(selected.pos.copy().add(drawingDir.mult(Float.parseFloat(inputTemp))));
      } else {
        newVertex=new Vertex(toAbsolutePos(drawingPoint));
      }

      if (selected.child!=null) {
        newVertex.child=selected.child;
      }

      newVertex.parent=selected;
      selected.child=newVertex;

      Vertices.add(newVertex);
      selected.selected=false;
      selected=null;
      drawingMode=false;
    }
    catch(NumberFormatException E) {
    }
  }




  Area=calcArea();
}
