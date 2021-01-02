//////////////////////////////////////////////////////////////////////////////////////////
double map(double x, double in_min, double in_max, double out_min, double out_max) {
  return (x - in_min) * (out_max - out_min) / (in_max - in_min) + out_min;
}

//////////////////////////////////////////////////////////////////////////////////////////
PVector screenPos(PVector p) {
  return new PVector((float)map(p.x, minlon, maxlon, -width/2, width/2), (float)map(p.y, minlat, maxlat, height/2, -height/2));
}

//////////////////////////////////////////////////////////////////////////////////////////
PVector coordinatePos(PVector p) {
  p.add(width/2, height/2);
  return new PVector((float)map(p.x, 0, height, minlon, maxlon), (float)map(p.y, 0, width, maxlat, minlat));
}

//////////////////////////////////////////////////////////////////////////////////////////
float roundToNPlaces(float val, int n) {
  val*=pow(10, n);
  val=round(val);
  val/=pow(10, n);
  return val;
}

//////////////////////////////////////////////////////////////////////////////////////////
void setViewWindow(String[] lines) {
  String dim=lines[2];
  minlat= Double.valueOf((match(dim, "minlat=\"([0-9]*.[0-9]*)\"")[1]));
  maxlat= Double.valueOf((match(dim, "maxlat=\"([0-9]*.[0-9]*)\"")[1]));
  minlon= Double.valueOf((match(dim, "minlon=\"([0-9]*.[0-9]*)\"")[1]));
  maxlon= Double.valueOf((match(dim, "maxlon=\"([0-9]*.[0-9]*)\"")[1]));
}

//////////////////////////////////////////////////////////////////////////////////////////
void addNodes(String[] lines) {
  for (String t : lines) {
    try {
      long id= Long.valueOf(match(t, "<node id=\"([0-9]*)\"")[1]);
      double lat= Double.valueOf((match(t, "lat=\"([0-9]*.[0-9]*)\"")[1]));
      double lon= Double.valueOf((match(t, "lon=\"([0-9]*.[0-9]*)\"")[1]));
      Node N=new Node(id, lat, lon);
      Nodes.put(id, N);
    }
    catch (Exception e) {
    }
  }
}

//////////////////////////////////////////////////////////////////////////////////////////
void addPaths(String[] lines) {
  for (int i=0; i<lines.length; i++) {
    String t = lines[i];
    try {
      long id=Long.valueOf( match(t, "<way id=\"([0-9]*)\"")[1]);

      //Add Edges
      int k=1;
      ArrayList<Node> Edges=new ArrayList();
      try {
        while (match(lines[i+k], "<nd ref=\"([0-9]*)\"")[1]!="") {
          long nodeIndex=Long.valueOf(match(lines[i+k], "<nd ref=\"([0-9]*)\"")[1]);
          Edges.add(Nodes.get(nodeIndex));
          k++;
        }
      }
      catch (Exception e) {
      }

      //Set type
      String type=match(lines[i+k], "<tag k=\"([a-zA-Z]*)\"")[1];

      Way W=new Way(id, type, Edges);
      Ways.put(id, W);
    }
    catch (Exception e) {
    }
  }
}

//////////////////////////////////////////////////////////////////////////////////////////
void showPath() {
  if (Start !=null) {
    Start.show();
  }
  if (End !=null) {
    End.show();
  }
  if (P!=null) {
    P.show();
  }
}
