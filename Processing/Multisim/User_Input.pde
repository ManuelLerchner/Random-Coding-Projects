PVector mousePos=new PVector();

void mousePressed() {
  if (mouseButton==LEFT) {
    clickOnBauteil();
  }

  if (mouseButton==RIGHT) {
    if (keyPressed) {
      transferRefferenceNode();
    } else {
      removeLine();
      removeBauteil();
    }
  }

  updateLines();
  setupMatrix();
}

long tLastMoved;
void mouseMoved(){
  tLastMoved=millis();
}


void keyPressed() {
  if ((key=='r')||(key=='R')) {
    for (Bauteil B : Bauteile) {
      if (B.selected) {
        B.rotate();
      }
    }
  }
}
