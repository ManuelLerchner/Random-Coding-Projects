void showGrid() {
  if (showGrid) {
    pushMatrix();
    //translate(fliesenOffset.x, fliesenOffset.y);
    rotate(fliesenRotation);
    strokeWeight(1);

    int range=30;
    for (float i=-range; i <= range; i+=fliesenSize.x) {
      PVector posStart=new PVector(i, -range).add(fliesenOffset);
      PVector posEnd=new PVector(i, range).add(fliesenOffset);

      PVector S=toScreenPos(posStart);
      PVector E=toScreenPos(posEnd);

      line(S.x, S.y, E.x, E.y);
    }

    for (float i=-range; i <= range; i+=fliesenSize.y) {
      PVector posStart=new PVector(-range, i).add(fliesenOffset);
      PVector posEnd=new PVector(range, i).add(fliesenOffset);

      PVector S=toScreenPos(posStart);
      PVector E=toScreenPos(posEnd);

      line(S.x, S.y, E.x, E.y);
    }
    popMatrix();
  }
}
