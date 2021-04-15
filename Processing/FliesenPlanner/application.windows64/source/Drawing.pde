PVector drawingPoint;
PVector drawingDir=new PVector();

void showDrawing() {

  if (drawingMode) {

    PVector start=selected.screenPos;
    drawingPoint=mouseGlobal.copy();

    if (ortho) {
      PVector diff=drawingPoint.copy().sub(start);
      if (abs(diff.x)>abs(diff.y)) {
        drawingDir.y=0;
        drawingDir.x=int(diff.x>0)*2-1;

        drawingPoint.y=start.y;
      } else {
        drawingPoint.x=start.x;
        drawingDir.x=0;
        drawingDir.y=int(diff.y<0)*2-1;
      }
    }

    line(start.x, start.y, drawingPoint.x, drawingPoint.y);

    if (!ortho) {

      PVector end=toAbsolutePos(drawingPoint);
      float dist=end.dist(selected.pos);
      PVector endScreen=toScreenPos(end);
      fill(255, 0, 255);
      text(nf(dist, 0, 3)+"m", endScreen.x, endScreen.y);

      float alpha=degrees(atan2(end.y-selected.pos.y, end.x-selected.pos.x));
      text(nf(alpha, 0, 3)+"°", start.x, start.y+20);
    }
  }
}

PVector measurePoint;


void showMeasure() {
  if (measuringMode) {

    PVector start=selected.screenPos;
    PVector end=mouseAbsolutePos;

    for (Vertex V : Vertices) {
      if (V.screenPos.dist(mouseGlobal)<15) {
        end=V.pos;
      }
    }

    float dist=end.dist(selected.pos);
    PVector endScreen=toScreenPos(end);
    line(start.x, start.y, endScreen.x, endScreen.y);
    text(nf(dist, 0, 3)+"m", endScreen.x, endScreen.y);
  }
}
