float zoomFactor=1;
PVector globalPanOffset=new PVector();
ArrayList<Arrow> Arrows = new ArrayList();
boolean N_LeiterVorhanden=true;
boolean Wobbeln=false;
ChildApplet child;


Complex U_l1, U_l2, U_l3, Z1, Z2, Z3;


////Um N-Leiter ein/auszuschalten beliebige Taste außer 'w' drücken
////Um Bauteile zu Wobbeln 'w' drücken
////Die berechneten Werte werden auch über die Konsole asugegeben
////Mouse: Pan, Zoom

void settings() {
  size(500, 500);
}

void setup() {
  child=new ChildApplet();
  textAlign(RIGHT, CENTER);

  ///////////////////////////////////
  //Spannungen
  U_l1=new Complex("polar", 230, 120);  //230<120°
  U_l2=new Complex("polar", 230, 0);    //230<0°
  U_l3=new Complex("polar", 230, -120); //230<-120°
  ///////////////////////////////////


  //1)
  ///////////////////////////////////
  //unsymetrische Belastung
  Z1=new Complex("polar", 10.5, 45);  
  Z2=new Complex("polar", 45.2, -15); 
  Z3=new Complex("polar", 23.88, 0);   
  ///////////////////////////////////


  //2)
  ///////////////////////////////////
  //symetrische beleastung
  Z1=new Complex("polar", 10, 10);    
  Z2=new Complex("polar", 10, 10); 
  Z3=new Complex("polar", 10, 10);   
  ///////////////////////////////////


  //3)
  ///////////////////////////////////
  //Sternpunktspannung Betrag |230| V
  Z1=new Complex("polar", 10, 0);   
  Z2=new Complex("polar", 10, -50); 
  Z3=new Complex("polar", 46.402, 88.909);  
  ///////////////////////////////////
  //siehe: https://www.wolframalpha.com/input/?i=%281%2FR_1+%2B1%2FR_2%2B1%2FR_3%29%5E-1+*%28%28U*cis%28120%C2%B0%29%2FR_1%2BU*cis%280%29%2FR_2%2BU*cis%28-120%C2%B0%29%2FR_3%29%29%3DU*cis%2873%C2%B0%29


  //4)
  ///////////////////////////////////
  //Sternpunktspannung sehr groß
  Z1=new Complex("polar", 100, 0);   
  Z2=new Complex("polar", 100, -90); 
  Z3=new Complex("polar", 100, 90);  
  //////////////////////////////////


  calculate();
}

void draw() {
  background(51);
  translate(width/2.0, height/2.0);
  scale(zoomFactor);

  BauteileWobbeln();

  for (Arrow A : Arrows) {
    A.show();
  }
}
