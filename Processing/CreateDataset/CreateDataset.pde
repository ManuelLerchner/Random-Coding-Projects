//Save to textDat: "s"
//Clear Screen "r"
//Delete Last entry: "d"
//TextFormat: immage[0\n0\n255\n210\n...5\n200\n] without seperation between two immages (len grid*grid);
//LabelFormat: label[0\n...] corresponding Labels in each row

int grid=32;

float[] drawArray=new float[grid*grid];
float[] result=new float[grid*grid];
float len;
float SumX;
float SumY;
int num=0;
int count=0;
boolean blocked;

void setup() {
  size(200, 200);
  len = width/(float)grid;
  //String[] nul={};
  //saveStrings("numbers32.txt", nul);
  //saveStrings("labels32.txt", nul);
}

void draw() {
  background(0);

  //Grid
  for (int i=0; i < grid; i++) {
    for (int j=0; j < grid; j++) {
      fill(result[i+j*grid]);
      rect(i*len, j*len, len, len);
    }
  }

  //Center
  CalcCenterOfMass();
  fill(255, 0, 0);
  rect(SumX*len, SumY*len, len, len);


  //Text
  fill(255);
  textSize(20);
  text(num, width-40, height-40);
}

//Draw//Delete
void mouseDragged() {
  if (mousePressed) {
    int x=constrain(floor(grid*mouseX/(float)width), 0, grid-1);
    int y=constrain(floor(grid*mouseY/(float)height), 0, grid-1);
    int loc = x+y*grid;
    if (mouseButton==LEFT) {
      drawArray[loc]=400;
    } else {
      IntList Neighbours=new IntList();
      for (int k=-1; k <=1; k++) {
        for (int l=-1; l <=1; l++) {
          Neighbours.append(constrain((x+k)+(y+l)*grid, 0, grid*grid-1));
        }
      }
      for (int i : Neighbours) {
        drawArray[i]=0;
      }
    }
    result=blurr(drawArray, GaussianBlurr);
  }
}


void keyPressed() {
  if (key=='s') {
    if (!blocked) {
      count++;
      println(count+": "+num+" saved");
      blocked=true;
      CenterImage();
      //Immage
      String[] data=new String[result.length];
      for (int i=0; i < result.length; i++) {
        data[i]=str(constrain(round(result[i]), 0, 255));
      }
      String filenameNum ="/numbers32.txt";
      String[] linesNum;
      linesNum = loadStrings(filenameNum);
      for ( String l : data ) {
        expand(linesNum); 
        linesNum = append(linesNum, l);
      }
      saveStrings(filenameNum, linesNum);


      //Label
      String[] newLabel = {str(num)};
      String filenameLab ="/labels32.txt";
      String[] linesLab;
      linesLab = loadStrings(filenameLab);
      for ( String l : newLabel ) {
        expand(linesLab); 
        linesLab = append(linesLab, l);
      }
      saveStrings(filenameLab, linesLab);

      num++;
      num%=10;
    }
  }
  if (key=='r') {
    for (int i=0; i < drawArray.length; i++) {
      drawArray[i]=0;
    }
    result=blurr(drawArray, GaussianBlurr);
  }
  if (key=='d') {
    println("Last Immage was deleted");
    println("Draw: " +(num-1)+" again");
    num--;
    //Delete Last Immage
    String filenameNum ="/numbers32.txt";
    String[] linesNum;
    linesNum = loadStrings(filenameNum);
    if (linesNum.length>=grid*grid) {
      String[] shortened=new String [linesNum.length-grid*grid];
      for (int i=0; i < linesNum.length-grid*grid; i++) {
        shortened[i] = linesNum[i];
      }
      saveStrings(filenameNum, shortened);
    }
    //Delete last Label
    String filenameLab ="/labels32.txt";
    String[] linesLab;
    linesLab = loadStrings(filenameLab);
    if (linesLab.length>0) {
      String[] shortened=new String [linesLab.length-1];
      for (int i=0; i < linesLab.length-1; i++) {
        shortened[i] = linesLab[i];
      }
      saveStrings(filenameLab, shortened);
    }
  }
}


void keyReleased() {
  if (key=='s') {
    blocked=false;
    for (int i=0; i < drawArray.length; i++) {
      drawArray[i]=0;
    }
    result=blurr(drawArray, GaussianBlurr);
  }
}
