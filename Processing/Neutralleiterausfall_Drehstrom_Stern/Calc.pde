void calculate() {
  ArrayList<Arrow> myVec;

  if (N_LeiterVorhanden) {
    myVec=calc4Leiter(U_l1, U_l2, U_l3, Z1, Z2, Z3);
  } else {
    myVec=calc3Leiter(U_l1, U_l2, U_l3, Z1, Z2, Z3);
  }


  //Rescale Current Arrow
  float maxVoltage=-1;
  float maxCurrent=-1;
  for (Arrow a : myVec) {
    if (a.text.charAt(0)=='U') {
      if (a.val.mag()>maxVoltage) {
        maxVoltage=a.val.mag();
      }
    } else if (a.text.charAt(0)=='I') {
      if (a.val.mag()>maxCurrent) {
        maxCurrent=a.val.mag();
      }
    }
  }
  maxVoltage=min(maxVoltage, 230);

  float scaleCurrent=maxVoltage/maxCurrent;
  for (Arrow a : myVec) {
    if (a.text.charAt(0)=='I') {
      a.internalScale=scaleCurrent;
      a.strokeFactor=0.4;
      a.side=-1;
    }
  }

  Arrows=(myVec);
  //Print to console
  println("\n");
  println("-------------------");
  println("");
  println("R1"+": val:", Z1.polar());
  println("R2"+": val:", Z2.polar());
  println("R3"+": val:", Z3.polar());
  println("");
  println(N_LeiterVorhanden?"Stern 4-Leiter:":"Stern-3-Leiter:");
  println("");
  for (Arrow v : Arrows) {
    println(v.text+": val:", v.val.polar());
  }
  println("\nStröme im Zeigerdiagramm wurden mit dem Faktor", round(1000*scaleCurrent)/1000.0, "skaliert");
  println("-------------------");
  child.redraw();
}


void BauteileWobbeln() {
  if (Wobbeln) {
    float t = millis()/15000.0;
    Z1=new Complex("polar", noise(t)*50, (noise(t*8+123)-0.5)*180);   
    Z2=new Complex("polar", noise(t+123)*50, (noise(t*6+123)-0.5)*180);   
    Z3=new Complex("polar", noise(t/4.2+213)*50, (noise(t*3.12+89)-0.5)*180);   
    calculate();
  }
}


///////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////
ArrayList<Arrow> calc4Leiter(Complex V1, Complex V2, Complex V3, Complex R1, Complex R2, Complex R3) {
  surface.setTitle("Stern-4 Leiter");
  ArrayList<Arrow> out = new ArrayList();

  //Leiterströme
  Complex I1=divide(V1, R1);
  Complex I2=divide(V2, R2);
  Complex I3=divide(V3, R3);

  //I_N
  Complex s= new Complex("cartesian", 0, 0);
  s.add(I1);
  s.add(I2);
  s.add(I3);


  //Arrows
  //Main Voltages
  Arrow U1=new Arrow(V1, color(255, 125, 125), "U1");
  Arrow U2=new Arrow(V2, color(125, 255, 125), "U2");
  Arrow U3=new Arrow(V3, color(125, 125, 255), "U3");

  //Current
  Arrow I_l1=new Arrow(I1, color(255, 50, 50), "I_L1");
  Arrow I_l2=new Arrow(I2, color(255, 50, 50), "I_L2");
  Arrow I_l3=new Arrow(I3, color(255, 50, 50), "I_L3");
  Arrow I_N=new Arrow(s, color(255, 250, 50), "I_N");

  //Add to drawList
  out.add(U1);
  out.add(U2);
  out.add(U3);

  out.add(I_l1);
  out.add(I_l2);
  out.add(I_l3);
  out.add(I_N);

  return out;
}



///////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////
ArrayList<Arrow> calc3Leiter(Complex V1, Complex V2, Complex V3, Complex R1, Complex R2, Complex R3) {
  surface.setTitle("Stern-3 Leiter");
  ArrayList<Arrow> out = new ArrayList();

  //Leiterströme old
  Complex I1=divide(V1, R1);
  Complex I2=divide(V2, R2);
  Complex I3=divide(V3, R3);


  //I_N_theortetisch
  Complex I_n= new Complex("cartesian", 0, 0);
  I_n.add(I1);
  I_n.add(I2);
  I_n.add(I3);

  //U0
  Complex one=new Complex("cartesian", 1, 0);
  Complex Z_vonSichtU0 = new Complex("cartesian", 0, 0);

  Z_vonSichtU0.add(divide(one, R1));
  Z_vonSichtU0.add(divide(one, R2));
  Z_vonSichtU0.add(divide(one, R3));

  Complex U0=divide(I_n, Z_vonSichtU0);


  //Voltages new
  Complex U_1_new=sub(V1, U0);
  Complex U_2_new=sub(V2, U0);
  Complex U_3_new=sub(V3, U0);

  //Leiterströme new
  Complex I1_new=divide(U_1_new, R1);
  Complex I2_new=divide(U_2_new, R2);
  Complex I3_new=divide(U_3_new, R3);


  //Create arrows
  //Main Voltages old
  Arrow U1_old=new Arrow(V1, color(255, 50, 125), "U1");
  Arrow U2_old=new Arrow(V2, color(255, 50, 125), "U2");
  Arrow U3_old=new Arrow(V3, color(255, 50, 125), "U3");

  //Volatages new
  Arrow U1_new=new Arrow(U_1_new, color(255, 125, 125), "U_1n");
  Arrow U2_new=new Arrow(U_2_new, color(125, 255, 125), "U_2n");
  Arrow U3_new=new Arrow(U_3_new, color(125, 125, 255), "U_3n");
  Arrow U_N=new Arrow(U0, color(125, 255, 255), "U_N");

  //Current
  Arrow I_l1=new Arrow(I1_new, color(255, 50, 50), "I_L1");
  Arrow I_l2=new Arrow(I2_new, color(255, 50, 50), "I_L2");
  Arrow I_l3=new Arrow(I3_new, color(255, 50, 50), "I_L3");


  //move Arrows
  U1_new.move(U0.re, U0.im);
  U2_new.move(U0.re, U0.im);
  U3_new.move(U0.re, U0.im);

  I_l1.move(U0.re, U0.im);
  I_l2.move(U0.re, U0.im);
  I_l3.move(U0.re, U0.im);


  //Add Arrows to drawList
  out.add(U1_old);
  out.add(U2_old);
  out.add(U3_old);

  out.add(U1_new);
  out.add(U2_new);
  out.add(U3_new);
  out.add(U_N);

  out.add(I_l1);
  out.add(I_l2);
  out.add(I_l3);

  return out;
}
