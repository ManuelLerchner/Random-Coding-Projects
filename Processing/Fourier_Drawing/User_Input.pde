void mouseWheel(MouseEvent e) {
  accuracy-=5*e.getCount();
  println(accuracy);
}
