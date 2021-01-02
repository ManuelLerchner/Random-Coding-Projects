void mousePressed() {
  PVector mousePos=new PVector((mouseX-width/2)/scale, (mouseY-height/2)/scale);
  for (Long key : Ways.keySet()) {
    Way W = Ways.get(key);
    if (W.type.equals("highway")) {
      for (Node N : W.Vertices) {
        if (N.screenPos.dist(mousePos)<10/scale) {
          if (mouseButton==LEFT) {
            Start= new Tag(N, W, "Start");
            break;
          } else if (mouseButton==RIGHT) {
            End= new Tag(N, W, "End");
            break;
          }
        }
      }
    }
  }
  if (Start !=null && End !=null) { 
    P=new Path(Start, End);
  }
}


void mouseDragged() {
  transOffset.x+=(mouseX-pmouseX)/scale;
  transOffset.y+=(mouseY-pmouseY)/scale;
}


void mouseWheel(MouseEvent event) {
  float e = event.getCount();
  scale*=1-e/10;
}
