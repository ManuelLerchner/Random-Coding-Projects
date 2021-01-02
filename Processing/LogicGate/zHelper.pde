void grid() {
  stroke(255, 50*scale);
  strokeWeight(0.1/scale);

  for (float i =-width/2/scale; i<width/2/scale; i+=10) {
    line(i, -height/2/scale, i, height/2/scale);
  }
  for (float i =-height/2/scale; i<height/2/scale; i+=10) {
    line(-width/2/scale, i, width/2/scale, i);
  }
}

/////////////////////////////////////////////////////////////////////////
void connectDrawing() {
  if (globalDrawSelected) {
    line(currentlySelected.pos.x+globalPanOffset.x+currentlySelected.U.pos.x, currentlySelected.pos.y+globalPanOffset.y+currentlySelected.U.pos.y, mouse.x, mouse.y);
  }
}

/////////////////////////////////////////////////////////////////////////
void updateNetwork() {
  for (int k=0; k<50; k++) {
    for (UTILITY U : Utility) {
      for (int i=0; i<U.Connectors.size(); i++) {
        Connector c = U.Connectors.get(i);
        U.state[i]=c.state;
      }
    }
    for (UTILITY U : Utility) {
      U.process();
    }
  }
}

/////////////////////////////////////////////////////////////////////////
void setMouse() {
  float mx=(mouseX-width/2)/scale;
  float my=(mouseY-height/2)/scale;
  mouse=new PVector(mx, my);
}

/////////////////////////////////////////////////////////////////////////
boolean insideSquare(PVector A, float rad, PVector B) {
  if (abs(A.x-B.x)<rad) {
    if (abs(A.y-B.y)<rad) {
      return true;
    }
  }
  return false;
}

/////////////////////////////////////////////////////////////////////////
void fileSelectedIN(File selection) {
  if (selection == null) {
    println("Window was closed or the user hit cancel.");
  } else {
    String path=selection.getAbsolutePath();
    println("User selected " + path);
    Utility.clear();
    loadData(path);
  }
}

/////////////////////////////////////////////////////////////////////////
void fileSelectedOUT(File selection) {
  if (selection == null) {
    println("Window was closed or the user hit cancel.");
  } else {
    String path=selection.getAbsolutePath();
    println("User selected " + path);
    saveData(path);
  }
}


/////////////////////////////////////////////////////////////////////////
void loadData(String path) {
  String[] lines = loadStrings(path);
  ArrayList<Connection> Connections=new ArrayList();

  for (String l : lines) {
    String[] dat=l.split(";");

    //Type
    String type=dat[0];

    //Index
    int index=int(dat[1]);

    //State
    boolean[] state=new boolean[int(dat[2])];
    for (int i=0; i<int(dat[2]); i++) {
      state[i]=boolean(dat[3+i]);
    }

    //pos
    PVector pos=new PVector(float(dat[3+state.length]), float(dat[4+state.length]));

    //Connected Connections
    String[] connected=dat[5+state.length].split(":");
    for (int i=0; i<connected.length; i++) {
      String[] info=connected[i].split("#");
      if (info.length>1) {
        Connections.add(new Connection(index, i, int(info[1]), int(info[2])));
      }
    }

    //Active State
    boolean UserState=false;
    UserState=boolean(dat[6+state.length]);


    //Invert State
    boolean[] invert=new boolean[state.length];
    for (int i=0; i<state.length; i++) {
      invert[i]=boolean(dat[7+i+state.length]);
    }

    //Flanke Button
    boolean Flanke=boolean(dat[7+state.length+state.length]);


    //Create correct Gatter
    UTILITY U=createUtility(type, pos);

    //Match User State
    if (type.equals("TORCH")) {
      U.TORCH.state=UserState;
    }
    if (type.equals("BUTTON")) {
      U.BUTTON.state=UserState;
    }

    //Match Flanke
    if (type.equals("BUTTON")) {
      U.BUTTON.Flanke=Flanke;
    }

    //Match Connector State
    U.state=state;

    //Match index
    U.index=index;

    //Match invert
    U.invert=invert;


    Utility.add(U);
  }

  //Set Connections
  for (Connection C : Connections) {
    for (UTILITY U : Utility) {
      for (UTILITY O : Utility) {
        if (C.currentID==U.index && C.otherID==O.index) {
          Connector A=U.Connectors.get(C.myPinIndex);
          Connector B=O.Connectors.get(C.otherPinIndex);
          A.connected.add(B);
          B.connected.add(A);
        }
      }
    }
  }



  //UpdateWires
  updateNetwork();
  for ( UTILITY U : Utility) {
    for (int i=0; i<U.Connectors.size(); i++) {
      Connector C =U.Connectors.get(i);
      U.WireUpdate(C, U.state[i]^U.invert[i]);
    }
  }

  println("Loaded");
}


