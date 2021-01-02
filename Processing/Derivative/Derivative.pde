//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//Insert f(x) below to preset functions(call them by y=f(x,#index)), mouseDrag = pan, mouseWheel = zoom, Click on SpecialPoint to Highlight them//////////////////
//RightClick to Jump, "SPACE" to Reset, Click to manually update the canvas, press NumberKeys to hide derivative//////////////////////////////////////////////////////
//press "ArrowUP","ArrowDown" to increase/decrease Derivatives//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
double rangeX=15;
double rangeY;
double scale=1;
double stepX=0.005;

Vec2 transOffset=new Vec2();
ArrayList<Vec2> fun = new ArrayList();
ArrayList<SpecialPoint> SpecialPoints = new ArrayList();
ArrayList<ArrayList> HigherDerivatives = new ArrayList();
int maxDerivative=0;
int maxSpecialPoints=20;

Vec2 OverlayVal=new Vec2();
boolean showOverlay=false;
StringList OverlayNames=new StringList();

boolean inputSelected, InputIsLive=true;
String input="log(x)*x+sin(x)*1.5";
String inputTemp=input;
int cursorPos=input.length();

color[] colors ={
  #fe0000, 
  #fdfe02, 
  #0bff01, 
  #011efe, 
  #fe00f6, 
  #fe0000, 
  #eb0450, 
  #f547c3, 
  #24f8e5, 
  #f87d25, 
};
void setup() {
  size(800, 800);
  smooth(8);
  rangeY=rangeX*(float)height/width;
  setupParser();
}

void draw() {
  background(51);
  pushMatrix();
  translate(width/2, height/2);
  scale((float)scale);
  //Clear
  SpecialPoints.clear();
  HigherDerivatives.clear();
  OverlayNames.clear();
  fun.clear();
  showOverlay=false;

  //calc
  calcFun();
  calcDer();

  //showAxes
  showAxes();

  //show f(x);
  showFunction_setSpecialPoints(fun, colors[0], 0);

  //show Derivatives
  for (int i =0; i <HigherDerivatives.size(); i++) {
    ArrayList<Vec2> a = HigherDerivatives.get(i);
    showFunction_setSpecialPoints(a, colors[(i+1)%colors.length], i+1);
  }

  //Show SpecialPoints
  for (SpecialPoint p : SpecialPoints) {
    p.show();
  }

  //Overlay
  popMatrix();
  showOverlay();

  noLoop();
}

//###########################################################################//
//###############################FUNCTION####################################//
//###########################################################################//
//acces by typing y=f(x,n)/////////////////////////////////////////////////////
double f(double x, int n) {
  switch(n) {
  case 1:
    return Math.tan(x)/x;
  case  2:
    return 0.4*(-0.2*x*x*x*x   - 0.8*x*x*x + 1.8*x*x + 3*x- 1.5)/(x-0.3);
  case  3:
    return 0.08*(x-1)*(x+2)*(x+1.512)*(x+3.3)*(x-1.3)*(x+3)*(x+0.2);
  case  4:
    return Math.sin(x);
  case  5:
    return 0.8*Math.tan(Math.sin(x));
  case  6:
    return Math.pow(Math.log(x), 2)*x;
  case  7:
    return Math.exp(0.5*x);
  case  8:
    return Math.log(x);
  case  9:
    return 5*Math.cos(x)/x;
  case  10:
    return(gamma(x));
  case  11:
    return Math.exp(1/gamma(x))-x*x;
  case  12:
    return Math.exp(-x*x);
  case  13:
    return 1/x;
  case  14:
    return(fak(x));
  case  15:
    return (x*x*x)/((x-3)*(x+2));
  case 16:
    return x*x*x-1*x*x-x;
  default:
    return x*x;
  }
}
//###########################################################################//
//###########################################################################//
//###########################################################################//
