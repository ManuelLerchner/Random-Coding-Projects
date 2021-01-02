class Pendulum {

  int l1, l2;
  int m1, m2;
  float alpha, beta;
  double speedAlpha, speedBeta;
  int i;
  ArrayList<PVector> Points = new ArrayList<PVector>();
  boolean pause = true;
  long tlast;

  Pendulum(int l1_, int m1_, float alpha_, int l2_, int m2_, float beta_, int i_) {
    l1=l1_;
    m1=m1_;
    alpha=alpha_;
    l2=l2_;
    m2=m2_;
    beta=beta_;
    i=i_;
  }


  void show() {
    //Path
    if (DrawEnabled) {
      PVector pos = new PVector( posX+sin(alpha)*l1+sin(beta)*l2, posY+cos(alpha)*l1+cos(beta)*l2);
      Points.add(pos);
    }

    noFill();
    beginShape();
    for (PVector u : Points) {
      vertex(u.x, u.y);
    }
    endShape();

    float col = map(i, 0, n, 0, 340);

    //L1
    pushMatrix();
    translate(posX, posY);
    strokeWeight(1);
    if (!keyPressed) {
      line(0, 0, sin(alpha)*l1, cos(alpha)*l1);
      strokeWeight(1);
      fill(30, 20, 20);
      ellipse(0, 0, 20, 20);
    }
    popMatrix();

    //L2
    pushMatrix();
    translate(posX+sin(alpha)*l1, posY+cos(alpha)*l1);
    if (!keyPressed) {
      strokeWeight(1);
      line(0, 0, sin(beta)*l2, cos(beta)*l2);
    }
    strokeWeight(1);
    fill(col, 100, 100);
    ellipse(0, 0, 3*sqrt(m1), 3*sqrt(m1));
    ellipse(sin(beta)*l2, cos(beta)*l2, 3*sqrt(m2), 3*sqrt(m2));
    popMatrix();

    if (keyPressed) {
      if ( key == 'r') {
        Points.clear();
      } 
      if (key == 'p' && (millis()-tlast>200)) {
        pause = !pause;
        tlast = millis();
      }
    }
  }


  void move() {
    //Math
    speedAlpha+=  (-g*(2*m1+m2)*sin(alpha)-m2*g*sin(alpha-2*beta)-2*sin(alpha-beta)*m2*( speedBeta*speedBeta*l2+speedAlpha*speedAlpha*l1*cos(alpha-beta)))/(l1*( 2*m1+m2-m2*cos(2*alpha-2*beta)));
    speedBeta+= (  2*sin(alpha-beta)*(speedAlpha*speedAlpha*l1*(m1+m2)+(g*(m1+m2)*cos(alpha)+speedBeta*speedBeta*l2*m2*cos(alpha-beta))))/((l2*( 2*m1+m2-m2*cos(2*alpha-2*beta))));

    alpha+=(speedAlpha);
    beta+=(speedBeta);
  }
}


void mouseDragged() {
  posX+=(mouseX-pmouseX);
  posY+=(mouseY-pmouseY);
}
