import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class FliesenPlanner extends PApplet {

float scale=1;
float range=20;
PVector transOffset=new PVector();

PVector mouseGlobal=new PVector();
PVector mouseAbsolutePos=new PVector();
boolean drawingMode;
boolean measuringMode;
float Area;
boolean toPrint;

boolean ortho=true;
boolean showGrid=true;

String notification="";
long notificationSet;

boolean pause;


PVector fliesenSize=new PVector(0.6f, 0.6f);
PVector fliesenOffset=new PVector();
float fliesenRotation=0;


ArrayList<Vertex> Vertices=new ArrayList();

public void setup() {
  
  surface.setTitle("FliesenPlanner");
  surface.setResizable(true);

  Vertices.add(new Vertex(new PVector()));
}

public void draw() {
  background(51);
  if (toPrint) background(255);
  translate(width/2, height/2);

  showGrid();
  if (!pause) {
    showText();
    setMouse();


    showPolygon();
    showDrawing();
    showMeasure();
    Util();
  }
}
PVector drawingPoint;
PVector drawingDir=new PVector();

public void showDrawing() {

  if (drawingMode) {

    PVector start=selected.screenPos;
    drawingPoint=mouseGlobal.copy();

    if (ortho) {
      PVector diff=drawingPoint.copy().sub(start);
      if (abs(diff.x)>abs(diff.y)) {
        drawingDir.y=0;
        drawingDir.x=PApplet.parseInt(diff.x>0)*2-1;

        drawingPoint.y=start.y;
      } else {
        drawingPoint.x=start.x;
        drawingDir.x=0;
        drawingDir.y=PApplet.parseInt(diff.y<0)*2-1;
      }
    }

    line(start.x, start.y, drawingPoint.x, drawingPoint.y);

    if (!ortho) {

      PVector end=toAbsolutePos(drawingPoint);
      float dist=end.dist(selected.pos);
      PVector endScreen=toScreenPos(end);
      fill(255, 0, 255);
      text(nf(dist, 0, 3)+"m", endScreen.x, endScreen.y);

      float alpha=degrees(atan2(end.y-selected.pos.y, end.x-selected.pos.x));
      text(nf(alpha, 0, 3)+"°", start.x, start.y+20);
    }
  }
}

PVector measurePoint;


public void showMeasure() {
  if (measuringMode) {

    PVector start=selected.screenPos;
    PVector end=mouseAbsolutePos;

    for (Vertex V : Vertices) {
      if (V.screenPos.dist(mouseGlobal)<15) {
        end=V.pos;
      }
    }

    float dist=end.dist(selected.pos);
    PVector endScreen=toScreenPos(end);
    line(start.x, start.y, endScreen.x, endScreen.y);
    text(nf(dist, 0, 3)+"m", endScreen.x, endScreen.y);
  }
}
public void showGrid() {
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
public void showText() {
  fill(255);
  if (toPrint) fill(0);
  textSize(20);
  textAlign(LEFT, BOTTOM);
  text(" len= "+ displayedInput +" m", -width/2, height/2);

  textAlign(RIGHT, BOTTOM);
  text( Area+" m² ", width/2, height/2);

  textAlign(RIGHT, TOP);
  float fliesenAnzahl=round(1000*(Area/(fliesenSize.x*fliesenSize.y)))/1000.0f;
  text(fliesenAnzahl+" Fliesen ", width/2, -height/2);

  if (!toPrint) {
    textAlign(LEFT, TOP);
    text(notification, -width/2, -height/2);
  }
}


public void setMouse() {
  mouseGlobal=new PVector(mouseX-width/2, mouseY-height/2);
  mouseAbsolutePos=toAbsolutePos(mouseGlobal);
}


public void showPolygon() {
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

public void Util() {

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

public void fileSelectedOUT(File selection) {
  if (selection == null) {
    println("Window was closed or the user hit cancel.");
  } else {
    String path=selection.getAbsolutePath();
    println("User selected " + path);
    saveData(path);
  }
}

public void fileSelectedIN(File selection) {
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

public void saveData(String path) {
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


public void loadData(String path) {
  String[] lines = loadStrings(path);

  ArrayList<PVector> Connections=new ArrayList();

  for (String l : lines) {
    String[] dat=l.split(";");

    //Index
    int index=PApplet.parseInt(dat[0]);

    //pos
    String posString[]=dat[1].split(",");
    PVector pos=new PVector(PApplet.parseFloat(posString[0]), PApplet.parseFloat(posString[1]));

    int parent=PApplet.parseInt(dat[2]);
    int child=PApplet.parseInt(dat[3]);

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
public PVector toScreenPos(PVector in) {

  float x=(in.x*width/range+transOffset.x)*scale;
  float y=-(in.y*width/range+transOffset.y)*scale;

  return new PVector(x, y);
}


public PVector toAbsolutePos(PVector in) {

  float x=(in.x/scale-transOffset.x)/width*range;
  float y=(-in.y/scale-transOffset.y)/width*range;

  return new PVector(x, y);
}


public float calcArea() {
  ArrayList<PVector> Points=new ArrayList();

  Vertex running=Vertices.get(0);

  while (running !=null) {
    Points.add(running.pos);
    running=running.child;
  }


  float A=0;
  for (int i=0; i < Points.size(); i++) {
    PVector P_i=Points.get(i);
    PVector P_n=Points.get((i+1)%Points.size());

    A+=(P_i.y+P_n.y)*(P_i.x-P_n.x);
  }

  A=0.5f*abs(A);

  return A;
}
String inputTemp="1";
String displayedInput="1";

int cursorPos=1;

public void keyPressed() {

  try {
    if (key=='x') {
      fliesenSize.x=Float.parseFloat(inputTemp);
    }

    if (key=='y') {
      fliesenSize.y=Float.parseFloat(inputTemp);
    }
  }
  catch(NumberFormatException E) {
  }


  if (key=='g') {
    showGrid^=true;
    notificationSet=millis();
    notification="Grid toggled";
  }

  if (key=='o') {
    ortho^=true;
    println("OrthoMode: " +ortho);
    notificationSet=millis();
    notification="Ortho-Mode toggled";
  }

  if (key=='r') {
    fliesenOffset.set(0, 0);
    fliesenRotation=0;
    notificationSet=millis();
    notification="Grid reseted";
  }

  if (key=='p') {
    toPrint=true;
    notificationSet=millis();
    notification="Printed to Desktop";
  }

  if (key=='s') {
    selectOutput("Select or create a file to write to:", "fileSelectedOUT");
    notificationSet=millis();
    notification="Saved!";
  }

  if (key=='l') {
    pause=true;
    selectInput("Select a file to load:", "fileSelectedIN");
    notificationSet=millis();
    notification="Loaded!";
  }

  if (keyCode==37) {
    cursorPos--;
    cursorPos=max(cursorPos, 0);
  }

  if (keyCode==39) {
    cursorPos++;
    cursorPos=min(cursorPos, inputTemp.length() );
  }

  String validChars="1234567890.";

  if (keyCode!=8 && keyCode!=127 && keyCode!=38 && keyCode!=40 &&keyCode!=DOWN && keyCode!=UP) {

    if (validChars.contains(str(key))||keyCode==130) {

      String prev=inputTemp.subSequence(0, cursorPos).toString();
      String after=inputTemp.subSequence(cursorPos, inputTemp.length()).toString();
      if (keyCode==130) {
        prev=prev+'^';
      } else {
        prev=prev+key;
      }
      cursorPos++;
      inputTemp=prev.concat(after);
    }
  } else {

    if (inputTemp.length()>0) {
      String prev=inputTemp.subSequence(0, cursorPos).toString();
      String after=inputTemp.subSequence(cursorPos, inputTemp.length()).toString();
      if (keyCode==8) {
        prev=prev.substring(0, prev.length()-1);
        after=after.substring(0, after.length());
        cursorPos--;
      }
      inputTemp=prev.concat(after);
    }
  }

  displayedInput =inputTemp.subSequence(0, cursorPos).toString()+"|"+inputTemp.subSequence(cursorPos, inputTemp.length()).toString();
}

public void mouseWheel(MouseEvent e) {
  if (keyPressed) {
    fliesenRotation-=0.01f*e.getCount();
  } else {
    scale*=1-e.getCount()/10.0f;
  }
}


public void mouseDragged() {

  float dx=(float)(mouseX-pmouseX)/scale;
  float dy=-(float)(mouseY-pmouseY)/scale;


  if (keyPressed) {
    fliesenOffset.add(dx*0.005f, dy*0.005f);
  } else {
    transOffset.add(dx, dy);
  }
}



Vertex selected;
public void mousePressed() {

  if (measuringMode) {
    if (mouseButton!=LEFT) {
      measuringMode=false;
    }
  }

  if (!drawingMode) {

    Vertex toRemove=null;
    for (Vertex V : Vertices) {


      if (V.screenPos.dist(mouseGlobal)<15) {
        if (mouseButton==LEFT) {
          V.selected^=true;
          selected=V;
          drawingMode=true;
          measuringMode=false;
          return;
        } else if (mouseButton==RIGHT) {
          toRemove=V;
        } else {
          println("Selected Point at "+ V.pos);
          selected=V;
          notification="Selected Point at "+ V.pos;
          notificationSet=millis();
          measuringMode=true;
        }
      }
    }


    if (Vertices.size()!=1) {
      if (toRemove!=null) {
        if (toRemove.parent!=null) {
          toRemove.parent.child=toRemove.child;
        }
        if (toRemove.child!=null) {
          toRemove.child.parent=toRemove.parent;
        }
        Vertices.remove(toRemove);
      }
    }
  } 

  if (drawingMode) {
    try {
      Vertex newVertex=null;

      if (ortho) {
        newVertex=new Vertex(selected.pos.copy().add(drawingDir.mult(Float.parseFloat(inputTemp))));
      } else {
        newVertex=new Vertex(toAbsolutePos(drawingPoint));
      }

      if (selected.child!=null) {
        newVertex.child=selected.child;
      }

      newVertex.parent=selected;
      selected.child=newVertex;


      Vertices.add(newVertex);
      selected.selected=false;
      selected=null;
      drawingMode=false;
    }
    catch(NumberFormatException E) {
    }
  }




  Area=calcArea();
}
class Vertex {

  PVector pos;
  PVector screenPos;
  boolean selected;
  int index;


  Vertex child;
  Vertex parent;
  Vertex(PVector pos) {
    this.pos=pos;
  }


  public void showVertex() {
    screenPos=toScreenPos(pos);
    vertex(screenPos.x, screenPos.y);
  }

  public void showPoint() {
    screenPos=toScreenPos(pos);
    fill(125, 255, 125);
    if (selected) {
      fill(255, 0, 0);
    }
    ellipse(screenPos.x, screenPos.y, 8, 8);
  }

  public void showText() {
    if (child!=null) {
      float len=pos.dist(child.pos);

      PVector center=(pos.copy().add(child.pos)).div(2);
      PVector centerScreenPos=toScreenPos(center);

      if (toPrint) fill(0);
      textSize(10+len/4);
      text(nf(len, 0, 2), centerScreenPos.x, centerScreenPos.y);
    } else {
      float len=pos.dist(Vertices.get(0).pos);

      PVector center=(pos.copy().add(Vertices.get(0).pos)).div(2);
      PVector centerScreenPos=toScreenPos(center);

      line(screenPos.x, screenPos.y, Vertices.get(0).screenPos.x, Vertices.get(0).screenPos.y);
      if (toPrint) fill(0);
      textSize(10+len/4);
      text(nf(len, 0, 2), centerScreenPos.x, centerScreenPos.y);
    }
  }
}
  public void settings() {  size(1000, 800); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "FliesenPlanner" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
