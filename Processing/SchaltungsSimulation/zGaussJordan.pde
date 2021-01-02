class GaussJordan {
  double[] InternVector;
  double[][] InternMatrix;
  double[] getSolution(double[][] matIn, double[] VecIn) {
    InternVector=VecIn.clone();
    InternMatrix=matIn.clone();

    int tmpColumn = -1;
    for (int line = 0; line < InternMatrix.length; line++) {
      tmpColumn = -1;
      for (int column = 0; column < InternMatrix[line].length; column++) {
        for (int row = line; row < InternMatrix.length; row++) {
          if (InternMatrix[row][column] != 0) {
            tmpColumn = column;
            break;
          }
        }
        if (tmpColumn != -1) {
          break;
        }
      }
      if (tmpColumn == -1) {
        for (int row = line; row < InternMatrix.length; row++) {
          if (InternVector[line] != 0) {
            ErrorMessage="Gleichungssystem besitzt keine Loesung";
          }
        }
        if (InternMatrix[0].length - 1 >= line) {
          ErrorMessage="Gleichungssystem nicht eindeutig loesbar";
        }
        break;
      }
      if (InternMatrix[line][tmpColumn] == 0) {
        for (int row = line + 1; row < InternMatrix.length; row++) {
          if (InternMatrix[row][tmpColumn] != 0) {
            swapTwoLines(line, row, InternMatrix, InternVector);
            break;
          }
        }
      }
      if (InternMatrix[line][tmpColumn] != 0) {
        divideLine(line, InternMatrix[line][tmpColumn], InternMatrix, InternVector);
      }
      for (int row = line + 1; row < InternMatrix.length; row++) {
        removeRowLeadingNumber(InternMatrix[row][tmpColumn], line, row, InternMatrix, InternVector);
      }
    }
    for (int column = InternMatrix[0].length - 1; column > 0; column--) {
      for (int row = column; row > 0; row--) {
        removeRowLeadingNumber(InternMatrix[row - 1][column], column, row - 1, InternMatrix, InternVector);
      }
    }
    return InternVector;
  }

  void swapTwoLines(int rowOne, int rowTwo, double[][] InternMatrix, double[] InternVector) {
    double[] tmpLine;
    double tmpVar;
    tmpLine = InternMatrix[rowOne];
    tmpVar = InternVector[rowOne];
    InternMatrix[rowOne] = InternMatrix[rowTwo];
    InternVector[rowOne] = InternVector[rowTwo];
    InternMatrix[rowTwo] = tmpLine;
    InternVector[rowTwo] = tmpVar;
  }

  void divideLine(int row, double div, double[][] InternMatrix, double[] InternVector) {
    for (int column = 0; column < InternMatrix[row].length; column++) {
      InternMatrix[row][column] = InternMatrix[row][column] / div;
    }
    InternVector[row] = InternVector[row] / div;
  }

  void removeRowLeadingNumber(double factor, int rowRoot, int row, double[][] InternMatrix, double[] InternVector) {
    for (int column = 0; column < InternMatrix[row].length; column++) {
      InternMatrix[row][column] = InternMatrix[row][column] - factor * InternMatrix[rowRoot][column];
    }
    InternVector[row] = InternVector[row] - factor * InternVector[rowRoot];
  }

  void printMatrix(String[][] M) {
    for (int row = 0; row < M.length; row++) {
      print("("); 
      for (int column = 0; column < M[row].length; column++) {
        if (column != 0) {
          print(",");
        }
        for (int i=0; i <  10-M[row][column].length(); i+=1) {
          print(" ");
        }
        print(M[row][column]); 
        for (int i=0; i <  3; i+=1) {
          print(" ");
        }
      }
      println(")");
    }
    println(" ");
  }

  void printMatrix(double[][] M) {
    for (int row = 0; row < M.length; row++) {
      print("("); 
      for (int column = 0; column < M[row].length; column++) {
        if (column != 0) {
          print(",");
        }
        for (int i=0; i <  2; i+=1) {
          print(" ");
        }
        print(M[row][column]); 
        for (int i=0; i <  3; i+=1) {
          print(" ");
        }
      }
      println(")");
    }
    println(" ");
  }


  void printVector(double[] V) {
    for (int row = 0; row < V.length; row++) {
      print("("); 
      for (int i=0; i <  2; i+=1) {
        print(" ");
      }
      print(V[row]); 
      for (int i=0; i <  2; i+=1) {
        print(" ");
      }
      println(")");
    }
    println(" ");
  }

  void printVector(String[] V) {
    for (int row = 0; row < V.length; row++) {
      print("("); 
      for (int i=0; i <  10-V[row].length(); i+=1) {
        print(" ");
      }
      print(V[row]); 
      for (int i=0; i <  2; i+=1) {
        print(" ");
      }
      println(")");
    }
    println(" ");
  }
}
