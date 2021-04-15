void showText() {
  fill(255);
  if (toPrint) fill(0);
  textSize(20);
  textAlign(LEFT, BOTTOM);
  text(" len= "+ displayedInput +" m", -width/2, height/2);

  textAlign(RIGHT, BOTTOM);
  text( Area+" m² ", width/2, height/2);

  textAlign(RIGHT, TOP);
  float fliesenAnzahl=round(1000*(Area/(fliesenSize.x*fliesenSize.y)))/1000.0;
  text(fliesenAnzahl+" Fliesen ", width/2, -height/2);

  if (!toPrint) {
    textAlign(LEFT, TOP);
    text(notification, -width/2, -height/2);
  }
}


void setMouse() {
  mouseGlobal=new PVector(mouseX-width/2, mouseY-height/2);
  mouseAbsolutePos=toAbsolutePos(mouseGlobal);
}


void showPolygon() {
  fill(125, 125, 255, 100);
  strokeWeight(2);
  beginShape();

  Vertex running=Vertices.get(0);

  while (running !=null) {
    running.showVertex();
    running=running.child;
  }

  endShape();

  textSize(5*scale);
  fill(255);
  textAlign(CENTER, BOTTOM);

  for (Vertex V : Vertices) {
    V.showText();
  }

  for (Vertex V : Vertices) {
    V.showPoint();
  }
}

void Util() {

  if (toPrint) {
    String desktopPath = System.getProperty("user.home") + "/Desktop";
    desktopPath.replace("\\", "/");
    saveFrame(desktopPath+"/Image-#####.png");
    toPrint=false;
  }

  if (millis()-notificationSet>3000) {
    notification="";
  }
}

void fileSelectedOUT(File selection) {
  if (selection == null) {
    println("Window was closed or the user hit cancel.");
  } else {
    String path=selection.getAbsolutePath();
    println("User selected " + path);
    saveData(path);
  }
}

void fileSelectedIN(File selection) {
  if (selection == null) {
    println("Window was closed or the user hit cancel.");
    pause=false;
  } else {
    String path=selection.getAbsolutePath();
    println("User selected " + path);
    Vertices.clear();
    loadData(path);
  }
}

void saveData(String path) {
  String[] Dat=new String[Vertices.size()]; 


  //Give every Utility an index
  for (int i=0; i<Vertices.size(); i++) {
    Vertices.get(i).index=i;
  }


  Vertex V=Vertices.get(0);
  int i=0;
  while (V !=null) {

    Dat[i]=V.index+";";

    //Save type
    Dat[i]+=V.pos.x+","+V.pos.y+";"; 


    if (V.parent!=null) {
      Dat[i]+=V.parent.index;
    } else {
      Dat[i]+="-1";
    }
    Dat[i]+=";";

    if (V.child!=null) {
      Dat[i]+=V.child.index;
    } else {
      Dat[i]+="-1";
    }
    Dat[i]+=";";

    V=V.child;
    i++;
  }


  saveStrings(path, Dat);
  printArray(Dat);
  println("Saved");
}


void loadData(String path) {
  String[] lines = loadStrings(path);

  ArrayList<PVector> Connections=new ArrayList();

  for (String l : lines) {
    String[] dat=l.split(";");

    //Index
    int index=int(dat[0]);

    //pos
    String posString[]=dat[1].split(",");
    PVector pos=new PVector(float(posString[0]), float(posString[1]));

    int parent=int(dat[2]);
    int child=int(dat[3]);

    Connections.add(new PVector(index, parent, child));

    //Create correct Gatter
    Vertex V=new Vertex(pos);

    //Match index
    V.index=index;

    Vertices.add(V);

    printArray(dat);
  }


  //Connect
  for (PVector P : Connections) {

    int index=round(P.x);
    int parent=round(P.y);
    int child=round(P.z);

    for (Vertex V : Vertices) {
      if (V.index==index) {

        for (Vertex O : Vertices) {
          //Parent
          if (O.index==parent) {
            V.parent=O;
          }
          //Child
          if (O.index==child) {
            V.child=O;
          }
        }
      }
    }
  }
  println("Loaded");
  pause=false;
}
