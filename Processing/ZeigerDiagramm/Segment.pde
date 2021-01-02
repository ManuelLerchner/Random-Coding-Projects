class Segment {
  PVector val = new PVector();
  PVector StaticVal = new PVector();
  PVector offset=new PVector();
  PVector absPos = new PVector();
  boolean selected;
  boolean edit;
  boolean botSelected;
  String name;
  color col = White;
  float Scale = 1.00;
  float scaleConstant;

  Segment(PVector val_, String name_) {
    //GetCoordinates
    if (val_.z==1) {
      val=changeCordinates(val_);
    } else {
      val=val_;
    }
    StaticVal=val.copy();
    val.mult(absScale);
    name=name_;
    val.y*=-1;
  }

  Segment(PVector val_, PVector offset_, String name_) {
    //GetCoordinates
    if (val_.z==1) {
      val=changeCordinates(val_);
    } else {
      val=val_;
    }
    StaticVal=val.copy();
    offset=offset_.copy();
    val.mult(absScale);
    name=name_;
    val.y*=-1;
  }

  void show() {
    strokeWeight(2);
    pushMatrix();
    translate(offset.x, offset.y);
    //Line
    stroke(col);
    if (mousePos.dist(absPos)<20&& !GlobalSegmentSelected&&!DrawEnabled) {
      stroke(255, 255, 0);
    }
    if (selected) {
      stroke(120, 180, 255);
    }
    line(0, 0, val.x, val.y);
    //Text
    textAlign(CENTER, CENTER);
    fill(250, 250, 0);
    textSize(constrain(val.mag()*sqrt(absScale), 0.001, 14));
    text(name, val.x/2+7*scaleConstant, val.y/2+7*scaleConstant);
    textSize(12);
    //EndPoints
    fill(col);
    pushMatrix();
    translate(val.x, val.y);
    rotate(val.heading()-PI/2);
    float hLen=0.3*absScale*sqrt(val.mag());
    hLen=constrain(hLen, 0, val.mag()*0.1);
    triangle(-hLen, -hLen, hLen, -hLen, 0, hLen);  
    popMatrix();
    popMatrix();
    strokeWeight(1);
  }

  void move() {
    scaleConstant=constrain(absScale, 0, 1);
    offset=offset.copy().add(translationVector);
    absPos = val.copy().add(offset);
    if (Flanke()&&!DrawEnabled && mouseButton==LEFT ) {
      if (!selected) {
        if (mousePos.dist(absPos)<20 && !GlobalSegmentSelected) {
          selected = true;
          GlobalSegmentSelected=true;
        }
      } else {
        GlobalSegmentSelected=false;
        selected=false;
      }
    }
    if (selected) {
      offset.x=mousePos.x-val.x;
      offset.y=mousePos.y-val.y;
      for (Segment S : Segments) {
        if (S.StaticVal!=StaticVal) {
          if (offset.dist(S.absPos)<20) {
            offset=S.absPos.copy();
          }
          if (offset.dist(S.offset)<20) {
            offset=S.offset;
          }
          if ((offset.copy().add(val)).dist(S.offset)<20) {
            offset=S.offset.copy().sub(val);
          }
          if ((offset.copy().add(val)).dist(S.absPos)<20) {
            offset=S.absPos.copy().sub(val);
          }
        }
      }
    }
  }

  void edit() {
    if (Flanke2() && !ShowAddWindow) {
      if (mousePos.x>(val.x/2+offset.x)+7*scaleConstant-(7+constrain(val.mag()*sqrt(absScale), 0.001, 14)+Name.length()*10)/2 && mousePos.x<(val.x/2+offset.x)+7*scaleConstant+(7+constrain(val.mag()*sqrt(absScale), 0.001, 14)+Name.length()*10)/2) {
        if (abs(mousePos.y-(val.y/2+offset.y)-7*scaleConstant)<(7+constrain(val.mag()*sqrt(absScale), 0.001, 14))/2) {
          if (!GlobalSegmentEdit) {
            EditNormalForm=false;
            EditExpForm=false;
            EditScaleBool=false;
            ShowEditWindow=true;
            edit=true;
            GlobalSegmentEdit=true;
            EditColor=col;
            EditIm = "";
            EditRe = "";
            EditMag = "";
            EditPhi = "";
            EditName = "";
            EditScale= "1";
          } else {
            if (edit) {
              ShowEditWindow=false;
              GlobalSegmentEdit=false;
              edit=false;
            }
          }
        }
      }
    }
  }

  boolean before;
  boolean Flanke() {
    boolean now = before;
    before = mousePressed;
    return (before && !now);
  }
  boolean before2;
  boolean Flanke2() {
    boolean now2 = before2;
    before2 = mousePressed;
    return (before2 && !now2);
  }
}

/////////////////////////////////////////////////////////////////
PVector changeCordinates(PVector in) {
  PVector out = new PVector();
  out.x= cos(radians(in.y))*in.x;
  out.y= sin(radians(in.y))*in.x;
  return(out);
}