/////////////////////////////////////////////////////////////////////////
void saveData(String path) {

  // (Type)-(Index)-(#Connections)-([State of Connections])-(pos.x)-(pos.y)-([Connector[i]->ConnectedTo[Connections_Positions]])-(ActiveState)-([InvertedPins])
  String[] Dat=new String[Utility.size()]; 
  int count=0;

  //Give every Utility an index
  for (int i=0; i<Utility.size(); i++) {
    UTILITY U=Utility.get(i); 
    U.index=i;
  }

  for (int i=0; i<Utility.size(); i++) {
    UTILITY U=Utility.get(i); 

    //Save type
    Dat[i]=U.type+";"; 

    //Save index
    Dat[i]+=count+";"; 

    //Save #Connections
    Dat[i]+=U.Connectors.size()+";"; 

    //Save Connector States
    for (int k =0; k<U.Connectors.size(); k++) {
      Dat[i]+=U.Connectors.get(k).state+";";
    }

    //Save pos
    Dat[i]+=U.pos.x+";"; 
    Dat[i]+=U.pos.y+";"; 

    //Save Connected Connectors
    for (int k =0; k<U.Connectors.size(); k++) {
      Connector c=U.Connectors.get(k);
      Dat[i]+="C"+k+"#"; 

      for ( Connector n : c.connected) {
        for (int l =0; l<n.U.Connectors.size(); l++) {
          Connector o =n.U.Connectors.get(l);
          if (o.equals(n)) {
            Dat[i]+=n.U.index+"#"+l+"#";
          }
        }
      }

      Dat[i]+=":";
    }
    Dat[i]+=";";

    //Save Active Date
    if (U.type=="BUTTON") {
      Dat[i]+=U.BUTTON.state;
    }
    if (U.type=="TORCH") {
      Dat[i]+=U.TORCH.state;
    }
    if (!(U.type=="TORCH"||U.type=="BUTTON")) {
      Dat[i]+=false;
    }
    Dat[i]+=";";


    //Save Invert
    for (int k =0; k<U.invert.length; k++) {
      Dat[i]+=U.invert[k]+";";
    }

    //Button Flanke
    if (U.type=="BUTTON") {
      Dat[i]+=U.BUTTON.Flanke;
    } else {
      Dat[i]+=false;
    }

    count++;
  }

  saveStrings(path, Dat);
  printArray(Dat);
  println("Saved");
}


/////////////////////////////////////////////////////////////////////////
class Connection {
  int currentID, myPinIndex, otherID, otherPinIndex;
  PVector pos;
  Connection(int currentID, int myPinIndex, int otherID, int otherPinIndex) {
    this.currentID=currentID;
    this.myPinIndex=myPinIndex;
    this.otherID=otherID;
    this.otherPinIndex=otherPinIndex;
  }
}

/////////////////////////////////////////////////////////////////////////
UTILITY createUtility(String type, PVector pos) {
  UTILITY U;
  switch(type) {
  case "AND" : 
    U=new UTILITY(new AND(), pos); 
    break; 

  case "OR" : 
    U=new UTILITY(new OR(), pos); 
    break; 

  case "NAND" : 
    U=new UTILITY(new NAND(), pos); 
    break; 

  case "NOR" : 
    U=new UTILITY(new NOR(), pos); 
    break; 

  case "NOT" : 
    U=new UTILITY(new NOT(), pos); 
    break; 

  case "XOR" : 
    U=new UTILITY(new XOR(), pos); 
    break; 

  case "EQU" : 
    U=new UTILITY(new EQU(), pos); 
    break; 

  case "BUTTON" : 
    U=new UTILITY(new BUTTON(), pos); 
    break; 

  case "TORCH" : 
    U=new UTILITY(new TORCH(), pos); 
    break;

  case "ADDER" : 
    U=new UTILITY(new ADDER(), pos); 
    break; 

  default:
    U=new UTILITY(new AND(), pos); 
    break;
  }
  return U;
}
