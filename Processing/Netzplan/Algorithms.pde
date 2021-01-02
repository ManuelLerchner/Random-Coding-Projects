
ArrayList<Node> BreadthFirstSearch(Node start) {
  ArrayList<Node> queue=new ArrayList();
  ArrayList<Node> out=new ArrayList();

  start.discovered=true;
  queue.add(start);
  out.add(start);

  while (queue.size()>0) {
    Node v=queue.get(0);
    queue.remove(0);

    for (Node w : v.outputs) {
      if (!w.discovered) {
        w.discovered=true;
        queue.add(w);
        out.add(w);
      }
    }
  }

  for (Node N : out) {
    N.discovered=false;
  }

  return out;
}
