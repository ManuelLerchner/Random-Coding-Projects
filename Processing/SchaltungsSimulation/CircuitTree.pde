class CircuitTree {
  ArrayList<String> Tree = new ArrayList();

  void addInformation(String Name, int HeaderIndex, int ConnectedNode) {
    String InfoString = Name+":"+str(HeaderIndex)+"_"+str(ConnectedNode);
    Tree.add(InfoString);

    for (Node N : Nodes) {
      if (N.index==ConnectedNode) {
        N.Connected.add(Name);
      }
    }
  }
}
