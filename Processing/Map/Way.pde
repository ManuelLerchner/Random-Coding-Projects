class Way {
  ArrayList<Node> Vertices=new ArrayList(); 
  String type;
  color col;
  long id;
  boolean explored;

  Way(long id, String type, ArrayList<Node> nodes) {
    this.id=id;
    this.type=type;
    this.Vertices=nodes;
    this.col=colorOf(type);
  }

  void show() {
    stroke(col);
    noFill();
    strokeWeight(0.8);

    beginShape();
    for (Node N : Vertices) {
      vertex(N.screenPos.x, N.screenPos.y);
    }
    endShape();
  }
}


//////////////////////////////////////////////////////////
color colorOf(String type) {
  color col=255;
  switch(type) {
  case "building":
    col=color(255, 125, 0, 200);
    break;
  case "highway":
    col=color(255, 0, 0);
    break;
  case "leisure":    //Parks
    col=color(0, 125, 255, 200);
    break;
  case "landuse":    //Umrandung
    col=color(255, 50);
    break;
  case "natural":    //Gebüsch
    col=color(0, 125, 0);
    break;
  case "layer":    //Grenze
    col=color(125, 0, 200);
    break;
  case "fixme":    //Bach
    col=color(0, 125, 200);
    break;
  case "amenity":  //Recycling
    col=color(200, 100, 0);
    break;
  case "access":      //Feldweg
    col=color(200, 0, 0);
    break;
  case "aerialway":
    col=color(150, 0, 0);
    break;
  case "area":
    col=color(100, 180, 100);
    break;
  case "bicycle":
    col=color(100, 0, 0);
    break;
  }
  if(col==255){
   println(type); 
  }
  return col;
}
