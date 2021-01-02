void keyPressed() {
  if (key=='r') {
    reset();
  }
}

void reset() {
  Nodes.clear();
  AStar_solvingSpeed=1;
  setup();
}
