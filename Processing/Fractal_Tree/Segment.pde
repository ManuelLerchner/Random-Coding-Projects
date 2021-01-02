class Segment {
  PVector endPos;
  PVector startPos;
  float len;
  float angle;
  float thickness;
  boolean noChildren=true;




  Segment(PVector pos, float len, float thickness, float angle) {
    this.startPos=pos;
    this.len=len;
    this.angle=angle;
    this.thickness=thickness;
    endPos=new PVector(pos.x+cos(angle)*len, pos.y-sin(angle)*len);
  }

  void show() {

    stroke(atan(angle), 1, 1);
    strokeWeight(thickness);
    line(startPos.x, startPos.y, endPos.x, endPos.y);
  }

  void createChildren(float lenFactor, float newAngle, float thicknessFactor) {
    Segment left=new Segment(endPos.copy(), len*lenFactor, thickness*thicknessFactor, angle+newAngle);
    Segment right=new Segment(endPos.copy(), len*lenFactor, thickness*thicknessFactor, angle-newAngle);

    Segments.add(left);
    Segments.add(right);



    noChildren=false;
  }
}
