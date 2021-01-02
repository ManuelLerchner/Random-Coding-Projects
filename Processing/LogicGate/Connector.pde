class Connector {
  PVector pos;
  boolean selected;
  ArrayList<Connector> connected=new ArrayList();
  boolean state;
  boolean updated;
  String type;
  int index;

  UTILITY U;
  Connector(UTILITY U, PVector pos, String type, int index) {
    this.pos=pos;
    this.U=U;
    this.type=type;
    this.index=index;
  }


  void show() {  
    stroke(0);
    fill(255, 30, 0);
    if (state) {     
      fill(50, 255, 0);
    }
  //  text(index, pos.x, pos.y);
    strokeWeight(0.5);
    ellipse(pos.x, pos.y, 2.5, 2.5);
  }

  void connect() {
    strokeWeight(1);
    stroke(255, 30, 0);
    if (state) {
      stroke(50, 255, 0);
    }

    for (Connector C : connected) {
      if (C.pos.y+C.U.pos.y-U.pos.y>=pos.y) {
        line(pos.x, pos.y, C.pos.x+C.U.pos.x-U.pos.x, C.pos.y+C.U.pos.y-U.pos.y);
      }
    }
  }
}



//Templates
final int[][] THREEPORT=  {
  {0, 0, 0, 0, 0, 0, 0}, 
  {0, 0, 0, 0, 0, 0, 0}, 
  {1, 0, 0, 0, 0, 0, 0}, 
  {0, 0, 0, 0, 0, 0, 2}, 
  {1, 0, 0, 0, 0, 0, 0}, 
  {0, 0, 0, 0, 0, 0, 0}, 
  {0, 0, 0, 0, 0, 0, 0}, 
};

final int[][] SINGLEPORT_BOT=  {
  {0, 0, 0, 0, 0, 0, 0}, 
  {0, 0, 0, 0, 0, 0, 0}, 
  {0, 0, 0, 0, 0, 0, 0}, 
  {0, 0, 0, 0, 0, 0, 2}, 
  {0, 0, 0, 0, 0, 0, 0}, 
  {0, 0, 0, 0, 0, 0, 0}, 
  {0, 0, 0, 0, 0, 0, 0}, 
};

final int[][] SINGLEPORT_TOP=  {
  {0, 0, 0, 0, 0, 0, 0}, 
  {0, 0, 0, 0, 0, 0, 0}, 
  {0, 0, 0, 0, 0, 0, 0}, 
  {1, 0, 0, 0, 0, 0, 0}, 
  {0, 0, 0, 0, 0, 0, 0}, 
  {0, 0, 0, 0, 0, 0, 0}, 
  {0, 0, 0, 0, 0, 0, 0}, 
};

final int[][] DUALPORT=  {
  {0, 0, 0, 0, 0, 0, 0}, 
  {0, 0, 0, 0, 0, 0, 0}, 
  {0, 0, 0, 0, 0, 0, 0}, 
  {1, 0, 0, 0, 0, 0, 2}, 
  {0, 0, 0, 0, 0, 0, 0}, 
  {0, 0, 0, 0, 0, 0, 0}, 
  {0, 0, 0, 0, 0, 0, 0}, 
};

final int[][] ADDERPORT=  {
  {0, 0, 0, 1, 0, 0, 0}, 
  {0, 0, 0, 0, 0, 0, 0}, 
  {1, 0, 0, 0, 0, 0, 0}, 
  {0, 0, 0, 0, 0, 0, 2}, 
  {1, 0, 0, 0, 0, 0, 0}, 
  {0, 0, 0, 0, 0, 0, 0}, 
  {0, 0, 0, 2, 0, 0, 0}, 
};

//CreateConnectorSchematic
ArrayList<Connector> createConnectors(UTILITY G, int[][] m) {
  ArrayList<Connector> Con=new ArrayList();

  for (int i =0; i<m.length; i++) {
    for (int j =0; j<m.length; j++) {

      if (m[j][i]!=0) {
        PVector pos=new PVector(round(35.0/m.length*(i-m.length/2)), round(35.0/m.length*(j-m.length/2)));
        Con.add(new Connector(G, pos, m[j][i]==1?"Input":"Output", Con.size()));
      }
    }
  }
  return Con;
}
