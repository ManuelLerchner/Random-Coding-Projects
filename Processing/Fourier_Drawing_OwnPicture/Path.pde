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
