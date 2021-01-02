class Word {
  String word;
  PVector pos = new PVector();
  float speed;
  boolean remove=false;
  boolean WordSelected = false;


  Word() {
    int index = floor(random(Dictionary.size()));
    word = Dictionary.get(index);
    pos.set(width+5, random(20, height-20));
    speed=random(0.8, 1.4);
    wordCount++;
    
  }


  void move() {
    pos.x-=speed;
    if (pos.x<0) {
      remove = true;
      Health--;
    }
  }

  void show() {
    fill(255);
    text(word, pos.x, pos.y);
  }

  void key(int KeyCode) {
    for (int i=0; i < word.length(); i++) {
      if (word.charAt(0)== KeyCode) {
        word = word.substring(1);
        CharRemoved=true;
        WordSelected=true;
        AnythingSel=true;

       

        if (word.length()==0) {
          Points++;
          selected=-1;
          remove = true;
        }
      }
    }
  }
}



void keyPressed() {
  AnythingSel =false;
  CharRemoved=false;
  for (int i =Words.size()-1; i>=0; i--) {
    if (Words.get(i).WordSelected==true) {
      AnythingSel=true;
    }
  }


  for (int i =0; i<Words.size(); i++) {
    if (!AnythingSel && !lost) {
      Words.get(i).key(key);
    }
    if (Words.get(i).WordSelected==true && !lost) {
      Words.get(i).key(key);
    }
  }

  if (lost) {
    if (Points>HighScore) {
      HighScore=Points;
    }
    if (key == 'r') {
      lost = false;
      Health = 3;
      Points =0;
      Words.clear();
    }
  }
}
