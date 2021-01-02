//Kill Based On Attacker and AttackPos
void kill(char team, PVector pos) {
  for (int i=Bauern.size()-1; i >= 0; i--) {
    if (Bauern.get(i).pos.equals(pos)&&Bauern.get(i).team != team) {
      Bauern.remove(i);
    }
  }
  for (int i=Tuerme.size()-1; i >= 0; i--) {
    if (Tuerme.get(i).pos.equals(pos)&&Tuerme.get(i).team != team) {
      Tuerme.remove(i);
    }
  }
  for (int i=Pferde.size()-1; i >= 0; i--) {
    if (Pferde.get(i).pos.equals(pos)&&Pferde.get(i).team != team) {
      Pferde.remove(i);
    }
  }
  for (int i=Damen.size()-1; i >= 0; i--) {
    if (Damen.get(i).pos.equals(pos)&&Damen.get(i).team != team) {
      Damen.remove(i);
    }
  }
  for (int i=Koenige.size()-1; i >= 0; i--) {
    if (Koenige.get(i).pos.equals(pos)&&Koenige.get(i).team != team) {
      Koenige.remove(i);
    }
  }
  for (int i=Laeufer.size()-1; i >= 0; i--) {
    if (Laeufer.get(i).pos.equals(pos)&&Laeufer.get(i).team != team) {
      Laeufer.remove(i);
    }
  }
}

///////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////

//Lerp Piece
boolean animate(boolean animating, PVector pos, PVector target) {
  if (animating) {
    possibleMoves.clear();
    possibleAttacks.clear();
    pos.x=lerp(pos.x, target.x, animationSpeed);
    pos.y=lerp(pos.y, target.y, animationSpeed);
    if (pos.dist(target)<1) {
      allowMove=true;
      return false;
    }
  } 
  return true;
}


///////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////


void BauernUmWandlung(PVector pos, boolean teamN) {
  if (showPopUp) {
    allowMove=false;
    char otherTeam;
    char team;
    int ButtonOff = 5;
    int top = height/3+5;
    int sideL = width/2-100;
    int sideR = width/2+100;
    float off = 50;
    int Button = -1;
    if (teamN == true) {
      otherTeam = 'B';
      team = 'A';
    } else {
      otherTeam ='A';
      team = 'B';
    }
    fill(0);
    rect(width/2, height/2-50, 200, 300);
    for (int i=0; i < 4; i++) {
      if ((mousePos.x > sideL && mousePos.x < sideR) && (mousePos.y> top-15+i*off && mousePos.y < top+15+i*off)) {
        fill(0, 255, 0);
        rect(width/2, i*off+height/3+ButtonOff, 180, 30);
        if (mousePressed) {
          Button = i;
          showPopUp=false;
          allowMove=true;
          kill(otherTeam, pos);
        }
      }
    }
    if (Button ==0) {
      Tuerme.add(new Turm(pos, team));
    }
    if (Button ==1) {
      Laeufer.add(new Laeufer(pos, team));
    }
    if (Button ==2) {
      Pferde.add(new Pferd(pos, team));
    }
    if (Button ==3) {
      Damen.add(new Dame(pos, team));
    }
    textSize(20);
    fill(255);
    text("Tower", width/2, height/3);
    text("Bishop", width/2, height/3+off);
    text("Horse", width/2, height/3+2*off);
    text("Queen", width/2, height/3+3*off);
  }
}


///////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////


void GiveUpButton(boolean team) {
  float posY = -100;
  if (allowMove) {
    if (team ==true) {
      posY=height/3;
    } else {
      posY=2*height/3;
    }
  }
  boolean hover=(mouseX>width-90 && mouseY >posY-20 && mouseY <posY+20);
  fill(0, 200);
  if (hover) {
    fill(50, 200);
  }
  rect(width, posY, 180, 40);
  textSize(20);
  fill(255, 200);
  text("Give Up", width-45, posY);
  if (hover && flankeMaus(mousePressed)) {
    GivenUP = true;
  }
}


///////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////


