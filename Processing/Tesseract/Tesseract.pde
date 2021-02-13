import peasy.*;

float tesseract[][]=new float[16][];
float projected[][]=new float[16][];
float ds=0.005;


PeasyCam cam;

void setup() {
  size(600, 600, P3D);
  textAlign(CENTER, CENTER);
  strokeWeight(2);
  textSize(8);

  float scale=70;
  for (int i=0; i < 16; i++) {
    tesseract[i]=new float[]{scale*(2*(i%2)-1), scale*(2*(i/2%2)-1), scale*(2*(i/4%2)-1), scale*(2*(i/8%2)-1)};
  }


  cam = new PeasyCam(this, 500);

}

void draw() {
  background(50);
  translate(width/2, height/2);


setRotations();


  for (int i=0; i < 16; i++) {
    float[] toProject=tesseract[i];

    toProject=matmul(rotXY, toProject);
    toProject=matmul(rotZW, toProject);
    toProject=matmul(rotXZ, toProject);

    projected[i]=projectDown(toProject);
  }



  //////////
  stroke(0, 80, 80);
  connect(0, 1);
  connect(0, 2);
  connect(0, 4);

  connect(6, 2);
  connect(6, 4);
  connect(6, 7);

  connect(5, 1);
  connect(5, 7);
  connect(5, 4);

  connect(3, 1);
  connect(3, 2);
  connect(3, 7);

  //////////
  // stroke(0, 120, 120);

  connect(8, 9);
  connect(8, 10);
  connect(8, 12);

  connect(14, 10);
  connect(14, 12);
  connect(14, 15);

  connect(11, 9);
  connect(11, 10);
  connect(11, 15);

  connect(13, 9);
  connect(13, 12);
  connect(13, 15);

  //////////
  //stroke(0, 140, 140);

  connect(0, 8);
  connect(1, 9);
  connect(5, 13);
  connect(4, 12);

  connect(7, 15);
  connect(14, 6);
  connect(10, 2);
  connect(11, 3);



  for (int i=0; i < 16; i++) {
    fill(0);
    stroke(0);
    pushMatrix();
    translate( projected[i][0], projected[i][1], projected[i][2]);
    sphere(5);
    popMatrix();
    fill(255);
    text(i, projected[i][0], projected[i][1]+10, projected[i][2]);
  }
}
