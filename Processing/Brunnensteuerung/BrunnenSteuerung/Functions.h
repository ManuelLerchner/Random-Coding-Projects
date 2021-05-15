#include "Helper.h"

extern bool AnlageEin;
extern bool AnlageBisMorgenAus;
extern bool WartungsModus;
extern bool ManuellerModus;

extern int wiederholungsCounter;
extern int repeatLastStatesCounter;
extern int Wiederholungen;
extern int currentState;
extern int DATE;

extern long tStart;
extern long tWait;
extern long accumulatedTime;

extern float ZeidauerFaktor;

extern const int MIN_TEMP;
extern const int S_Zeitdauer, S_Wiederholungen, S_TemperaturOK, S_Temperatur, S_Wasserstand;

extern RTC_DS1307 rtc;
extern File myFile;


//////////////
//Functions//
////////////


//Completly reset Anlage
void resetAnlage() {
  AnlageEin = false;
  AnlageBisMorgenAus = false;
  ManuellerModus = false;
  WartungsModus = false;

  wiederholungsCounter = 0;
  currentState = -1;
  tStart = 0;
  tWait = 0;
  accumulatedTime = 0;
  repeatLastStatesCounter = 0;
}


//linear interpolation between colors
Color interpolateColors(Color A, Color B, float t) {
  float r = B.r * t + A.r * (1 - t);
  float g = B.g * t + A.g * (1 - t);
  float b = B.b * t + A.b * (1 - t);

  return Color{round(r), round(g), round(b)};
}


//Logger
void Log(Error E) {
  DateTime now = rtc.now();
  String timeRTC = String(now.day()) + "/" + String(now.month()) + "/" + String(now.year()) + " -- " + String(now.hour()) + ":" + String(now.minute()) + ":" + String(now.second());
  String finalString = timeRTC + "   " + E.type + "   " + E.text;

  Serial.println(finalString);

  //SD Card
  myFile = SD.open("Brunnensteuerung-Log.txt", FILE_WRITE);
  myFile.println(finalString);
  myFile.close();
}


//////////////////////////////
//External Sensors | Inputs//
////////////////////////////


//Handle Time
void RTC() {
  DateTime now = rtc.now();

  if (now.day() != DATE && DATE != 0) {
    //Neuer Tag um Mitternacht
    AnlageBisMorgenAus = false;
  }
}


//Check Water Level
void WaterLevel() {

  boolean waterLevelAboveMinimum = digitalRead(S_Wasserstand); //   1^= Enough Water

  if (!waterLevelAboveMinimum) {
    String msg = "Wasserstand zu niedrig, Anlage wird ausgeschaltet";
    Log(Error{"WARNING", msg});
    resetAnlage();
  }
}


//Check Temperature
void Temperatur() {

  float currVoltage = analogRead(S_Temperatur) * 5.0 / 1023;
  float currTemp = mapf(currVoltage, 0, 5.0, -20.0, 50.0);   // Annahme: Sensorwert annähernd Linear, da B sehr klein ist [  R_PT100 (ϑ)=100Ω⋅ (1+A⋅ ϑ+B⋅ ϑ^2 ) ]

  bool tempOK = digitalRead(S_TemperaturOK); //   1^= Temperatur OK

  if (!tempOK) {
    String msg = "Temperaturwert konnte nicht eindeutig ermittelt werden, Anlage wird ausgeschaltet";
    Log(Error{"WARNING", msg});
    resetAnlage();
    return;
  }

  if (currTemp < MIN_TEMP) {
    String msg = "Derzeitige Temperatur beträgt: " + String(currTemp) + "°C Die Minimaltemperatur beträgt " + String(MIN_TEMP) + "°C, Anlage wird ausgeschaltet";
    Log(Error{"WARNING", msg});
    resetAnlage();
  }
}


// Get ZeidauerFaktor
void getZeidauerFaktor() {
  int analogVal = analogRead(S_Zeitdauer);
  ZeidauerFaktor = mapf(analogVal, 0, 1024, 1 / 3.0, 3); // Ranges from [1/3 , 3]
}


// Get Wiederholungen
void getWiederholungen() {
  int analogVal = analogRead(S_Wiederholungen);
  Wiederholungen = map(analogVal, 0, 1024, 30, 121); // Ranges from [30 , 120]
}
