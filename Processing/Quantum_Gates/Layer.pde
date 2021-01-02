class Layer {
  Complex[][] Gate;
  Complex[][] mat;

  int pos, pos2;
  String name;

  ///////////////////////////////////////////////////////////////////////////////////
  Layer(String Gate, int pos) {
    this.Gate=findGate(Gate);
    this.pos=pos-1;
    name=Gate;
    calcMatSingle();
  }

  Layer(String Gate, int pos1, int pos2) {
    this.Gate=findGate(Gate);
    this.pos=pos1-1;
    this.pos2=pos2-1;
    name=Gate;
    calcMatDouble();
  }

  ///////////////////////////////////////////////////////////////////////////////////
  void calcMatSingle() {
    if (pos==0) {
      mat=Gate;
    } else {
      mat=IDENTITY;
    }

    for (int i=1; i < AmountQubits; i++) {
      if (i==pos) {
        mat=KroneckerProduct(mat, Gate);
      } else {
        mat=KroneckerProduct(mat, IDENTITY);
      }
    }
  }


  ///////////////////////////////////////////////////////////////////////////////////
  void calcMatDouble() {
    if (pos2<pos || abs(pos2-pos)>1 || pos2>AmountQubits-1) {
      println("ERROR_Wrong Gate Positions");
      exit();
    }

    if (pos==0 && pos2==1) {
      mat=Gate;
    } else {
      mat=IDENTITY;
    }

    for (int i=1; i < AmountQubits-1; i++) {
      if (i==pos) {
        mat=KroneckerProduct(mat, Gate);
      } else {
        mat=KroneckerProduct(mat, IDENTITY);
      }
    }
  }
}
