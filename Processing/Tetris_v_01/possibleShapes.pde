ArrayList<int[]> shapes = new ArrayList();


void setShapes() {

  int[] shape1 = {
    1, 1, 0, 
    0, 1, 0, 
    0, 1, 0};
  shapes.add(shape1);

  int[] shape2 = {
    0, 1, 1, 
    0, 1, 0, 
    0, 1, 0};
  shapes.add(shape2);

  int[] shape3 = {
    0, 0, 0, 
    0, 1, 1, 
    0, 1, 1};
  shapes.add(shape3);

  int[] shape4 = {
    0, 0, 0, 
    0, 1, 1, 
    1, 1, 0};
  shapes.add(shape4);

  int[] shape5 = {
    0, 0, 0, 
    1, 1, 0, 
    0, 1, 1};
  shapes.add(shape5);

  int[] shape6 = {
    0, 1, 0, 
    1, 1, 1, 
    0, 0, 0};
  shapes.add(shape6);

  int[] shape7 = {
    0, 0, 0, 
    1, 1, 1, 
    0, 0, 0};
  shapes.add(shape7);
}



class part {
  PVector pos;

  part(PVector pos_) {
    pos=pos_;
  }

  void show() {
    rect(pos.x, pos.y, gridLen, gridLen);
  }
}
