void drawGrid() {
  stroke(0, 0, 0.1);
  for (int i=0; i < n; i++) {
    line(i*stepX, 0, i*stepX, height);
  }
  for (int j=0; j < m; j++) {
    line(0, j*stepY, width, j*stepY);
  }
}

void initScreen() {
  mapImage=loadImage("map.png");
  gridLen=1200.0/max(mapImage.width, mapImage.height);
  n=mapImage.width;
  m=mapImage.height;
  size(round(n*gridLen), round(m*gridLen));
  stepX=float(width)/n;
  stepY=float(height)/m;
}

void showMap() {
  for (PVector P : Map.keySet()) {
    Map.get(P).show();
  }
}

boolean overlapps(PVector in) {
  float dS=0.001;
  float x=in.x%1;
  float y=in.y%1;
  if (x>0.5-dS && x<0.5+dS) {
    if (y>0.5-dS && y<0.5+dS) {
      return true;
    }
  }
  return false;
}

void ellipse(PVector pos, float rad) {
  ellipse(pos.x+stepX/2, pos.y+stepY/2, rad, rad);
}

void rect(PVector pos, float X, float Y) {
  rect(pos.x, pos.y, X, Y);
}

void line(PVector start, PVector end) {
  line(start.x+stepX/2, start.y+stepY/2, end.x+stepX/2, end.y+stepY/2);
}



void vertex(PVector pos) {
  vertex(pos.x+stepX/2, pos.y+stepY/2);
}

PVector toPixelCoordinate(PVector in) {
  return new PVector(in.x*stepX, in.y*stepY);
}

PVector toGameCoordinate(PVector in) {
  return new PVector(floor(in.x/stepX), floor(in.y/stepY));
}
