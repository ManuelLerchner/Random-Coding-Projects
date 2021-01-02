
String[] input ={"1", "2", "2", "3","3","3","4","4","4"};
String beginsWith="1234";
StringList permutations=new StringList();
void setup() {
  size(100, 100);
  generate(input.length, input);

  int count=0;
  for (String S : permutations) {
    boolean valid=true;
    for (int i=0; i < beginsWith.length(); i++) {
      if (!(S.charAt(i)==beginsWith.charAt(i))) {
        valid=false;
        break;
      }
    }
    if (valid) {
      count++;
    }
  }
  
  println(permutations.size()+" distinct permutations, "+count+" of them begin with "+ beginsWith);
  println("time: "+millis()/1000.0+"s");
  exit();
}


void generate(int k, String[]A ) {
  if (k == 1) {
    String text="";
    for (String S : A) {
      text+=S;
    }
    if (!permutations.hasValue(text)) {
      permutations.append(text);
    }
  } else {
    generate(k - 1, A);
    for (int i   = 0; i < k-1; i += 1) {
      if ((k&1)==0) {
        swap(A, i, k-1);
      } else {
        swap(A, 0, k-1);
      }
      generate(k - 1, A);
    }
  }
}

void swap(String[] A, int i, int k) {
  String First=A[i];
  A[i]=A[k];
  A[k]=First;
}
