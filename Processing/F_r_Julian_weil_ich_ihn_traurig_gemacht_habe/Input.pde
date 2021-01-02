void mouseDragged() {
  globalOffset.add(1/scale*(mouseX-pmouseX), -1/scale*(mouseY-pmouseY));
}


void mouseWheel(MouseEvent e) {
  scale*= 1-0.2/e.getCount();
}
