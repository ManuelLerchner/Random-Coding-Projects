///////////////////////////////////////////////////////////////////////////////
void calcFun() {
  double dx=stepX/scale;
  double xMin=mapPixelToPoint(-width/2/scale, 0).x-1;
  double xMax=mapPixelToPoint(width/2/scale, 0).x+1;
  for (double x=xMin; x <= xMax; x+=dx) {
    Vec2 Pix = mapPointToPixel(x, y(x), true);
    fun.add(Pix);
  }
}

///////////////////////////////////////////////////////////////////////////////
void calcDer() {
  for (int i=0; i < maxDerivative; i++) {
    if (i==0) {
      HigherDerivatives.add(derive(fun));
    } else {
      HigherDerivatives.add(derive(HigherDerivatives.get(i-1)));
    }
  }
}

///////////////////////////////////////////////////////////////////////////////
void showFunction_setSpecialPoints(ArrayList<Vec2> f, color col, int der) {
  stroke(col);
  noFill();
  beginShape();
  for (int i = 0; i <f.size()-1; i++) {
    Vec2 t = f.get(i);
    Vec2 n = f.get(i+1);
    Vec2 coordT = mapPixelToPoint(t.x, t.y);
    Vec2 coordN = mapPixelToPoint(n.x, n.y);
    if (!keys.hasValue(str(der))) {
      if (!Double.isNaN(coordT.y)) {
        if (Math.abs(t.y-n.y)<width) {
          if (onScreen(coordT.y)) {
            vertex((float)t.x, (float)t.y);
          } else {
            endShape();
            beginShape();
          }
        } else {
          vertex((float)t.x, (float)t.y);
          endShape();
          beginShape();
          if (scale>0.3) {
            if (SpecialPoints.size()<maxSpecialPoints) {
              SpecialPoint Pole= new SpecialPoint(new Vec2(coordT.x, 0), "Pole");
              if (!AlreadyAddedSpecialPoint(Pole)) {
                SpecialPoints.add(Pole);
              }
            }
          }
        }
      }
    }
    if (scale>0.2) {
      if (SpecialPoints.size()<maxSpecialPoints) {
        if (signChange(coordT.y, coordN.y)) {
          SpecialPoint Prototype= new SpecialPoint(new Vec2(coordT.x, y(coordT.x)), der);
          if (!AlreadyAddedSpecialPoint(Prototype)) {
            double test=newton(coordT.x, f, 3);
            if (Math.abs(test-coordT.x)<0.05) {
              Prototype= new SpecialPoint(new Vec2(test, y(coordT.x)), der);
              if (!AlreadyAddedSpecialPoint(Prototype)) {
                SpecialPoints.add(Prototype);
              }
            }
          }
        }
      }
    }
  }
  endShape();
}

///////////////////////////////////////////////////////////////////////////////
boolean onScreen(double y) {
  double yMin=mapPixelToPoint(0, width/2/scale).y-1;
  double yMax=mapPixelToPoint(0, -width/2/scale).y+1;
  if (y>yMin && y<yMax) {
    return true;
  }
  return false;
}

///////////////////////////////////////////////////////////////////////////////
boolean AlreadyAddedSpecialPoint(SpecialPoint Prototype) {
  for (SpecialPoint p : SpecialPoints) {
    if (distV(p.koordPos, Prototype.koordPos)<0.2) {
      if (p.orderDerivative==Prototype.orderDerivative) {
        if (p.Name==Prototype.Name) {
          if (Math.abs(y(Prototype.koordPos.x))<0.2) {
            if (Math.abs(p.koordPos.y)>Math.abs(Prototype.koordPos.y)) {
              p.koordPos=Prototype.koordPos;
            }
          }
          return true;
        }
      }
    }
  }
  return false;
}

///////////////////////////////////////////////////////////////////////////////
void showAxes() {
  float X0=(float)transOffset.x;
  float Y0=(float)transOffset.y;
  float X1 = (float)(map(1, (float)-rangeX/2, (float)rangeX/2, -width/2, width/2)+transOffset.x);
  float Y1 = (float)(map(-1, (float)-rangeY/2, (float)rangeY/2, -height/2, height/2)+transOffset.y);
  stroke(0);
  fill(0);
  line(X0, -(float)(1/scale)*height/2, X0, (float)(1/scale)*height/2);
  line(-(float)(1/scale)*width/2, Y0, (float)(1/scale)*width/2, Y0);
  ellipse(X0, Y1, 4, 4);
  ellipse(X1, Y0, 4, 4);
  fill(255);
  text("1", X1, Y0);
  text("1", X0, Y1);
}

///////////////////////////////////////////////////////////////////////////////
ArrayList<Vec2> derive(ArrayList<Vec2> Points) {
  ArrayList<Vec2> Derivative=new ArrayList();
  for (int i=1; i < Points.size()-1; i++) {
    double d=(Points.get(i+1).y-Points.get(i).y)/(Points.get(i+1).x-Points.get(i).x);
    Derivative.add(mapPointToPixel(Points.get(i).x, d, false));
  }
  Derivative=smoothFunction(Derivative, 10);
  return Derivative;
}

