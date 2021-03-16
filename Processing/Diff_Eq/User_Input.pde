
void mouseWheel(MouseEvent e) {
  scale*=1-e.getCount()/10.0;
}


void mouseDragged() {

  float dx=(float)(mouseX-pmouseX)/scale;
  float dy=(float)(mouseY-pmouseY)/scale;

  transOffset.add(dx, dy);
}