void updatePossibleMoves(boolean AllowDiagMov, boolean AllowStraightMov, int MovRange, PVector MovingVector, boolean team, boolean moveTwice, boolean attackDiag, int moveCount, PVector PiecePos, boolean rotateMovingVector, boolean activeMove, boolean AddToPath) {
  //Respond to Input Vector and its SubActions
  PVector copyMovingVector=new PVector();
  int teamN = int(team);
  int NotteamN = int(!team);
  PVector pos= changeCordinates(PiecePos);

  //If Input Moving Vector available
  if (MovingVector.x!=0 || MovingVector.y!=0) {
    //Rotate Moves
    for (int r=0; r <= 7*int(rotateMovingVector); r++) {
      //Team B
      if (r==0 && teamN==0) {
        MovingVector.y*=-1;
      }
      PVector CheckMove = new PVector(pos.x+MovingVector.x, pos.y+MovingVector.y, teamN);
      PVector CheckMove2 = new PVector(pos.x+MovingVector.x, pos.y+MovingVector.y, NotteamN);
      copyMovingVector.set(MovingVector);
      //MoveOnce/Twice
      for (int i=0; i <= int(moveTwice); i++) {
        if (!Occupied.contains(CheckMove) && !Occupied.contains(CheckMove2)) {
          if (insideField(CheckMove)) {
            if (activeMove) {
              possibleMoves.add(new PVector(CheckMove.x, CheckMove.y));
            }
            if (!attackDiag) {
              if (!allPossibleAttacks.contains(new PVector(CheckMove.x, CheckMove.y, teamN))) {
                allPossibleAttacks.add(new PVector(CheckMove.x, CheckMove.y, teamN));
              }
            }
          }
        } 
        if (!Occupied.contains(CheckMove) && !Occupied.contains(CheckMove2) && moveTwice && moveCount==0) {
          if (i==0 ) {
            CheckMove.add(new PVector(0, MovingVector.y, 0));
            CheckMove2.add(new PVector(0, MovingVector.y, 0));
          }
        }
      }
      //Diag Attack
      PVector attackDir= new PVector();
      if (attackDiag) {
        attackDir=new PVector(1, 1);
        if (r==0 && teamN==0) {
          attackDir.y*=-1;
        }
      } else {
        attackDir.set(MovingVector);
      }
      PVector CheckAttack = new PVector(pos.x+attackDir.x, pos.y+attackDir.y, NotteamN);
      int c=0;
      //Attack
      if (attackDiag==true) {
        c=1;
      }
      for (int i=0; i <= c; i++) {
        PVector attack = new PVector(pos.x+attackDir.x, pos.y+attackDir.y);
        if (insideField(attack)) {
          if (!allPossibleAttacks.contains(new PVector(attack.x, attack.y, teamN))) {
            allPossibleAttacks.add(new PVector(attack.x, attack.y, teamN));
          }
        }        
        if (Occupied.contains(CheckAttack)) {
          if (insideField(CheckAttack)) {
            if (activeMove) {
              possibleAttacks.add(new PVector(CheckAttack.x, CheckAttack.y));
            }
          }
        }
        attackDir.x*=-1;
        CheckAttack = new PVector(pos.x+attackDir.x, pos.y+attackDir.y, NotteamN);
      }
      //Rotate
      if (r==0) {
        MovingVector.x*=-1;
      }
      if (r==1) {
        MovingVector.y*=-1;
      }
      if (r==2) {
        MovingVector.x*=-1;
      }
      if (r==3) {
        MovingVector.x=MovingVector.y;
        MovingVector.y=copyMovingVector.x;
      }
      if (r==4) {
        MovingVector.y*=-1;
      }
      if (r==5) {
        MovingVector.x*=-1;
      }
      if (r==6) {
        MovingVector.y*=-1;
      }
    }
  }

  //Respond to Input Dir and its Sub Actions´
  if (AllowDiagMov) {
    PVector dir= new PVector(-1, -1);
    for (int i=0; i < 4; i++) {
      if (PiecePos.x>10 && PiecePos.y >10) {
        checkEmpty(PiecePos, dir, team, MovRange, activeMove, AddToPath);
      }
      if (i==0) {
        dir.set(new PVector(1, -1));
      }
      if (i==1) {
        dir.set(new PVector(1, 1));
      }
      if (i==2) {
        dir.set(new PVector(-1, 1));
      }
    }
  }
  if (AllowStraightMov) {
    PVector dir= new PVector(0, -1);
    for (int i=0; i < 4; i++) {
      if (PiecePos.x>10 && PiecePos.y >10) {
        checkEmpty(PiecePos, dir, team, MovRange, activeMove, AddToPath);
      }
      if (i==0) {
        dir.set(new PVector(0, 1));
      }
      if (i==1) {
        dir.set(new PVector(1, 0));
      }
      if (i==2) {
        dir.set(new PVector(-1, 0));
      }
    }
  }
}


