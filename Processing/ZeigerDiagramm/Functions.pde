/////////////////////////////////////////////////////////////////////////////
void trans() {
  translate(width/2, height/2);
  mousePos.set(mouseX-width/2, mouseY-height/2);
  translationVector.mult(0);
  if (mousePressed) {
    if (mouseButton == RIGHT) {
      translationVector.x+=mouseX-pmouseX; 
      translationVector.y+=mouseY-pmouseY;
    }
  }
}

/////////////////////////////////////////////////////////////////////////////
void HUD() {
  textAlign(LEFT);
  fill(255);
  text("+: Add Segment   ", width/2, height-48);
  text("a: Draw Segment  ", width/2, height-35);
  text("d: Delete Segment", width/2, height-22);
  text("r: Reset         ", width/2, height-10);
  text("Move: Click on Head", 50, height-15);
  text("Edit:  Click on Name", 50, height-30);

  textAlign(CENTER);
  if (!ShowEditWindow) {
    //Scale
    text("dx: " + 1/(absScale/100.0), width-170, height-20);
    //dx
    stroke(0, 0, 1);
    strokeWeight(1);
    line(width-220, height-40, width-120, height-40);
    line(width-220, height-35, width-220, height-45);
    line(width-120, height-35, width-120, height-45);
  }
  //AddVectors
  if (ShowAddWindow) {
    AddNewSegment();
  }
  if (ShowEditWindow) {
    EditSegment();
  }
}

/////////////////////////////////////////////////////////////////////////////
void DrawVectors() {
  addVector1.add(translationVector);

  if (DrawEnabled) {
    PVector tempAddpos = mousePos;
    PVector newPos= mousePos;
    fill(Cyian);
    textAlign(CENTER);
    text("Draw Enabled", width/2, 20);
    if (FlankeMaus()&&mouseButton==LEFT) {
      boolean leave=false;
      for (Segment S : Segments) {
        if (!DrawPointSelected) {
          S.botSelected=false;
          if (mousePos.dist(S.absPos)<20) {
            addVector1=S.absPos.copy().add(width/2, height/2);
            DrawPointSelected=true;
            DrawPoint1=S.name;
            leave=true;
            PointIndex=S.hashCode();
          }
          if (mousePos.dist(S.offset)<20) {
            addVector1=S.offset.copy().add(width/2, height/2);
            DrawPointSelected=true;
            DrawPoint1=S.name;
            leave=true;
            PointIndex=S.hashCode();
            S.botSelected=true;
          }
        }
      }
      if (!DrawPointSelected && !leave) {
        addVector1=mousePos.copy().add(width/2, height/2);
        DrawPointSelected=true;
        DrawPoint1="A";
        leave=true;
      }
      if (DrawPointSelected && !leave) {
        boolean added=false;
        for (Segment S : Segments) {
          if (mousePos.dist(S.absPos)<20) {
            addVector2=S.absPos.copy().add(width/2, height/2);
            DrawPoint2=S.name;
            added=true;
          }
          if (mousePos.dist(S.offset)<20) {
            addVector2=S.offset.copy().add(width/2, height/2);
            DrawPoint2=S.name;
            added=true;
          }
        }
        if (!added) {
          addVector2=mousePos.copy().add(width/2, height/2);
          DrawPoint2="B";
          added=true;
        }
        if (added) {
          PVector diff = addVector2.copy().sub(addVector1);
          diff.y*=-1;
          diff.div(absScale);
          Segments.add(new Segment(diff, addVector1.sub(width/2, height/2), DrawPoint1 +"-"+DrawPoint2));
          addVector1.mult(0);
          addVector2.mult(0);
          DrawPointSelected=false;
          DrawEnabled=false;
        }
      }
    }
    if (DrawPointSelected) {
      for (Segment S : Segments) {
        if ( PointIndex==S.hashCode()) {
          if (S.botSelected) {
            addVector1=S.offset.copy().add(width/2, height/2);
          } else {
            addVector1=S.absPos.copy().add(width/2, height/2);
          }
        }
      }
    } 
    for (Segment S : Segments) {
      if (mousePos.dist(S.absPos)<20) {
        newPos=S.absPos.copy();
      }
      if (mousePos.dist(S.offset)<20) {
        newPos=S.offset.copy();
      }
    }

    if (DrawPointSelected) {
      stroke(120, 180, 255);
      line(newPos.x+width/2, newPos.y+height/2, addVector1.x, addVector1.y);
    }

    for (Segment S : Segments) {
      if (mousePos.dist(S.absPos)<20) {
        tempAddpos=S.absPos.copy();
      }
      if (mousePos.dist(S.offset)<20) {
        tempAddpos=S.offset.copy();
      }
    }
    ellipse(tempAddpos.x+width/2, tempAddpos.y+height/2, 8, 8);
  }
}

