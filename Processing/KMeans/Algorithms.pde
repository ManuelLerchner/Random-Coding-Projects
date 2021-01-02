
////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////
void Lloyd(int k) {

  if (Clusters.size()==0) {
    for (int i=0; i < k; i++) {
      PVector pos = new PVector(random(50, width-50), random(50, height-50));
      Clusters.add(new Cluster(pos, i));
    }
  }
  for (Cluster c : Clusters) {
    c.Edge.clear();
    c.Points.clear();
  }


  //Set Points to nearest cluster
  for (Point p : Points) {
    float minDist=Float.MAX_VALUE;
    Cluster best=new Cluster();

    for (Cluster c : Clusters) {
      float dist=sq(c.pos.x-p.pos.x)+sq(c.pos.y-p.pos.y);

      if (dist<minDist) {
        minDist=dist;
        best=c;
      }
    }
    p.cluster=best.num;
    best.Points.add(p);
  }

  //Move cluster to mean pos
  for (Cluster c : Clusters) {
    PVector average=new PVector(0, 0);

    for (Point p : c.Points) {
      average.add(p.pos);
    }
    average.div(c.Points.size());
    c.pos=average;
  }

  //Find Edges
  for (Cluster c : Clusters) {
    if (c.Points.size()>=2) {
      c.Edge=GrahamScan(c.Points);
    }
  }
}

////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////
ArrayList<Point> GrahamScan(ArrayList<Point> points) {
  float minY=Float.MIN_VALUE;
  Point ptStart=new Point();
  for (Point p : points) {
    if (p.pos.y>=minY) {
      minY=p.pos.y;
      ptStart=p;
    }
  }

  for (Point p : points) {
    p.alpha=atan2(-(p.pos.y - ptStart.pos.y), (p.pos.x  - ptStart.pos.x));
  }
  bubbleSort(points);


  int i=1;
  while (i<points.size()-1) {
    if (isLeft(points.get(i-1).pos, points.get(i+1).pos, points.get(i).pos)>0) {
      i++;
    } else {
      points.remove(i);
      i--;
    }
  }

  return points;
}


float  isLeft(PVector A, PVector B, PVector C) {
  return (B.x - A.x) * (C.y - A.y) - (C.x - A.x) * (B.y - A.y);
}


////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////
void bubbleSort(ArrayList<Point> arr) { 
  int n = arr.size(); 
  for (int i = 0; i < n; i++) {
    for (int j = 0; j < n-i-1; j++) { 
      if (arr.get(j).alpha > arr.get(j+1).alpha) { 
        Point temp = arr.get(j); 
        arr.set(j, arr.get(j+1)); 
        arr.set(j+1, temp);
      }
    }
  }
}



////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////
color hsv2rgb(float hue, float saturation, float value) {
  int h = (int)(hue * 6);
  float f = hue * 6 - h;
  float p = value * (1 - saturation);
  float q = value * (1 - f * saturation);
  float t = value * (1 - (1 - f) * saturation);

  switch (h) {
  case 0: 
    return color(255*value, 255*t, 255*p);
  case 1: 
    return color(255*q, 255*value, 255* p);
  case 2: 
    return color(255*p, 255*value, 255*t);
  case 3: 
    return color(255*p, 255*q, 255*value);
  case 4: 
    return color(255*t, 255*p, 255*value);
  case 5: 
    return color(255*value, 255*p, 255*q);
  default: 
    throw new RuntimeException("Something went wrong when converting from HSV to RGB. Input was " + hue + ", " + saturation + ", " + value);
  }
}

////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////
PVector randPVector(PVector pos, float range) {
  float x=randomGaussian()*range;
  float y=randomGaussian()*range;
  return new PVector(x+pos.x, y+pos.y);
}
