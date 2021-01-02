class Block {
  int[] shape;
  PVector CenterGridPos;
  PVector gravity = new PVector(0, 1);
  boolean stop = false;
  ArrayList<part> Parts = new ArrayList();
  int f;
  int rotation;
  boolean add;

  long time;

  boolean fast;
  boolean nowStop = false;

  Block(int f_, PVector CenterGridPos_) {
    CenterGridPos = CenterGridPos_;

    f=f_;

    shape=shapes.get(f);
  }




  void show() {



    colorMode(HSB, 255, 100, 100);

    fill(map(f, 0, shapes.size(), 0, 255), 100, 100);

    int k = 0;


    if (rotation==0) {
      for (int j=-1; j <= 1; j++) {
        for (int i=-1; i <= 1; i++) {
          PVector temp = new PVector(CenterGridPos.x, CenterGridPos.y);
          PVector Add = new PVector(i, j);
          temp.add(Add);

          if (shape[k]==1) {
            Parts.add(new part(absPos(temp)));
          }
          k++;
        }
      }
    }

    if (rotation==1) {

      for (int i=-1; i <= 1; i++) {
        for (int j=-1; j <= 1; j++) {
          PVector temp = new PVector(CenterGridPos.x, CenterGridPos.y);
          PVector Add = new PVector(-i, j);
          temp.add(Add);

          if (shape[k]==1) {
            Parts.add(new part(absPos(temp)));
          }
          k++;
        }
      }
    }

    if (rotation==2) {

      for (int j=-1; j <= 1; j++) {
        for (int i=-1; i <= 1; i++) {

          PVector temp = new PVector(CenterGridPos.x, CenterGridPos.y);
          PVector Add = new PVector(-i, -j);
          temp.add(Add);

          if (shape[k]==1) {
            Parts.add(new part(absPos(temp)));
          }
          k++;
        }
      }
    }

    if (rotation==3) {

      for (int i=-1; i <= 1; i++) {
        for (int j=-1; j <= 1; j++) {


          PVector temp = new PVector(CenterGridPos.x, CenterGridPos.y);
          PVector Add = new PVector(i, -j);
          temp.add(Add);

          if (shape[k]==1) {
            Parts.add(new part(absPos(temp)));
          }
          k++;
        }
      }
    }

    colorMode(RGB, 255, 255, 255);
  }




  void move() {


    boolean lastStop = nowStop;
    if (stop) {
      nowStop=true;
    }

    if (lastStop==false && nowStop == true) {
      add = true;
    }


    if (!stop) {
      if (keyPressed) {
        if (key == 'a'&& millis()-time>300) {
          CenterGridPos.add(new PVector(-1, 0));
          time=millis();
        }
        if (key == 'd'&& millis()-time>300) {
          CenterGridPos.add(new PVector(1, 0));
          time=millis();
        }
      }
    }




    if (!stop) {
      if (keyPressed) {
        if (key==' ' && millis()-time>200) {
          rotation+=1;
          rotation=rotation%4;
          time=millis();
        }
      }
    }

    fast = false;

    if (keyPressed) {
      if (key == 's') {
        fast = true;
      }
    }


    if (!stop) {
      if (fast) {
        if (frameCount%10 == 0) {
          CenterGridPos.add(gravity);
        }
      } else {
        if (frameCount%50 == 0) {
          CenterGridPos.add(gravity);
        }
      }
    }

    if (frameCount%100==0) {
      time = millis();
    }


    for (part p : Parts) {
      if ((gridPos(p.pos).y > gridSize.y-2) || (Static.contains(new PVector(gridPos(p.pos).x, gridPos(p.pos).y+1))==true)) {
        stop = true;
      }

 
      if (stop) {
        if ( !Static.contains(new PVector(gridPos(p.pos).x, gridPos(p.pos).y))) {
          Static.add(new PVector(gridPos(p.pos).x, gridPos(p.pos).y));
          col.add(new PVector(f, 0));
        }
      }
    }
  }
}








PVector absPos(PVector gridPos) {
  PVector Pos = new PVector(gridPos.x*gridLen+gridLen/2, gridPos.y*gridLen+gridLen/2);
  return Pos;
}


PVector gridPos(PVector absPos) {
  PVector Pos = new PVector(floor(map(absPos.x, 0, width, 0, gridSize.x)), floor(map(absPos.y, 0, height, 0, gridSize.y)));
  return Pos;
}
