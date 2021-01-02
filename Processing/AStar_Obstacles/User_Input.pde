StringList keys= new StringList();
void keyPressed() {
  if (key=='r') {
    Cells.clear();
    for (int j=0; j < n; j++) {
      for (int i=0; i < n; i++) {
        Cells.add(new Cell(new PVector(i, j)));
      }
    }
    Player=new Player(cellAtPos(n-2, n-2));
  }
  if (!keys.hasValue(str(key))) {
    keys.append(str(key));
  }
}

void keyReleased() {
  keys.removeValue(str(key));
}


void mouseDragged() {
  drawCells();
}

void mousePressed() {
  drawCells();
}

void drawCells() {
  int x = constrain(floor((float)(mouseX)/width*n), 1, n-2);
  int y = constrain(floor((float)(mouseY)/height*n), 1, n-2);
  if (mouseButton==LEFT) {
    Cell temp =cellAtPos(x, y);
    if (temp.start==false&&temp.end==false) {
      temp.wall=true;
    }
  }
  if (mouseButton==RIGHT) {
    if (x>1&&x<n-2) {
      if (y>1&&y<n-2) {
        for (int i=-1; i <=1; i+=1) {
          for (int j=-1; j <=1; j+=1) {
            cellAtPos(x+i, y+j).wall=false;
          }
        }
      }
    }
  }
}
