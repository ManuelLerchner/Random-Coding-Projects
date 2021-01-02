
import java.util.Map;
import java.util.Arrays;
import java.util.Collections;

class Node {
  String name;
  ArrayList<String> children;

  boolean selected;

  ArrayList<Node> outputs=new ArrayList();
  ArrayList<Node> inputs=new ArrayList();

  PVector pos=new PVector();

  float val;

  float FAT=0;
  float FET=0;
  float SAT=0;
  float SET=0;
  float Puffer;

  boolean discovered;



  Node (String name, String prev, int val) {
    this.name=name;
    this.val=val;
    this.children=new ArrayList<String>(Arrays.asList(prev.split(",")));
  }


  void show() {
    connect();
    fill(255);
    stroke(0);
    if (Puffer==0) {
      stroke(255, 0, 0);
    }
    rect(pos.x, pos.y, 60, 40);
    stroke(0);
    line(pos.x, pos.y+20, pos.x+60, pos.y+20);
    line(pos.x+20, pos.y, pos.x+20, pos.y+40);
    line(pos.x+40, pos.y, pos.x+40, pos.y+40);

    fill(0);
    text(name, pos.x+10, pos.y+10);
    text(round(val), pos.x+10, pos.y+30);
    text(round(FAT), pos.x+30, pos.y+10);
    text(round(FET), pos.x+50, pos.y+10);
    text(round(SAT), pos.x+30, pos.y+30);
    text(round(SET), pos.x+50, pos.y+30);
    text(round(Puffer), pos.x+30, pos.y+50);
  }

  void connect() {

    for (Node N : outputs) {
      line(pos.x, pos.y, N.pos.x, N.pos.y);
    }
  }

  void move() {
    if (selected) {
      pos.set(mousePos);
    }
  }
}



class Graph {
  HashMap<String, Node> Data;

  Graph(HashMap Data) {
    this.Data=Data;

    setPos();
    connect();
    forward();
    backward();
  }

  void connect() {
    for (String key1 : Data.keySet()) {
      Node D=Data.get(key1);
      for (String key2 : D.children) {
        if (!key2.equals("")) {
          Node O=Data.get(key2);
          D.outputs.add(O);
          O.inputs.add(D);
        }
      }
    }
  }

  void forward() {
    ArrayList<Node> test=BreadthFirstSearch(Data.get("A"));

    for (Node N : test) {

      if (N.inputs.size()>0) {
        N.FAT=-100000000; //-infinity
        for (Node prev : N.inputs) {
          N.FAT=max(prev.FET, N.FAT);
        }
        N.FET=N.FAT+N.val;
      } else {
        N.FAT=0;
        N.FET=N.val;
      }
    }
  }

  void backward() {
    ArrayList<Node> test=BreadthFirstSearch(Data.get("A"));

    for (int i=test.size()-1; i>=0; i--) {
      Node N =test.get(i);


      if (N.outputs.size()>0) {
        N.SET=100000000; //infinity
        for (Node child : N.outputs) {
          N.SET=min(child.SAT, N.SET);
        }
        N.SAT=N.SET-N.val;

        N.Puffer=N.SAT-N.FAT;
      } else {
        N.SAT=N.FAT;
        N.SET=N.FET;
      }
    }
  }
}




void setPos() {
  int size= Data.size()+1; 
  int i=0;
  for (String key1 : Data.keySet()) {
    Node D=Data.get(key1);
    D.pos.x=width*(i+0.5)/size;
    D.pos.y=random(20, height-20);
    i++;
  }
}
