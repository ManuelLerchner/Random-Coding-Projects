int n = 3;
int[][] State = new int[n][n];
boolean PlayerTurn;
boolean won;
long tlast;

void setup() {
  size(600, 600);
  initialize();
}

void draw() {
  background(255);
  drawGrid();
  showStates();
  detectWon();
  showPlayerTurn();
}


/////////////////////////////////////////////////////////////////////////

void mousePressed() {
  if (!won) {
    int i = floor(map(mouseX, 0, width, 0, n));
    int j = floor(map(mouseY, 0, height, 0, n));

    if (PlayerTurn ==false && State[i][j]!=0) {
      State[i][j]=1;
      tlast=millis();
      PlayerTurn=!PlayerTurn;
    } else if (PlayerTurn ==true && State[i][j]!=1) {
      State[i][j]=0;
      tlast=millis();
      PlayerTurn=!PlayerTurn;
    }
  }
}

/////////////////////////////////////////////////////////////////////////

void keyPressed() {
  if (key == 'r') {
    initialize();
  }
  if (key == CODED) {
    if (keyCode == UP) {
      n++;
      n=constrain(n, 2, 10);
      State = new int[n][n];
      initialize();
    }
  }
  if (key == CODED) {
    if (keyCode == DOWN) {
      n--;
      n=constrain(n, 2, 10);
      State = new int[n][n];
      initialize();
    }
  }
}

/////////////////////////////////////////////////////////////////////////

void initialize() {
  float r = round(random(0, 1));
  if (r==0) {
    PlayerTurn=false;
  } else {
    PlayerTurn=true;
  }
  for (int i=0; i < n; i++) {
    for (int j=0; j < n; j++) {
      State[i][j]=100;
    }
  }
  won = false;
}
/////////////////////////////////////////////////////////////////////////

void drawGrid() {
  stroke(0);
  strokeWeight(1);
  line(0, 0, width, 0);
  for (int i=1; i < n; i++) {
    line(i*width/n, 0, i*width/n, height);
    line(0, i*height/n, width, i*height/n);
  }
}

/////////////////////////////////////////////////////////////////////////

void showStates() {
  int offset = 7;
  for (int i=0; i < n; i++) {
    for (int j=0; j < n; j++) {
      textAlign(CENTER, CENTER);
      textSize(width/n /2);
      fill(0);
      if (State[i][j] == 1) {     
        text("X", i*width/n+width/(2*n), j*height/n+height/(2*n)-offset);
      } else if (State[i][j] == 0) {
        text("O", i*width/n+width/(2*n), j*height/n+height/(2*n)-offset);
      }
    }
  }
}

/////////////////////////////////////////////////////////////////////////

void showPlayerTurn() {
  if (!won) {
    textSize(width/n/2);
    textAlign(CENTER, CENTER);

    float c = constrain((millis()-tlast)/2, 0, 255);
    fill(255-c, 255-c, 255-c, c);

    if (PlayerTurn==false) {
      text("X", mouseX, mouseY);
    } else {
      text("O", mouseX, mouseY);
    }
  }
}

/////////////////////////////////////////////////////////////////////////

void detectWon() {
  int sumX = 0;
  int sumY = 0;
  int sumDiag1 = 0;
  int sumDiag2 = 0;

  fill(255, 0, 0);
  strokeWeight(5);
  stroke(255, 0, 0);

  for (int i=0; i < n; i++) {
    for (int j=0; j < n; j++) {
      sumY+=State[i][j];
      sumX+=State[j][i];
    }
    sumDiag1+=State[i][i];
    sumDiag2+=State[n-1-i][i];


    if (sumX ==n || sumY==n) {
      if (sumX==n) {
        line(width/(2*n), i*height/n+height/(2*n), (n-1)*width/n+width/(2*n), i*height/n+height/(2*n));
      } else {
        line(i*width/n+width/(2*n), height/(2*n), i*width/n+width/(2*n), (n-1)*height/n+height/(2*n));
      }
      won=true;
    }
    if (sumX ==0 || sumY==0) {   
      if (sumX==0) {
        line(width/(2*n), i*height/n+height/(2*n), (n-1)*width/n+width/(2*n), i*height/n+height/(2*n));
      } else {
        line(i*width/n+width/(2*n), height/(2*n), i*width/n+width/(2*n), (n-1)*height/n+height/(2*n));
      }
      won=true;
    }
    sumX = 0;
    sumY = 0;
  }

  if (sumDiag1 ==n || sumDiag2==n) {
    if (sumDiag1 == n) {
      line(width/(2*n), height/(2*n), (n-1)*width/n+width/(2*n), (n-1)*height/n+height/(2*n));
    } else {
      line(width/(2*n), (n-1)*height/n+height/(2*n), (n-1)*width/n+width/(2*n), height/(2*n));
    }
    won=true;
  }
  if (sumDiag1 ==0 || sumDiag2==0) { 
    if (sumDiag1 == 0) {
      line(width/(2*n), height/(2*n), (n-1)*width/n+width/(2*n), (n-1)*height/n+height/(2*n));
    } else {
      line(width/(2*n), (n-1)*height/n+height/(2*n), (n-1)*width/n+width/(2*n), height/(2*n));
    }
    won=true;
  }

  sumDiag1 = 0;
  sumDiag2 = 0;
}
