int ResistorCount;
int VoltageSourceCount;
int CurrentSourceCount;
int DiodeCount;
int CapacitorCount;
int InductorCount;
class Bauteil {
  ArrayList<Connector> Connectors=new ArrayList();
  Complex VPlus=new Complex();
  Complex VMinus=new Complex();

  PVector absPos;
  String Name;
  boolean selected;
  boolean hovered;
  float rotation;

  Complex Resistance;
  Complex VoltageSource;
  Complex CurrentSource;
  Complex Vacross=new Complex();
  Complex Current=new Complex();

  Resistor R;
  VoltageSource U;
  CurrentSource I;
  Diode D;
  Capacitor C;
  Inductor L;

  Bauteil(Resistor R) {
    this.R=R;
    this.absPos=R.absPos;
    R.B=this;

    Name="R"+ResistorCount;
    R.Name=Name;
    Resistance=R.resistance;

    ResistorCount++;
    addConnectors();
  }

  Bauteil(Capacitor C) {
    this.C=C;
    this.absPos=C.absPos;
    C.B=this;

    Name="C"+CapacitorCount;
    C.Name=Name;
    Resistance=C.val;

    CapacitorCount++;
    addConnectors();
  }

  Bauteil(Inductor L) {
    this.L=L;
    this.absPos=L.absPos;
    L.B=this;

    Name="L"+InductorCount;
    L.Name=Name;
    Resistance=L.val;

    InductorCount++;
    addConnectors();
  }


  Bauteil(VoltageSource U) {
    this.U=U;
    this.absPos=U.absPos;
    U.B=this;

    Name="U"+VoltageSourceCount;
    U.Name=Name;
    VoltageSource=U.Voltage;
    Vacross=VoltageSource;
    Resistance=U.ri;

    VoltageSourceCount++;
    addConnectors();
  }

  Bauteil(CurrentSource I) {
    this.I=I;
    this.absPos=I.absPos;
    I.B=this;
    Name="I"+CurrentSourceCount;

    CurrentSource=I.current;
    I.Name=Name;

    VoltageSourceCount++;
    addConnectors();
  }

  Bauteil(Diode D) {
    this.D=D;
    this.absPos=D.absPos;
    D.B=this;
    CurrentSource=new Complex();

    Name="D"+DiodeCount;
    D.Name=Name;

    DiodeCount++;
    addConnectors();
  }


  /////////////////////////////////////////////////////////////////
  void addConnectors() {
    Connectors.add(new Connector(this, "P"));
    Connectors.add(new Connector(this, "N"));
  }

  /////////////////////////////////////////////////////////////////
  void update() {
    if (selected) {
      absPos=mousePos;
    }
    if (R!=null||C!=null||L!=null) {
      Current=div(Vacross, Resistance);
    }
    if (U!=null) {
      if (Vacross.re!=0||Vacross.im!=0) {
        Current=div(sub(VoltageSource, Vacross), Resistance);
      } else {
        Current.scale(0);
      }
    }
    if (I!=null) {
      Current= CurrentSource;
    }
    if (D!=null) {
      Current= new Complex(D.Id, 0);
    }
  }



  /////////////////////////////////////////////////////////////////
  void rotate() {
    rotation+=HALF_PI;
    rotation%=TWO_PI;
  }

  /////////////////////////////////////////////////////////////////
  void display() {
    PVector pos=mapToCoordinates(absPos);
    pushMatrix();
    rotateBauteil(this, pos);
    if (R!=null) {
      R.show();
    }
    if (U!=null) {
      U.show();
    }
    if (I!=null) {
      I.show();
    }
    if (D!=null) {
      D.show();
    }
    if (C!=null) {
      C.show();
    }
    if (L!=null) {
      L.show();
    }

    for (Connector C : Connectors) {
      C.absPos=absPos.copy().add(round(-sin(rotation)*C.dir/len), round(cos(rotation)*C.dir/len));
      C.show();
    }
    popMatrix();
  }

  void hover() {
    if (millis()-tLastMoved>500) {
      hovered=false;
      if (absPos.equals(mousePos)) {
        hovered=true;
      }
      if (hovered) {
        showTextOnHud(Current, "A");
      }
    }
  }
}



/////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
class Connector {
  Bauteil B;
  Node inNode;
  PVector absPos;
  String Pin;
  float dir=len;
  Complex Voltage=new Complex();

  Connector(Bauteil B, String Pin) {
    this.B=B;
    this.Pin=Pin;
    if (Pin=="P") {
      dir*=-1;
    }
  }

  void show() {
    stroke(0);
    fill(255, 0, 0);
    ellipse(0, dir, 8, 8);
    fill(0);
  }
}
