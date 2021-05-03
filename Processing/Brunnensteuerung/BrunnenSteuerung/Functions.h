extern bool AnlageEin;
extern bool AnlageBisMorgenAus;
extern bool WartungsModus;
extern bool ManuellerModus;
extern int wiederholungsCounter;
extern int repeatLastStatesCounter;
extern int currentState;
extern long tStart;
extern long tWait;
extern long accumulatedTime;
extern int DATE;
extern const int MIN_TEMP;


//Completly reset Anlage
void resetAnlage() {
  AnlageEin = false;
  wiederholungsCounter = 0;
  currentState = -1;
  tStart = 0;
  tWait = 0;
  accumulatedTime = 0;
  repeatLastStatesCounter = 0;

  AnlageBisMorgenAus = false;
  ManuellerModus = false;
}


//linear interpolation between colors
color interpolateColors(color A, color B, float t) {
  float r = B.r * t + A.r * (1 - t);
  float g = B.g * t + A.g * (1 - t);
  float b = B.b * t + A.b * (1 - t);

  return color{round(r), round(g), round(b)};
}

//Logger
void Log(Error E) {
  String timeRTC = "01/01/2001 -- 01:01:01"; //Real time Clock
  Serial.println(timeRTC + "   " + E.type + "   " + E.text); //SD Card
}


/////////////////////////////
//External Sensors | Inputs/
///////////////////////////


//Handle Time
void RTC() {
  int day = 1;//day(); //RealTime Clock
  if (day != DATE && DATE != 0) {
    //Neuer Tag um Mitternacht
    AnlageBisMorgenAus = false;
  }
}


//Check Water Level
void WaterLevel() {

  boolean waterLevelAboveMinimum = true; // Input from Sensor  1^= Enough Water

  if (!waterLevelAboveMinimum) {
    String msg = "Wasserstand zu niedrig, Anlage wird ausgeschaltet";
    Log(Error{"WARNING", msg});
    resetAnlage();
  }
}


//Check Temperature
void Temperatur() {

  float currTemp = 10; // Input from Sensor

  if (currTemp < MIN_TEMP) {
    String msg = "Temperatur unter " + String(MIN_TEMP) + "°C , Anlage wird ausgeschaltet";
    Log(Error{"WARNING", msg});
    resetAnlage();
  }
}
