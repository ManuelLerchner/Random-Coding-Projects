class Ray {

  ArrayList<Ray> subRays=new ArrayList();

  PVector origin;  
  PVector end;
  float angle;

  float speed=1;
  int count;

  float len;

  Color col=new Color(0, 0, 0, 1)  ;


  boolean hit=false;

  boolean hitWall;

  Object insideObject;

  Ray Parent;


  Ray(PVector origin, float angle, int counter, Ray Parent) {
    this.origin=origin;
    this.angle=angle;
    this.count=counter;
    this.Parent=Parent;

    reset();
  }

  Ray(PVector origin, float angle, int counter, Ray Parent, Object insideObject) {
    this.origin=origin;
    this.angle=angle;
    this.count=counter;
    this.insideObject=insideObject;
    this.Parent=Parent;

    reset();
  }



  void show() {

    stroke(col);

    line(origin.x, origin.y, end.x, end.y);
  }



  void reset() {
    hit=false;
    subRays.clear();
    end=origin.copy();
    marge();
    setColor();
  }

  void marge() {

    int iter=0;

    if (count>=0) {
      while (!hit && iter<1000) {
        iter++;



        Object Target=null;

        if (insideObject==null) {
          for (Object O : Objects) {
            if (O.isInside(end)) {
              Target=O;
              hit=true;
              step(end, -speed);
              break;
            }
          }
        } else {
          PVector inSide=end.copy();
          step(inSide, speed);

          if (!insideObject.isInside(inSide)) {
            Target=insideObject;
            hit=true;
            end=inSide;
          }
        }


        if (!hit) {

          //normal step
          step(end, speed);
          if (outSideFrame(end)) {
            hit=true;
          }
        } else {
          len=end.dist(origin);
          //pass on
          PVector next=end.copy();
          step(next, speed);



          //refract
          subRays.add(new Ray(end.copy(), refractAngle(angle, end, Target), count-1, this));

          if (insideObject==null) {
            //coming in
            subRays.add(new Ray(next, snell(angle, end, Target, 0), count-1, this, Target));
          } else {
            //coming out
            subRays.add(new Ray(next, snell(angle, end, Target, 1), count-1, this));
          }

          col=Target.getColor();
        }
      }
    }
  }


  void setColor() {

    for (Ray R : subRays) {

      col=rgbaSum(col, R.col, 0.5);
    }
  }

  float refractAngle(float angle, PVector pos, Object Target) {

    float normal=Target.surfaceNormal(pos).heading()+PI;
    float theta_1=angle+normal;
    float theta_2=-theta_1;
    float out=theta_2-normal+PI;

    return out;
  }


  float snell(float angle, PVector pos, Object Target, int inside) {

    float normal=Target.surfaceNormal(pos).heading()+PI+inside*PI;
    float theta_1=angle+normal;
    float theta_2=asin(1/Target.getRefractiveIndex()*sin(theta_1));
    float out=theta_2-normal;

    return out;
  }


  boolean outSideFrame(PVector pos) {
    if (pos.x<-10 || pos.x>width+10 || pos.y<-10 || pos.y>height+10 ) {
      col=new Color(0, 0, 0, 0.1);
      hitWall=true;
      return true;
    }
    return false;
  }

  void step(PVector in, float dS) {
    in.add(dS*cos(angle), -dS*sin(angle));
  }
}
