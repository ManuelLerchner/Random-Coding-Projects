
//Visualize
void visualizeGraphics() {

  //Visualize Düsen
  for (Duese D : Duesen) {
    D.show();
    D.produceWaterFountain();
  }

  //Visualize Water
  for (int i=0; i<Water.size(); i++) {
    WaterParticle W = Water.get(i);

    //delete Partikles 
    if (W.pos.y>height-100) {
      Water.remove(i);
      continue;
    }

    W.update();
    W.show();
  }

  //Visualize Pool
  showWaterPool();
}


//linear interpolation between colors
color interpolateColors(color A, color B, float t) {
  float r=red(B)*t+red(A)*(1-t);
  float g=green(B)*t+green(A)*(1-t);
  float b=blue(B)*t+blue(A)*(1-t);

  return color(round(r), round(g), round(b));
}


// used to create colors in cols[] array
color hsvToRgb(float hue, float saturation, float value) {
  hue%=360;
  int hi = (int)(hue / 60.0);
  float f = hue /60.0 - hi;
  float p = value * (1 - saturation);
  float q = value * (1 - f * saturation);
  float t = value * (1 - (1 - f) * saturation);

  f*=255;
  p*=255;
  q*=255;
  t*=255;
  value*=255;

  switch (hi) {
  case 0: 
    return color(value, t, p);
  case 1: 
    return color(q, value, p);
  case 2: 
    return color(p, value, t);
  case 3: 
    return color(p, q, value);
  case 4: 
    return color(t, p, value);
  case 5: 
    return color(value, p, q);
  case 6: 
    return color(value, t, p);
  default: 
    return color(0);
  }
}

//Water Pool
void showWaterPool() {
  fill(100, 100, 150, 150);
  noStroke();
  rect(width/2, height-50, width, 100);
}


//Handle Time
void RTC() {
  if (day()!=DATE && DATE!=0) {
    //Neuer Tag um Mitternacht
    AnlageBisMorgenAus=false;
  }
}


//Check Water Level
void WaterLevel() {

  boolean waterLevelAboveMinimum=true; // Input from Sensor  1^= Enough Water

  if (!waterLevelAboveMinimum) {
    String msg="Wasserstand zu niedrig, Anlage wird ausgeschaltet";
    Log(new Error("WARNING", msg));
    resetAnlage();
  }
}

//Check Temperature
void Temperatur() {

  float currTemp=10; // Input from Sensor

  if (currTemp<MIN_TEMP) {
    String msg="Temperatur unter "+ MIN_TEMP+"°C , Anlage wird ausgeschaltet";
    Log(new Error("WARNING", msg));
    resetAnlage();
  }
}


//Completly reset Anlage
void resetAnlage() {
  AnlageEin=false;
  wiederholungsCounter=0;
  currentState=-1;
  tStart=0;
  tWait=0;
  accumulatedTime=0;
  repeatLastStatesCounter=0;
  wiederholungsCounter=0;

  AnlageBisMorgenAus=false;
  ManuellerModus=false;
}


//Error
class Error {
  String type;
  String text;

  Error(String type, String text) {
    this.type=type;
    this.text=text;
  }
}


//Pad String
String rightPad(String s, char c, int len) {
  String out=s;
  for (int i=0; i < len-s.length(); i++) {
    out+=c;
  }
  return out;
}


//Error Logger
void Log(Error E) {
  String time=nf(day(), 2)+"/"+nf(month(), 2)+"/"+year()+" - "+nf(hour(), 2)+":"+nf(minute(), 2)+":"+nf(second(), 2);
  String str=time +" "+rightPad(E.type, ' ', 8)+ " "+ E.text;   //Log to SD-Card?
  errorLog+=str+"\n";
  println(str);
}
