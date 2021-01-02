/*
JSON contains:
 {
 "drawing":[
 {
 "x":-75.23920093800275,
 "y":-9.276916512631997
 },
 {
 "x":-73.99534065831229,
 "y":-9.582732689485699
 },
 {
 "x":-72.74106439694725,
 "y":-9.89162195029445
 },
 {
 "x":-71.4876893765498,
 "y":-10.200732827734575
 },
 ...
 */

void loadJson() {
  JSONArray train = loadJSONObject("train.json").getJSONArray("drawing");
  N=train.size()/(skipPathPoints+1);
  pathData = new double[2][train.size()/(skipPathPoints+1)];

  for (int i = 0; i < train.size()/(skipPathPoints+1); i+= 1) {
    pathData[0][i] = train.getJSONObject(i*(skipPathPoints+1)).getDouble("x");
    pathData[1][i] = train.getJSONObject(i*(skipPathPoints+1)).getDouble("y");
  }
}


void Sort(Complex[] List) {
  int n = List.length;
  for (int i = 0; i < n-1; i++) {
    int mindex = i;
    for (int j = i+1; j < n; j++) {
      if (List[j].mag > List[mindex].mag)
        mindex = j;
    }
    swap(List, mindex,i);
  }
}

void swap(Complex[] List, int i, int j) {
  Complex temp = List[i];
  List[i] = List[j];
  List[j] = temp;
}
