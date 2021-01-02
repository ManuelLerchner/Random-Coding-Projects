PVector mousePos=new PVector();
PVector pmousePos=new PVector();
void mouseDragged() {
  mousePos= mapPixeltoCoord(new PVector(mouseX, mouseY));
  pmousePos=mapPixeltoCoord(new PVector(pmouseX, pmouseY));
  lookAtX-=(mousePos.x-pmousePos.x);
  lookAtY-=(mousePos.y-pmousePos.y);
  movement.add((mousePos.copy().sub(pmousePos)));
}

void mouseWheel(MouseEvent e) {
  scale*=1-e.getCount()/10.0;
}
