void mouseDragged() {
  globalPanOffset.add(1/zoomFactor*(mouseX-pmouseX), -1/zoomFactor*(mouseY-pmouseY));
}

void mouseWheel(MouseEvent e) {
  zoomFactor*= 1-0.2/e.getCount();
}

void keyPressed() {
  if (key=='w') {
    Wobbeln=!Wobbeln;
  } else {
    N_LeiterVorhanden=!N_LeiterVorhanden;
    calculate();
  }
}