///////////////////////////////////////////////////////////////////////////////
Vec2 mapPointToPixel(double x, double y, boolean mapX) {
  Vec2 out=new Vec2(x, y);
  if (mapX) {
    out.x=mapDouble(x, -rangeX/2, rangeX/2, -width/2, width/2);
  }
  out.y=mapDouble(y, -rangeY/2, rangeY/2, height/2, -height/2);
  if (mapX) {
    out.x+=(transOffset).x;
  } else {
    out.y*=-1;
  }
  out.y+=(transOffset).y;
  return out;
}

///////////////////////////////////////////////////////////////////////////////
Vec2 mapPixelToPoint(double x, double y) {
  Vec2 out=new Vec2(x, 0);
  out.x=mapDouble(x, -width/2, width/2, (-rangeX/2-rangeX*transOffset.x/width), (rangeX/2-rangeX*transOffset.x/width));
  out.y=-mapDouble(y, -height/2, height/2, (-rangeY/2-rangeY*transOffset.y/height), (rangeY/2-rangeY*transOffset.y/height));
  return out;
}

///////////////////////////////////////////////////////////////////////////////
double mapDouble(double x, double in_min, double in_max, double out_min, double out_max) {
  return (x - in_min) * (out_max - out_min) / (in_max - in_min) + out_min;
}

///////////////////////////////////////////////////////////////////////////////
ArrayList<Vec2> smoothFunction( ArrayList<Vec2> fun, int nei) {
  ArrayList<Vec2> smooth= new ArrayList();
  for (int i=0; i < fun.size(); i++) {
    double newY=fun.get(i).y, sumWeights=0;
    for (int j=0; j < nei; j++) {
      if (i>j && i<fun.size()-j) {
        if (Math.abs(fun.get(i-j).y-fun.get(i+j).y)<width) {
          sumWeights+=10/((double)j+1);
          newY+=10/((double)j+1)*(fun.get(i-j).y+fun.get(i+j).y);
        }
      }
    }
    newY/=(2*sumWeights);
    smooth.add(new Vec2(fun.get(i).x, newY));
  }
  return smooth;
}

///////////////////////////////////////////////////////////////////////////////
boolean signChange(double yPrev, double yNow) {
  if (yPrev*yNow<=0&&Math.abs(yPrev-yNow)<0.1 || Math.abs(yNow)<0.01) {
    return true;
  }
  return false;
}

///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
double newton(double X, ArrayList<Vec2> func, int steps) {
  for (int i=0; i < steps; i++) {
    int inFun = IndexOfClosestToX(X, func);
    double f=mapPixelToPoint(0, func.get(inFun).y).y;
    double d= deriveExplicit(X, func);
    X=X- f/d;
  }
  return X;
}

///////////////////////////////////////////////////////////////////////////////
double deriveExplicit(double x, ArrayList<Vec2> Points) {
  double d=0;
  int bestIndex=IndexOfClosestToX(x, Points);
  d =-(Points.get(bestIndex+1).y-Points.get(bestIndex).y)/(Points.get(bestIndex+1).x-Points.get(bestIndex).x);
  return d;
}

///////////////////////////////////////////////////////////////////////////////
int IndexOfClosestToX(double x, ArrayList<Vec2> Points) {
  double xBest=1000;
  int bestIndex=0;
  for (int i=1; i < Points.size()-1; i++) {
    Vec2 v=mapPixelToPoint(Points.get(i).x, Points.get(i).y);
    if (Math.abs(v.x-x)<xBest) {
      xBest=Math.abs(v.x-x); 
      bestIndex=i;
    }
  }
  return bestIndex;
}

///////////////////////////////////////////////////////////////////////////////
void showOverlay() {
  fill(255, 100);
  stroke(0);
  ellipse(width/2, height/2, 7, 7);
  if (showOverlay) {
    fill(70, 200);
    stroke(20);
    float hei = OverlayNames.size()*15+45;
    rect(mouseX, mouseY, 95, hei);

    fill(255);
    float x = roundToNPlaces(OverlayVal.x, 5);
    float y = roundToNPlaces(OverlayVal.y, 5);
    text("x = "+x +"\ny = " +y, mouseX+5, mouseY+15);

    float off=0;
    for (String s : OverlayNames) {
      text(s, mouseX+5, mouseY+50+off);
      off+=15;
    }
  }
  fill(70, 200);
  rect(width-95, height-40, 82.5, 30);
  fill(255);
  float x = roundToNPlaces(mousePos.x, 4);
  float y = roundToNPlaces(mousePos.y, 4);
  text("x = "+x +"\ny = " +y, width-95+5, height-40+12);

  String displayFunction =inputTemp.subSequence(0, cursorPos).toString()+"|"+inputTemp.subSequence(cursorPos, inputTemp.length()).toString();

  fill(130, 80, 10, 200);
  if (inputSelected) {
    fill(180, 120, 0, 200);
  }
  rect(10, height-40, textWidth("y = "+displayFunction)+15, 30);
  if (InputIsLive) {
    fill(0, 120, 0, 100);
  }

  rect(10, height-40, textWidth("y = "+displayFunction)+15, 30);
  fill(255);
  text("y = "+displayFunction, 20, height-40+20);
  
  //Help
  text("maxDer: ArrUp||ArrDo\nReset:    SPACE",10,20);
}


///////////////////////////////////////////////////////////////////////////////
float roundToNPlaces(double val, int n) {
  val*=pow(10, n);
  val=Math.round(val);
  val/=pow(10, n);
  return (float)val;
}
