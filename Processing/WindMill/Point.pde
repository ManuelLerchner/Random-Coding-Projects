class Point {
  float x, y;
  float dist, alpha, lenOnLine, distToLine;
  int n;
  int count;

  Point(float x_, float y_, int n_) { 
    x=x_;
    y=y_;
    n=n_;
  }


  void show() {
    fill(255);
    ellipse(x, y, 10, 10);

    fill(0);
    textSize(15);
    text(count, x+10, y+10);

    strokeWeight(0.5);
    //line(x, y, cx-cos(theta)*lenOnLine, cy-sin(theta)*lenOnLine);
  }


  void math() {
    dist = dist(x, y, cx, cy);
    alpha=atan2(cy-y, cx-x);
    lenOnLine = cos(alpha-theta)*dist;
    distToLine=distToLine(theta, alpha, dist);
  }

  void updateLine() {
    if (abs(distToLine)<0.1 &&n != pNow && n!=pPrevious ) {
      cx=x;
      cy=y;
      pPrevious=pNow;
      pNow =n;
      KlickSound.play();
      count++;
    }
  }

  float distToLine(float theta, float alpha, float dist) {
    float beta = alpha-theta;
    float distToLine =sin(beta)*dist;   
    return distToLine;
  }
}
