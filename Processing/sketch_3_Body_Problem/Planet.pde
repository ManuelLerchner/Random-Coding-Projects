class Planet {
  PVector pos;
  PVector speed;
  PVector acc = new PVector();
  float mass;

  Planet(PVector pos_, PVector speed_, float mass_) {
    pos = pos_;
    speed = speed_;
    mass=mass_;
  }


  void show() {
    pushMatrix();
    noStroke();
    lights();
    translate(pos.x, pos.y);
    sphere( sqrt(mass*mass));
    popMatrix();
  }

  void move() {



    for (Planet p : Planets) {

      float dist = dist(pos.x, pos.y, p.pos.x, p.pos.y);

      if (dist != 0) {
        PVector cons = new PVector(pos.x-p.pos.x, pos.y-p.pos.y);

        speed.add(   (cons.div(pow(cons.mag(), 3))).mult(p.mass*-G) );
        pos.add((speed));
      }
    }
  }
}