///////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////


void checkEmpty(PVector pos, PVector dir, boolean team, int range, boolean activeMove, boolean AddToPath) {
  pos=changeCordinates(pos);
  PVector Add= new PVector(0, 0);
  int count=0;
  int count2=0;

  if (range == 1) {
    if (team == true) {
      kingPosS=new PVector(pos.x, pos.y);
    } else {
      kingPosW=new PVector(pos.x, pos.y);
    }
  }
  PVector Add2=new PVector(0, 0);

  //Disable Piece if moving it would lead to CheckMate
  while (insideField(new PVector(pos.x+Add2.x, pos.y+Add2.y))) {
    PVector CheckMove = new PVector(pos.x+Add2.x, pos.y+Add2.y, int(!team));
    PVector CheckMove2 = new PVector(pos.x+Add2.x, pos.y+Add2.y, int(team));
    if (count2<range) {
      Add2.add(dir);
      count2++;
    } else {
      Add2.mult(10);
    }
    if (!straightTrought.contains(CheckMove) && !Occupied.contains(CheckMove2)) {
      straightTrought.add(CheckMove);
    }
    if (Occupied.contains(new PVector(pos.x+Add2.x, pos.y+Add2.y, int(team))) || new PVector(CheckMove.x, CheckMove.y).equals(kingPosW) || new PVector(CheckMove.x, CheckMove.y).equals(kingPosS)) { 
      Add2.mult(10);
    }
  }
  int countW = -1;
  if (straightTrought.contains(kingPosW)) {
    for (PVector p : straightTrought) {
      if (Occupied.contains(p)) {
        countW++;
      }
    }
    if (countW==1) {
      for (PVector p : straightTrought) {
        if (Occupied.contains(p)) {
          if (!new PVector(p.x, p.y).equals(kingPosW)) {
            PosNotAllowedToMove.add(new PVector(p.x, p.y));
            AttackerS=pos;
          }
        }
      }
    }
  }
  int countS = -1;
  if (straightTrought.contains(new PVector(kingPosS.x, kingPosS.y, 1))) {
    for (PVector p : straightTrought) {
      if (Occupied.contains(new PVector(p.x, p.y, 1))) {
        countS++;
      }
    }
    if (countS==1) {
      for (PVector p : straightTrought) {
        if (Occupied.contains(new PVector(p.x, p.y, 1))) {
          if (!new PVector(p.x, p.y).equals(kingPosS)) {
            PosNotAllowedToMove.add(new PVector(p.x, p.y));
            AttackerW=pos;
          }
        }
      }
    }
  }
  straightTrought.clear();

  //Moves
  while (insideField(new PVector(pos.x+Add.x, pos.y+Add.y))) {
    if (count<range) {
      Add.add(dir);
      count++;
    } else {
      Add.mult(10);
    }
    int teamN = int(team);
    int NotteamN = int(!team);
    PVector CheckMove = new PVector(pos.x+Add.x, pos.y+Add.y, teamN);
    PVector CheckMove2 = new PVector(pos.x+Add.x, pos.y+Add.y, NotteamN);
    if (insideField(CheckMove) ) {
      if (!allPossibleAttacks.contains(new PVector(CheckMove.x, CheckMove.y, teamN))) {
        allPossibleAttacks.add(new PVector(CheckMove.x, CheckMove.y, teamN));
      }
    }
    if (range==1 &&!boolean(teamG)==team) {
      for ( PVector p : allPossibleAttacks) {
        if ((p.x==CheckMove.x && p.y==CheckMove.y) && p.z ==teamN) {
          if (Occupied.contains(new PVector(p.x, p.y, int(!boolean(int(p.z)))))) {
            KingAttacksLeft.add(new PVector(CheckMove.x, CheckMove.y, teamN));
          }
        }
      }
    }
    if (Occupied.contains(CheckMove2) ) {
      PVector nextAttack = new PVector(pos.x+Add.x+dir.x, pos.y+Add.y+dir.y, teamN);
      PVector nextAttack2 = new PVector(pos.x+Add.x+dir.x, pos.y+Add.y+dir.y, NotteamN);
      if (!allPossibleAttacks.contains(new PVector(nextAttack.x, nextAttack.y, teamN))) {
        if (!Occupied.contains(nextAttack)&&!Occupied.contains(nextAttack2)&&insideField(nextAttack)) {
          if (new PVector(CheckMove2.x, CheckMove2.y).equals(kingPosW) || new PVector(CheckMove2.x, CheckMove2.y).equals(kingPosS)) {
            allPossibleAttacks.add(new PVector(nextAttack.x, nextAttack.y, teamN));
            allPossibleMoves.add(new PVector(nextAttack.x, nextAttack.y, teamN));
          }
        }
      }
    }

    //All possible Long Moves
    if (!Occupied.contains(CheckMove) && !Occupied.contains(CheckMove2)) {
      if ( insideField(CheckMove)) {
        if (range !=1) {
          if (team == false) {
            if (check && playerTurn==true) {
              AttackerPos = pos;
            }
            if (kingPosS.y==pos.y) {
              if (CheckMove.y ==pos.y) {
                if (CheckMove.x > pos.x && CheckMove.x<kingPosS.x) {
                  allPossibleMoves.add(new PVector(CheckMove.x, CheckMove.y, teamN));
                  attackedFromLeft=true;
                }
                if (CheckMove.x < pos.x && CheckMove.x>kingPosS.x) {              
                  allPossibleMoves.add(new PVector(CheckMove.x, CheckMove.y, teamN));
                  attackedFromRight=true;
                }
              }
            }
            if (kingPosS.x==pos.x) {
              if (CheckMove.x ==pos.x) {
                attackedFromTop = false;
                attackedFromBottom = false;
                if (CheckMove.y > pos.y && CheckMove.y<kingPosS.y) {
                  allPossibleMoves.add(new PVector(CheckMove.x, CheckMove.y, teamN));
                  attackedFromTop=true;
                }
                if (CheckMove.y < pos.y && CheckMove.y>kingPosS.y) {      
                  allPossibleMoves.add(new PVector(CheckMove.x, CheckMove.y, teamN));
                  attackedFromBottom=true;
                }
              }
            }
            if (attackedFromBottom ) {
              allPossibleMoves.remove(new PVector(kingPosS.x, kingPosS.y-1));
            }
            if (attackedFromTop ) {
              allPossibleMoves.remove(new PVector(kingPosS.x, kingPosS.y+1));
            }
            if (kingPosS.y<pos.y) {
              if (CheckMove.y <pos.y) {
                if (CheckMove.x > pos.x && CheckMove.x<kingPosS.x) {
                  allPossibleMoves.add(new PVector(CheckMove.x, CheckMove.y, teamN));
                }
                if (CheckMove.x < pos.x && CheckMove.x>kingPosS.x) {
                  allPossibleMoves.add(new PVector(CheckMove.x, CheckMove.y, teamN));
                }
              }
            }
            if (kingPosS.y>pos.y) {
              if (CheckMove.y >pos.y) {
                if (CheckMove.x > pos.x && CheckMove.x<kingPosS.x) {
                  allPossibleMoves.add(new PVector(CheckMove.x, CheckMove.y, teamN));
                }
                if (CheckMove.x < pos.x && CheckMove.x>kingPosS.x) {
                  allPossibleMoves.add(new PVector(CheckMove.x, CheckMove.y, teamN));
                }
              }
            }
          } else {
            if (check&& playerTurn==false) {
              AttackerPos = pos;
            }
            if (kingPosW.y==pos.y) {
              if (CheckMove.y ==pos.y) {
                if (CheckMove.x > pos.x && CheckMove.x<kingPosW.x) {
                  allPossibleMoves.add(new PVector(CheckMove.x, CheckMove.y, teamN));
                  attackedFromLeft2=true;
                }
                if (CheckMove.x < pos.x && CheckMove.x>kingPosW.x) {              
                  allPossibleMoves.add(new PVector(CheckMove.x, CheckMove.y, teamN));
                  attackedFromRight2=true;
                }
              }
            }
            if (kingPosW.x==pos.x) {
              if (CheckMove.x ==pos.x) {
                attackedFromTop2 = false;
                attackedFromBottom2 = false;
                if (CheckMove.y > pos.y && CheckMove.y<kingPosW.y) {
                  allPossibleMoves.add(new PVector(CheckMove.x, CheckMove.y, teamN));
                  attackedFromTop2=true;
                }
                if (CheckMove.y < pos.y && CheckMove.y>kingPosW.y) {      
                  allPossibleMoves.add(new PVector(CheckMove.x, CheckMove.y, teamN));
                  attackedFromBottom2=true;
                }
              }
            }
            if (attackedFromTop2) {
              allPossibleMoves.remove(new PVector(kingPosW.x, kingPosW.y+1, 1));
            }
            if (attackedFromBottom2) {
              allPossibleMoves.remove(new PVector(kingPosW.x, kingPosW.y-1, 1));
            }
            if (kingPosW.y<pos.y) {
              if (CheckMove.y <pos.y) {
                if (CheckMove.x > pos.x && CheckMove.x<kingPosW.x) {
                  allPossibleMoves.add(new PVector(CheckMove.x, CheckMove.y, teamN));
                }
                if (CheckMove.x < pos.x && CheckMove.x>kingPosW.x) {
                  allPossibleMoves.add(new PVector(CheckMove.x, CheckMove.y, teamN));
                }
              }
            }
            if (kingPosW.y>pos.y) {
              if (CheckMove.y >pos.y) {
                if (CheckMove.x > pos.x && CheckMove.x<kingPosW.x) {
                  allPossibleMoves.add(new PVector(CheckMove.x, CheckMove.y, teamN));
                }
                if (CheckMove.x < pos.x && CheckMove.x>kingPosW.x) {
                  allPossibleMoves.add(new PVector(CheckMove.x, CheckMove.y, teamN));
                }
              }
            }
          }
        }
        if (attackedFromRight) {
          allPossibleMoves.remove(new PVector(kingPosS.x-1, kingPosS.y));
        }
        if (attackedFromLeft) {
          allPossibleMoves.remove(new PVector(kingPosS.x+1, kingPosS.y));
        }
        if (attackedFromRight2) {
          allPossibleMoves.remove(new PVector(kingPosW.x-1, kingPosW.y, 1));
        }
        if (attackedFromLeft2) {
          allPossibleMoves.remove(new PVector(kingPosW.x+1, kingPosW.y, 1));
        }
        
        if (activeMove) {
          possibleMoves.add(new PVector(CheckMove.x, CheckMove.y));
        } else if (range==1 &&!activeMove && check &&!boolean(teamG)==team) {
          if (!KingMovesLeft.contains(new PVector(CheckMove.x, CheckMove.y))) {
            KingMovesLeft.add(new PVector(CheckMove.x, CheckMove.y));
          }
        }
        if (range==1 &&!activeMove && check ) {
          for ( PVector p : allPossibleAttacks) {
            if ((p.x==CheckMove.x && p.y==CheckMove.y) && p.z !=teamN) {
              KingMovesLeft.remove(new PVector(p.x, p.y));
            }
          }
        }
        if (range==1 && kingSelected) {
          for ( PVector p : allPossibleAttacks) {
            if ((p.x==CheckMove.x && p.y==CheckMove.y) && p.z !=teamN) {
              possibleMoves.remove(new PVector(CheckMove.x, CheckMove.y));
              KingDeniedMoves.add(new PVector(CheckMove.x, CheckMove.y, teamN));
            }
          }
        }
      }
    } else {
      dir.mult(10);
    }
    if (activeMove && !kingSelected) {
      if (Occupied.contains(CheckMove2)) {
        if (insideField(CheckMove2)) {
          possibleAttacks.add(new PVector(CheckMove.x, CheckMove.y));
          Add.mult(10);
        }
      }
    }
    if (range==1&& activeMove) {
      if (!allPossibleAttacks.contains(CheckMove2)) {
        if (Occupied.contains(CheckMove2)) {
          possibleAttacks.add(CheckMove);
          possibleAttacks.add(CheckMove2);
        }
      } else {
        KingDeniedMoves.add(new PVector(CheckMove.x, CheckMove.y, teamN));
      }
    }
    if (range==1&& !activeMove) {
      if (allPossibleAttacks.contains(CheckMove2)) {
        KingDeniedMoves.add(new PVector(CheckMove.x, CheckMove.y, teamN));
      }
    }
  }
}