//FlankeMaus
boolean before;
boolean FlankeMaus() {
  boolean now = before;
  before = mousePressed;
  return (before && !now);
}

///////////////////////////////////////////////////////////////////////////////////////////

void AddNewSegment() {
  stroke(255);
  rect(100, height-150, 200, 300);

  //Buttons
  ////////////////////////////////////////////////////
  stroke(0);
  strokeWeight(2);
  //Button 1
  if (AddNormalForm==true) {
    fill(255, 0, 0);
  } else {
    noFill();
  }
  ellipse(10, height-200, 10, 10);

  //Button 2
  if (AddExpForm==true) {
    fill(255, 0, 0);
  } else {
    noFill();
  }
  ellipse(10, height-140, 10, 10);
  strokeWeight(1);

  //Textfelder
  ////////////////////////////////////////////////////
  //NormalForm
  fill(0, 125, 0, 200);
  //1
  if (SelectedNormalForm1) {
    fill(125, 125, 0, 200);
  }
  rect(60, height-180, 60, 20);
  //2
  fill(0, 125, 0, 200);
  if (SelectedNormalForm2) {
    fill(125, 125, 0, 200);
  }
  rect(140, height-180, 60, 20);

  //ExponentenForm
  fill(0, 125, 0, 200);
  //1
  if (SelectedExpForm1) {
    fill(125, 125, 0, 200);
  }
  rect(60, height-120, 60, 20);
  //2
  fill(0, 125, 0, 200);
  if (SelectedExpForm2) {
    fill(125, 125, 0, 200);
  }
  rect(140, height-120, 60, 20);

  //Buttons
  //Add
  fill(170, 125, 80, 200);
  rect(100, height-70, 180, 30);

  //Name
  fill(0, 125, 125, 200);
  if (selectedName) {
    fill(125, 125, 0, 200);
  }
  rect(100, height-250, 180, 30);

  //Text
  ////////////////////////////////////////////////////
  fill(0);
  textAlign(CENTER, CENTER);
  text(Re, 60, height-180);
  text(Im, 140, height-180);
  text(Mag, 60, height-120);
  text(Phi, 140, height-120);
  text(Name, 100, height-250);
  text("Normal-Form (x+jy)", 100, height-200);
  text("Exp-Form (a<phi) ", 100, height-140);
  text("Add", 100, height-70);
  text("Name", 100, height-280);

  //SelectButtons
  ////////////////////////////////////////////////////
  if (mousePressed) {
    if (mouseX>30 && mouseX<90 && mouseY>height-190 && mouseY<height-170) {
      SelectedNormalForm1=true;
      SelectedNormalForm2=false;
      SelectedExpForm1=false;
      SelectedExpForm2=false;
      selectedName=false;
    }
    if (mouseX>110 && mouseX<170 && mouseY>height-190 && mouseY<height-170) {
      SelectedNormalForm2=true;
      SelectedNormalForm1=false;
      SelectedExpForm1=false;
      SelectedExpForm2=false;
      selectedName=false;
    }
    if (mouseX>30 && mouseX<90 && mouseY>height-130 && mouseY<height-110) {
      SelectedExpForm1=true;
      SelectedExpForm2=false;
      SelectedNormalForm2=false;
      SelectedNormalForm1=false;
      selectedName=false;
    }
    if (mouseX>110 && mouseX<170 && mouseY>height-130 && mouseY<height-110) {
      SelectedExpForm2=true;
      SelectedExpForm1=false;
      SelectedNormalForm2=false;
      SelectedNormalForm1=false;
      selectedName=false;
    }
    if (mouseX>10 && mouseX<190 && mouseY> height-250-15 && mouseY< height-250+15) {
      selectedName=true;
      SelectedExpForm2=false;
      SelectedExpForm1=false;
      SelectedNormalForm2=false;
      SelectedNormalForm1=false;
    }
    if (mouseY<height-300 || mouseX>200) {
      selectedName=false;
      SelectedExpForm2=false;
      SelectedExpForm1=false;
      SelectedNormalForm2=false;
      SelectedNormalForm1=false;
      if (mouseButton == LEFT) {
        ShowAddWindow=false;
      }
    }
    if (dist(mouseX, mouseY, 10, height-200)<10) {
      AddNormalForm=true;
      AddExpForm=false;
    }
    if (dist(mouseX, mouseY, 10, height-140)<10) {
      AddExpForm=true;
      AddNormalForm=false;
    }
  }
  //AddSegment
  ////////////////////////////////////////////////////
  if (FlankeMaus()) {
    if (mouseX>10 && mouseX<190 && mouseY>height-70-15 && mouseY<height-70+15) {
      float x=0;
      float y=0;
      boolean leave=false;
      if (AddNormalForm) {
        try {
          x=Float.valueOf(Re);
          y=Float.valueOf(Im);
        } 
        catch (NumberFormatException nfe) {
          leave=true;
        }
        if (!leave) {
          PVector val = new PVector(x, y, 0);
          Segments.add(new Segment(val, Name));
        }
      }
      if (AddExpForm) {
        try {
          x=Float.valueOf(Mag);
          y=Float.valueOf(Phi);
        }
        catch (NumberFormatException nfe) {
          leave=true;
        }
        if (!leave) {
          PVector val = new PVector(x, y, 1);
          Segments.add(new Segment(val, Name ));
        }
      }
    }
  }
}

