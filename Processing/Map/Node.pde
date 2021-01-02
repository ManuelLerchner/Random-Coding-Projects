class Node {
  long id;
  double lat, lon;
  PVector screenPos=new PVector();
  PVector pos;


  ArrayList<Node> Neighbours=new ArrayList();
  float gCost, fCost, hCost;
  Node parent;


  Node(long id, double lat, double lon) {
    this.id=id;
    this.lat=lat;
    this.lon=lon;
    this.pos=new PVector((float)lon, (float)lat);
  }

  void update() {
    screenPos=screenPos(pos).add(transOffset);
  }  

  //////////////////////////////////////////////////////////////////////////////////////////
  void calcCost(Node end) {
    hCost=Metric(this, end);
    fCost=hCost+gCost;
  }
}
