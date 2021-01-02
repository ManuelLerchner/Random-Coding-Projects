class SpecialPoint {
  Vec2 pos=new Vec2();
  Vec2 koordPos;
  int orderDerivative;
  String Name="";

  SpecialPoint(Vec2 koordPos, int der) {
    this.koordPos=koordPos;
    this.orderDerivative=der;
    if (der==0) {
      koordPos.y=0;
    }
  }
  SpecialPoint(Vec2 koordPos, String Name) {
    this.koordPos=koordPos;
    this.Name=Name;
    orderDerivative=colors.length-1;
  }

  void show() {
    pos=mapPointToPixel(koordPos.x, koordPos.y, true);
    fill(colors[orderDerivative%colors.length]);
    stroke(255);
    ellipse((float)pos.x, (float)pos.y, (float)(Math.min(10, 10/scale)), (float)(Math.min(10, 10/scale)));

    if (distV(mousePos, koordPos)<0.2) {
      showOverlay=true;
      OverlayVal=koordPos;

      if (Name=="") {
        switch(orderDerivative) {
        case 0:
          OverlayNames.append("Nullpunkt");
          break;
        case 1:
          OverlayNames.append("ExtremPunkt");
          break;
        case 2:
          OverlayNames.append("WendePunkt");
          break;
        default:
          OverlayNames.append("Order: "+orderDerivative);
        }
      } else {
        OverlayNames.append(Name);
        stroke(255);
        line((float)pos.x, (float)(-height/2/scale), (float)pos.x, (float)(height/2/scale));
      }
    }
  }
}