/////////////////////////////////////////////////////////
void EditSegment() {
  stroke(255);
  fill(255);
  rect(width-100, height-155, 200, 310);

  for (Segment S : Segments) {
    if (S.edit==true) {
      //Textfelder

      //NormalForm
      fill(0, 125, 0, 200);
      //1
      if (EditNormalForm1) {
        fill(125, 125, 0, 200);
      }
      rect(width-140, height-180, 60, 20);
      //2
      fill(0, 125, 0, 200);
      if (EditNormalForm2) {
        fill(125, 125, 0, 200);
      }
      rect(width-60, height-180, 60, 20);

      //ExponentenForm
      fill(0, 125, 0, 200);
      //1
      if (EditExpForm1) {
        fill(125, 125, 0, 200);
      }
      rect(width-140, height-120, 60, 20);
      //2
      fill(0, 125, 0, 200);
      if (EditExpForm2) {
        fill(125, 125, 0, 200);
      }
      rect(width-60, height-120, 60, 20);

      //Buttons
      //Add
      fill(170, 125, 80, 200);
      rect(width-100, height-55, 180, 30);

      //Name
      fill(0, 125, 125, 200);
      if (EditNameBool) {
        fill(125, 125, 0, 200);
      }
      rect(width-100, height-250, 180, 30);

      //Scale
      fill(0, 125, 0, 200);
      if (EditScaleBool) {
        fill(125, 125, 0, 200);
      }
      rect(width-40, height-20, 50, 25);

      //Buttons
      ////////////////////////////////////////////////////
      stroke(0);
      strokeWeight(2);
      //Button 1
      if (EditNormalForm==true) {
        fill(255, 0, 0);
      } else {
        noFill();
      }
      ellipse(width-190, height-200, 10, 10);

      //Button 2
      if (EditExpForm==true) {
        fill(255, 0, 0);
      } else {
        noFill();
      }
      ellipse(width-190, height-140, 10, 10);
      strokeWeight(1);

      //Text
      ////////////////////////////////////////////////////
      fill(0);
      textAlign(CENTER, CENTER);
      text(EditIm, width-60, height-180);
      text(EditRe, width-140, height-180);
      text(EditPhi, width-60, height-120);
      text(EditMag, width-140, height-120);
      text(EditName, width-100, height-250);
      text(roundToNPlaces(S.StaticVal.x, 3) +" +"+ roundToNPlaces(S.StaticVal.y, 3) +"j\nEdit: '"+S.name +"'", width-100, height-210);
      text(roundToNPlaces(S.StaticVal.mag(), 3)+" <" +roundToNPlaces(degrees(S.StaticVal.heading()), 3) +"°\nEdit: '"+S.name +"'", width-100, height-150);
      text("Scale:\nCurr.: " + roundToNPlaces(S.Scale, 2), width-120, height-20);
      text(EditScale, width-40, height-20);
      text("Save & Exit", width-100, height-55);
      text("New Name for:\n" +"'"+S.name +"'", width-100, height-285);
      //Colors
      ////////////////////////////////////////////////////
      // rect(width-40, height-20, 50, 25);
      fill(White);
      ellipse(width-180, height-85, 15, 15);
      fill(Violett);
      ellipse(width-140, height-85, 15, 15);
      fill(Red);
      ellipse(width-100, height-85, 15, 15);
      fill(Green);
      ellipse(width-60, height-85, 15, 15);
      fill(Cyian);
      ellipse(width-20, height-85, 15, 15);

      stroke(0);
      //Color
      fill(EditColor);
      rect(width-180, height-20, 20, 20);

      //SelectButtons
      ////////////////////////////////////////////////////
      if (FlankeMaus()) {
        if (mouseX<width-30 && mouseX>width-90 && mouseY>height-190 && mouseY<height-170) {
          EditNormalForm1=false;
          EditNormalForm2=true;
          EditExpForm1=false;
          EditExpForm2=false;
          EditNameBool=false;
          EditScaleBool=false;
        }
        if (mouseX<width-110 && mouseX>width-170 && mouseY>height-190 && mouseY<height-170) {
          EditNormalForm1=true;
          EditNormalForm2=false;
          EditExpForm1=false;
          EditExpForm2=false;
          EditNameBool=false;
          EditScaleBool=false;
        }
        if (mouseX<width-110 && mouseX>width-170 &&mouseY>height-130 && mouseY<height-110) {
          EditNormalForm1=false;
          EditNormalForm2=false;
          EditExpForm1=true;
          EditExpForm2=false;
          EditNameBool=false;
          EditScaleBool=false;
        }
        if (mouseX<width-30 && mouseX>width-90  && mouseY>height-130 && mouseY<height-110) {
          EditNormalForm1=false;
          EditNormalForm2=false;
          EditExpForm1=false;
          EditExpForm2=true;
          EditNameBool=false;
          EditScaleBool=false;
        }
        if (mouseX<width-10 && mouseX>width-190 && mouseY>height-250-15 && mouseY<height-250+15) {
          EditNormalForm1=false;
          EditNormalForm2=false;
          EditExpForm1=false;
          EditExpForm2=false;
          EditNameBool=true;
          EditScaleBool=false;
        }
        if (mouseX<width-40+25 && mouseX>width-40-25 && mouseY>height-20-12.5 && mouseY<height-20+12.5) {
          EditNormalForm1=false;
          EditNormalForm2=false;
          EditExpForm1=false;
          EditExpForm2=false;
          EditNameBool=false;
          EditScaleBool=true;
        }
        if (mouseX<width-200 || mouseY<height-300) {
          EditNormalForm1=false;
          EditNormalForm2=false;
          EditExpForm1=false;
          EditExpForm2=false;
          EditNameBool=false;
          EditScaleBool=false;
          if (mouseButton == LEFT) {
            ShowEditWindow=false;
            GlobalSegmentEdit=false;
            S.edit=false;
          }
        }      

        if (abs(mouseY-(height-85))<30) {
          if (abs(mouseX-(width-180))<8) {
            EditColor=White;
          }
          if (abs(mouseX-(width-140))<8) {
            EditColor=Violett;
          }
          if (abs(mouseX-(width-100))<8) {
            EditColor=Red;
          }
          if (abs(mouseX-(width-60))<8) {
            EditColor=Green;
          }
          if (abs(mouseX-(width-20))<8) {
            EditColor=Cyian;
          }
        }
        ///////////////////////////////////////////////////
        //Add
        if (dist(mouseX, mouseY, width-200+10, height-200)<10) {
          EditNormalForm=!EditNormalForm;
          EditExpForm=false;
        }
        if (dist(mouseX, mouseY, width-200+10, height-140)<10) {
          EditExpForm=!EditExpForm;
          EditNormalForm=false;
        }
        if (mouseX<width-10 && mouseX>width-190 && mouseY>height-55-15 && mouseY<height-55+15) {
          float x=0;
          float y=0;
          boolean leave=false;

          if (EditName != "") {
            S.name=EditName;
          }
          if (EditScale != str(S.Scale)) {
            float scal=1.00;
            try {
              scal=Float.valueOf(EditScale);
            } 
            catch (NumberFormatException nfe) {
              leave=true;
            }
            S.Scale*=scal;
            S.val.mult(scal);
            S.StaticVal.mult(scal);
          }

          if (EditNormalForm) {
            try {
              x=Float.valueOf(EditRe);
            } 
            catch (NumberFormatException nfe) {
              x=S.StaticVal.x;
            }
            try {
              y=Float.valueOf(EditIm);
            } 
            catch (NumberFormatException nfe) {
              y=S.StaticVal.y;
            }
            if (!leave) {
              PVector val = new PVector(x, -y, 0);
              S.StaticVal=val.copy();
              S.StaticVal.y*=-1;
              val.mult(absScale);
              S.val=val;
            }
          }
          if (EditExpForm) {
            try {
              x=Float.valueOf(EditMag);
            }
            catch (NumberFormatException nfe) {
              x=S.StaticVal.mag();
            }
            try {
              y=Float.valueOf(EditPhi);
            }
            catch (NumberFormatException nfe) {
              y=-degrees(S.StaticVal.heading());
            }
            if (!leave) {
              PVector val = new PVector(x, -y, 1);
              val=changeCordinates(val);
              S.StaticVal=val.copy();
              S.StaticVal.y*=-1;
              val.mult(absScale);
              S.val=val;
            }
          }
          ShowEditWindow=false;
          GlobalSegmentEdit=false;
          S.edit=false;
          S.col=EditColor;
        }
      }
    }
  }
}


float roundToNPlaces(float val, int n) {
  val*=pow(10, n);
  val=round(val);
  val/=pow(10, n);
  return val;
}
