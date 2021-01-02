class UTILITY {
  PVector pos=new PVector(0, 0);
  boolean selected, highlighted;
  ArrayList<Connector> Connectors=new ArrayList();
  boolean[] state;
  boolean[] invert;
  String type;
  int index;

  AND AND;
  OR OR;
  NOR NOR;
  NAND NAND;
  NOT NOT;
  XOR XOR;
  EQU EQU;
  BUTTON BUTTON;
  TORCH TORCH;
  ADDER ADDER;

  /////////////////////////////////////////////////////////////////////////
  UTILITY(AND AND, PVector pos) {
    this.pos=pos;
    this.AND=AND;
    AND.Parent=this;
    type="AND";
    Connectors=createConnectors(this, THREEPORT);
    state=new boolean[Connectors.size()];
    invert=new boolean[Connectors.size()];
  }


  UTILITY(OR OR, PVector pos) {
    this.pos=pos;
    this.OR=OR;
    OR.Parent=this;
    type="OR";
    Connectors=createConnectors(this, THREEPORT);
    state=new boolean[Connectors.size()];
    invert=new boolean[Connectors.size()];
  }

  UTILITY(NOT NOT, PVector pos) {
    this.pos=pos;
    this.NOT=NOT;
    NOT.Parent=this;
    type="NOT";
    Connectors=createConnectors(this, DUALPORT);
    state=new boolean[Connectors.size()];
    invert=new boolean[Connectors.size()];
    state[1]=true;
    Connectors.get(1).state=true;
  }

  UTILITY(NAND NAND, PVector pos) {
    this.pos=pos;
    this.NAND=NAND;
    NAND.Parent=this;
    type="NAND";
    Connectors=createConnectors(this, THREEPORT);
    state=new boolean[Connectors.size()];
    invert=new boolean[Connectors.size()];
    state[2]=true;
    Connectors.get(2).state=true;
  }

  UTILITY(NOR NOR, PVector pos) {
    this.pos=pos;
    this.NOR=NOR;
    NOR.Parent=this;
    type="NOR";
    Connectors=createConnectors(this, THREEPORT);
    state=new boolean[Connectors.size()];
    invert=new boolean[Connectors.size()];
    state[2]=true;
    Connectors.get(2).state=true;
  }

  UTILITY(XOR XOR, PVector pos) {
    this.pos=pos;
    this.XOR=XOR;
    XOR.Parent=this;
    type="XOR";
    Connectors=createConnectors(this, THREEPORT);
    state=new boolean[Connectors.size()];
    invert=new boolean[Connectors.size()];
  }

  UTILITY(EQU EQU, PVector pos) {
    this.pos=pos;
    this.EQU=EQU;
    EQU.Parent=this;
    type="EQU";
    Connectors=createConnectors(this, THREEPORT);
    state=new boolean[Connectors.size()];
    invert=new boolean[Connectors.size()];
    state[2]=true;
    Connectors.get(2).state=true;
  }

  UTILITY(BUTTON BUTTON, PVector pos) {
    this.pos=pos;
    this.BUTTON=BUTTON;
    type="BUTTON";
    BUTTON.Parent=this;
    Connectors=createConnectors(this, SINGLEPORT_BOT);
    state=new boolean[Connectors.size()];
    invert=new boolean[Connectors.size()];
  }

  UTILITY(ADDER ADDER, PVector pos) {
    this.pos=pos;
    this.ADDER=ADDER;
    type="ADDER";
    ADDER.Parent=this;
    Connectors=createConnectors(this, ADDERPORT);
    state=new boolean[Connectors.size()];
    invert=new boolean[Connectors.size()];
  }


  UTILITY(TORCH TORCH, PVector pos) {
    this.pos=pos;
    this.TORCH=TORCH;
    TORCH.Parent=this;
    type="TORCH";
    Connectors=createConnectors(this, SINGLEPORT_TOP);
    state=new boolean[Connectors.size()];
    invert=new boolean[Connectors.size()];
  }

  /////////////////////////////////////////////////////////////////////////
  void update() {
    pushMatrix();
    translate(globalPanOffset.x+pos.x, globalPanOffset.y+pos.y);

    if (AND!=null) {
      AND.show();
    }
    if (OR!=null) {
      OR.show();
    }
    if (NAND!=null) {
      NAND.show();
    }
    if (NOR!=null) {
      NOR.show();
    }
    if (XOR!=null) {
      XOR.show();
    } 
    if (EQU!=null) {
      EQU.show();
    }
    if (NOT!=null) {
      NOT.show();
    }
    if (BUTTON!=null) {
      BUTTON.show();
    }
    if (TORCH!=null) {
      TORCH.show();
    }

    if (ADDER!=null) {
      ADDER.show();
    }

    for (Connector C : Connectors) {
      C.show();
      C.connect();
    }

    popMatrix();
  }

  /////////////////////////////////////////////////////////////////////////
  void WireUpdate(Connector start, boolean state) {
    boolean stateBevore=start.state;
    ArrayList<Connector> segment=Depth_First_search_Iter(start);

    for (Connector C : segment) {
      if (!C.equals(start)) {
        if (C.U.BUTTON!=null) {
          if (C.U.BUTTON.state==true) {
            state=true;
          }
        }
      }
    }
    for (Connector C : segment) {
      C.state=state;
    }

    if (stateBevore!=state) {
      updateNetwork();
    }
  }

  /////////////////////////////////////////////////////////////////////////
  ArrayList<Connector> Depth_First_search_Iter(Connector start) {
    ArrayList<Connector> Stack=new ArrayList();
    ArrayList<Connector> visited=new ArrayList();
    Stack.add(start);
    while (Stack.size()>0) {
      Connector g=Stack.get(0);
      Stack.remove(0);
      if (!g.updated) {
        g.updated=true;
        visited.add(g);
        for (Connector w : g.connected) {
          Stack.add(w);
        }
      }
    }
    for (Connector C : visited) {
      C.updated=false;
    }
    return visited;
  }

  /////////////////////////////////////////////////////////////////////////
  void Depth_First_search_rec(Connector start, boolean state) {
    start.updated=true;
    start.state=state;
    for (Connector c : start.connected) {
      if (!c.updated) {
        Depth_First_search_rec(start, state);
      }
    }
    start.updated=false;
  }

  /////////////////////////////////////////////////////////////////////////
  void process() {
    Connector out;
    if (TORCH ==null && BUTTON==null) {

      boolean A=state[0], B=state[1], C=false;

      if (AND !=null || OR !=null || NAND !=null || NOR !=null ||XOR !=null ||EQU !=null) {
        //DreiTor
        out= Connectors.get(2);

        if (AND!=null) {
          C = AND.fun(invert[0]^A, invert[1]^B)^invert[2];
        }
        if (OR!=null) {
          C = OR.fun(invert[0]^A, invert[1]^B)^invert[2];
        }
        if (NAND!=null) {
          C = NAND.fun(invert[0]^A, invert[1]^B)^invert[2];
        }
        if (NOR!=null) {
          C = NOR.fun(invert[0]^A, invert[1]^B)^invert[2];
        }
        if (XOR!=null) {
          C = XOR.fun(invert[0]^A, invert[1]^B)^invert[2];
        }
        if (EQU!=null) {
          C = EQU.fun(invert[0]^A, invert[1]^B)^invert[2];
        }
        out.state=C;
        WireUpdate(out, out.state);
      } else {

        if (ADDER !=null) {

          boolean CI= Connectors.get(2).state;
          boolean IA= Connectors.get(0).state;
          boolean IB= Connectors.get(1).state;
          Connector CO= Connectors.get(3);
          Connector S= Connectors.get(4);

          S.state = ADDER.sum(invert[0]^IA, invert[1]^IB, invert[2]^CI);
          CO.state = ADDER.co(invert[0]^IA, invert[1]^IB, invert[2]^CI);

          WireUpdate(S, S.state);
          WireUpdate(CO, CO.state);
        } else {

          //ZweiTor
          out= Connectors.get(1);
          if (NOT !=null) {
            C = NOT.fun(A^invert[0])^invert[1];
            out.state=C;
            WireUpdate(out, out.state);
          }

          if (!out.type.equals("Output")) {
            println("Pin Missmatch");
          }
        }
      }
    }

    //EinTor
    if (TORCH !=null) {
      TORCH.state=state[0]^invert[0];
    }
  }

  /////////////////////////////////////////////////////////////////////////
  void move() {
    if (selected) {
      pos.set(mouse.copy().sub(globalPanOffset));
    }
  }
}