void mouseWheel(MouseEvent event) {
  float e = event.getCount();
  for (Segment S : Segments) {
    S.val.mult(1-e/10.0);
    S.offset.mult(1-e/10.0);
  }
  absScale*=1-e/10.0;
}

void keyPressed() {
  if (key=='+' && !ShowEditWindow) {
    ShowAddWindow=!ShowAddWindow;
    Name="New";
    Im = "";
    Re = "";
    Mag = "";
    Phi = "";
    AddNormalForm=false;
    AddExpForm=false;
  }
  if (key=='r' || key=='R') {
    Segments.clear();
    absScale=1;
  }
  if (key=='d' || key=='D') {
    for (int i=Segments.size()-1; i >=0; i--) {
      Segment S = Segments.get(i);
      if (S.selected) {
        if (S.edit) {
          ShowEditWindow=false;
          GlobalSegmentEdit=false;
        }
        Segments.remove(i);
        GlobalSegmentSelected=false;
      }
    }
  }
  if ((key=='a'||key=='A') && !ShowAddWindow && !ShowEditWindow ) {
    DrawEnabled=!DrawEnabled;
    addVector1.mult(0);
    addVector2.mult(0);
    DrawPointSelected=false;
    PointIndex=-1;
  }

  if (keyCode==9) {
    if (SelectedExpForm1) {
      SelectedExpForm1=false;
      SelectedExpForm2=true;
    }
    if (SelectedNormalForm2) {
      SelectedNormalForm2=false;
      SelectedExpForm1=true;
    }
    if (SelectedNormalForm1) {
      SelectedNormalForm1=false;
      SelectedNormalForm2=true;
    }
    if (selectedName) {
      selectedName=false;
      SelectedNormalForm1=true;
    }
    if (EditExpForm1) {
      EditExpForm1=false;
      EditExpForm2=true;
    }
    if (EditNormalForm2) {
      EditNormalForm2=false;
      EditExpForm1=true;
    }
    if (EditNormalForm1) {
      EditNormalForm1=false;
      EditNormalForm2=true;
    }
    if (EditNameBool) {
      EditNameBool=false;
      EditNormalForm1=true;
    }
  }

  if (keyCode!=16) {
    if (SelectedNormalForm1) {
      AddNormalForm=true;
      AddExpForm=false;
      if (keyCode!=8) {    
        Re=Re+key;
      } else {
        if (Re.length()>0) {
          Re=Re.substring(0, Re.length()-1);
        }
      }
    }
    if (EditNormalForm1) {
      EditNormalForm=true;
      EditExpForm=false;
      if (keyCode!=8) {    
        EditRe=EditRe+key;
      } else {
        if (EditRe.length()>0) {
          EditRe=EditRe.substring(0, EditRe.length()-1);
        }
      }
    }
    if (SelectedNormalForm2) {
      AddNormalForm=true;
      AddExpForm=false;
      if (keyCode!=8) {    
        Im=Im+key;
      } else {
        if (Im.length()>0) {
          Im=Im.substring(0, Im.length()-1);
        }
      }
    }
    if (EditNormalForm2) {
      EditNormalForm=true;
      EditExpForm=false;
      if (keyCode!=8) {    
        EditIm=EditIm+key;
      } else {
        if (EditRe.length()>0) {
          EditIm=EditIm.substring(0, EditIm.length()-1);
        }
      }
    }
    if (SelectedExpForm1) {
      AddNormalForm=false;
      AddExpForm=true;
      if (keyCode!=8) {    
        Mag=Mag+key;
      } else {
        if (Mag.length()>0) {
          Mag=Mag.substring(0, Mag.length()-1);
        }
      }
    }
    if (EditExpForm1) {
      EditNormalForm=false;
      EditExpForm=true;
      if (keyCode!=8) {    
        EditMag=EditMag+key;
      } else {
        if (EditMag.length()>0) {
          EditMag=EditMag.substring(0, EditMag.length()-1);
        }
      }
    }
    if (SelectedExpForm2) {
      AddNormalForm=false;
      AddExpForm=true;
      if (keyCode!=8) {    
        Phi=Phi+key;
      } else {
        if (Phi.length()>0) {
          Phi=Phi.substring(0, Phi.length()-1);
        }
      }
    }
    if (EditExpForm2) {
      EditNormalForm=false;
      EditExpForm=true;
      if (keyCode!=8) {    
        EditPhi=EditPhi+key;
      } else {
        if (EditPhi.length()>0) {
          EditPhi=EditPhi.substring(0, EditPhi.length()-1);
        }
      }
    }
    if (selectedName) {
      if (keyCode!=8) {    
        Name=Name+key;
      } else {
        if (Name.length()>0) {
          Name=Name.substring(0, Name.length()-1);
        }
      }
    }
    if (EditNameBool) {
      if (keyCode!=8) {    
        EditName=EditName+key;
      } else {
        if (EditName.length()>0) {
          EditName=EditName.substring(0, EditName.length()-1);
        }
      }
    }
    if (EditScaleBool) {
      if (keyCode!=8) {    
        EditScale=EditScale+key;
      } else {
        if (EditScale.length()>0) {
          EditScale=EditScale.substring(0, EditScale.length()-1);
        }
      }
    }
  }
}
