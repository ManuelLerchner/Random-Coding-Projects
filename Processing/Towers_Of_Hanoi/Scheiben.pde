class Scheibe {

  int i;
  boolean lerp;
  int lerpState;
  PVector pos;
  float len;
  PVector posBevore=new PVector();  
  PVector lerpPos=new PVector();
  int Pillar;



  Scheibe(int i_, int Pillar_) {   
    i=i_;
    Pillar=Pillar_;
    len=map(i, 0, n, 80, 20);
    pos = new PVector(width/4*Pillar_, 500-hei/2-hei*i);
  }


  void show() {
    colorMode(HSB, n, 1, 1);
    fill(i, 1, 1);
    if (chosen==i) {
      pos = (new PVector(mouseX, mouseY));
    }
    rect(pos.x-len, pos.y-hei/2, pos.x+len, pos.y+hei/2);
    fill(0, 0, 0);
    textSize(15);
    text(n-i, pos.x, pos.y);
  }


  void setPillar() {
    if (!(chosen==i)) {
      if (Pillar==1) {
        P1.append(i);
      }
      if (Pillar==2) {
        P2.append(i);
      }
      if (Pillar==3) {
        P3.append(i);
      }
    }
  }


  void chosePieceToMoveManually() {
    if (FlankeMaus()) {
      if (mouseX+len > pos.x && mouseX-len<pos.x) {
        if (mouseY+hei/2 > pos.y && mouseY-hei/2<pos.y) {
          boolean valid = true;
          if (Pillar==1 && 500-(P1.size()-1)*hei<mouseY) {
            valid =false;
          }
          if (Pillar==2 && 500-(P2.size()-1)*hei<mouseY) {
            valid =false;
          }
          if (Pillar==3 && 500-(P3.size()-1)*hei<mouseY) {
            valid =false;
          }
          if (valid) {
            chosen=i;
            posBevore=pos;
          }
        }
      }
    }


    if (NegFlankeMaus()) {
      if (chosen ==i) {
        int newPillar = int(map(mouseX, 0, width, 1, 4));
        int occupied=-1;
        boolean valid = true;

        if (newPillar ==1) {
          occupied=P1.size();
        }
        if (newPillar ==2) {
          occupied=P2.size();
        }
        if (newPillar ==3) {
          occupied=P3.size();
        }

        if (P1.size()==0) {
          P1.append(-1);
        }
        if (P2.size()==0) {
          P2.append(-1);
        }
        if (P3.size()==0) {
          P3.append(-1);
        }


        if (newPillar==1 && P1.max()>i) {
          valid =false;
        }
        if (newPillar==2 && P2.max()>i) {
          valid =false;
        }
        if (newPillar==3 && P3.max()>i) {
          valid =false;
        }

        if (valid) {
          pos=new PVector(width/4*newPillar, 500-hei/2-hei*occupied);
          if (Pillar!=newPillar) {
            count++;
            moveCount++;
          }
          chosen=-1;
        } else {
          pos=posBevore;
        }
        Pillar = newPillar;
      }
    }
  }



  void moveAutomatic(int PieceIndex) {
    if (FlankeMaus()||next) {

      if (n-i==PieceIndex) {
        for (int k=1; k < 6; k++) {

          int  newPillar=Pillar+k;
          newPillar=newPillar%4;        
          if (newPillar==0) {
            newPillar=1;
          }


          int occupied=-1;
          if (newPillar ==1) {
            occupied=P1.size();
          }
          if (newPillar ==2) {
            occupied=P2.size();
          }
          if (newPillar ==3) {
            occupied=P3.size();
          } 

          boolean valid = true;
          if (P1.size()==0) {
            P1.append(-1);
          }
          if (P2.size()==0) {
            P2.append(-1);
          }
          if (P3.size()==0) {
            P3.append(-1);
          }

          if (newPillar==1 && P1.max()>i) {
            valid =false;
          }
          if (newPillar==2 && P2.max()>i) {
            valid =false;
          }
          if (newPillar==3 && P3.max()>i) {
            valid =false;
          }

          P1.removeValue(-1);
          P2.removeValue(-1);
          P3.removeValue(-1);

        

          if (valid) {    
            next=false;
            lerpPos=new PVector(width/4*newPillar, 500-hei/2-hei*(occupied));
            lerp=true;
            lerpState=0;
            Pillar=newPillar;
            moveCount++;
            count++;
            break;
          }
        }
      }
    }
  }

  void lerpTo() {
    if (lerp) {
      if (lerpState==0) {      
        pos.y=lerp(pos.y, 350-n*hei-20, speed);      
        if (pos.dist(new PVector(pos.x, 350-n*hei-20))<10) {
          lerpState=1;
        }
      } 
      if (lerpState==1) {
        pos.x=lerp(pos.x, lerpPos.x, speed);   
        if (pos.dist(new PVector(lerpPos.x, 350-n*hei-20))<10) {
          lerpState=2;
          pos.x=lerpPos.x;
        }
      }
      if (lerpState==2) {  
        pos.y=lerp(pos.y, lerpPos.y, speed);      
        if (pos.dist(lerpPos)<5) {
          lerp=false;
          next=true;
          pos.x=lerpPos.x;
          pos.y=lerpPos.y;
        }
      }
    }
  }


  boolean jetzt;
  boolean FlankeMaus() {
    boolean vorher = jetzt;
    jetzt =mousePressed;
    return(!vorher && jetzt);
  }

  boolean jetzt1;
  boolean NegFlankeMaus() {
    boolean vorher = jetzt1;
    jetzt1 =mousePressed;
    return(vorher && !jetzt1);
  }
}






class Flanke {
  boolean jetzt; 
  boolean FP(boolean val) {
    boolean vorher = jetzt;
    jetzt=val;
    return(!vorher && jetzt);
  }
}
