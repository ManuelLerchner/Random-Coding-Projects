//////////////////////////////////////////////////////////////////////////////////
PVector mapToCoordinates(PVector in) {
  return new PVector(map(in.x, 0, N, 0, width), map(in.y, 0, N, 0, height));
}
//////////////////////////////////////////////////////////////////////////////////
PVector mapToGrid(float x, float y) {
  return new PVector(round(map(x, 0, width, 0, N)), round(map(y, 0, height, 0, N)));
}
//////////////////////////////////////////////////////////////////////////////////
PVector mapToGrid(PVector in) {
  return mapToGrid(in.x, in.y);
}

//////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////
void setupMatrix() {
  resetVoltages();
  int size = Nodes.size()-1;
  if (size>0) {
    for (int iter=0; iter < 50; iter++) {

      Complex[][] Matrix = new Complex[size][size];
      Complex[] Vector = new Complex[size]; 
      String[][] StringMatrix = new String[size][size];
      String[] StringVector = new String[size]; 

      //Define Matrix/Vector
      for (int i=0; i < size; i++) {
        StringVector[i]="";
        Vector[i]=new Complex(0, 0);
        for (int j=0; j < size; j++) {
          StringMatrix[i][j]="";
          Matrix[i][j]=new Complex(0, 0);
        }
      }

      //Fill Vector and Matrix
      for (int i=1; i <= size; i++) {
        //SolutionVector
        for (Node N : Nodes) {
          if (N.lineNum==i) {
            for (Connector K : N.Connectors) {
              //Voltage Source
              if (K.B.U!=null) {
                StringVector[i-1]+=K.B.Name+"_"+K.Pin+" ";
                Complex voltage=(K.Pin=="P")?K.B.VoltageSource:scale(K.B.VoltageSource, -1);
                Vector[i-1]=add(Vector[i-1], mult(voltage, Reciprocal(K.B.Resistance)));
              }
              //Current Source
              if (K.B.I!=null) {
                StringVector[i-1]+=K.B.Name+"_"+K.Pin+" ";
                Complex current=(K.Pin=="P")?K.B.CurrentSource:scale(K.B.CurrentSource, -1);
                Vector[i-1]=add(Vector[i-1], current);
              }
              //Diode
              if (K.B.D!=null) {
                StringVector[i-1]+=K.B.Name+"_"+K.Pin+" ";
                Complex current=(K.Pin=="N")?K.B.CurrentSource:scale(K.B.CurrentSource, -1);
                Vector[i-1]=add(Vector[i-1], current);
              }
            }
          }
        }
        //Matrix
        for (int j=1; j <= size; j++) {
          for (Node N : Nodes) {
            for (Node O : Nodes) {
              if (N.lineNum==i && O.lineNum==j) {
                for (Connector K : N.Connectors) {
                  for (Connector L : O.Connectors) {
                    if (K.B==L.B) {
                      if (K.B.Resistance!=null) {
                        StringMatrix[i-1][j-1]+=K.B.Name+" ";
                        Complex add=(i==j)?K.B.Resistance:scale(K.B.Resistance, -1);
                        Matrix[i-1][j-1]=add(Matrix[i-1][j-1], Reciprocal(add) );
                      }
                    }
                  }
                }
              }
            }
          }
        }
      }


      //println("\nMatrix");
      //LinSolve.printMatrix(StringMatrix);
      //println("Sol. Vector");
      //LinSolve.printVector(StringVector);
      // println("Matrix");
      //LinSolve.printMatrix(Matrix);
      //LinSolve.printVector(Vector);
      //  println("solution");
      Complex[] solution=LinSolve.solve(Matrix, Vector);
      //     LinSolve.printVector(solution);


      //Pass Voltages into Connectors and Lines
      for (int i=1; i<size+1; i++) {
        for (Node N : Nodes) {
          if (N.lineNum==i) {
            //Lines
            for (Line L : Lines) {
              if (L.index==i) {
                L.Voltage=solution[i-1];
              }
              //Connectors
              for (Connector C : N.Connectors) {
                C.Voltage=solution[i-1];
                if (C.Pin=="P") {
                  C.B.VPlus=C.Voltage;
                } else {
                  C.B.VMinus=C.Voltage;
                }
              }
            }
          }
        }
      }
      for (Node N : Nodes) {
        if (N.lineNum==0) {
          for (Line L : Lines) {
            if (L.index==0) {
              L.Voltage=new Complex();
            }
            //Connectors
            for (Connector C : N.Connectors) {
              C.Voltage=new Complex();
              if (C.Pin=="P") {
                C.B.VPlus=C.Voltage;
              } else {
                C.B.VMinus=C.Voltage;
              }
            }
          }
        }
      }
      for (Bauteil B : Bauteile) {
        B.Vacross=sub(B.VPlus, B.VMinus);
        if (B.D!=null) {
          B.D.calc();
        }
      }
    }
  }
}

//////////////////////////////////////////////////////////////////////////////////
void resetVoltages() {
  for (Bauteil B : Bauteile) {
    B.VPlus=new Complex();
    B.VMinus=new Complex();
    B.Vacross=new Complex();
    B.Current=new Complex();
    if (B.D!=null) {
      B.D.Id=0;
      B.D.Ieq=0;
      B.D.geq=0;
    }
    for (Connector C : B.Connectors) {
      C.Voltage=new Complex();
    }
  }
  for (Line L : Lines) {
    L.Voltage=new Complex();
  }
}
