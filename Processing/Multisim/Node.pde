class Node {
  ArrayList<Connector> Connectors=new ArrayList();
  Complex Voltage;
  int lineNum;

  Node(int lineNum, Connector C) {
    this.lineNum=lineNum;
    Connectors.add(C);
  }
}
