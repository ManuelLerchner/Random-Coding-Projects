#include <RTClib.h>
#include <SPI.h>
#include <SD.h>
#include <Wire.h>

#include "Duese.h"
#include "Helper.h"
#include "Functions.h"

//////////
//Pins///
////////

//Taster
const int S_Start = 22; //Taster, Schließer
const int S_Manuell = 23; //Taster, Schließer
const int S_Reset = 24; //Taster, Schließer
const int S_NotHalt = 25; //Schalter, Öffner

//Leds
const int LED_AnlageEin = 26;
const int LED_ManuellerModus = 27;
const int LED_WartungsModus = 28;
const int LED_AnlageBisMorgenAus = 29;

//Sensoren
const int S_TemperaturOK = 30;
const int S_Wasserstand = 31; //Taster, 1^= genung Wasser vorhanden

const int S_Temperatur = A0; //AnalogWert
const int S_Zeitdauer = A1; //AnalogWert
const int S_Wiederholungen = A2; //Analogwert

//Düsen
const int RGBPinsVentilA[] = {2, 3, 4};
const int RGBPinsVentilB[] = {5, 6, 7};
const int RGBPinsVentilC[] = {8, 9, 10};

const int Pin_VentilA = 11;
const int Pin_VentilB = 12;
const int Pin_VentilC = 13;

//Motor
const int Pin_Motor = 32;


///////////////
//Constants///
/////////////

const int ANZAHL_AUSLAESSE = 3;
const int NUM_STATES = 10;
const int MAX_DURCHLAEUFE = 30;
const int MIN_TEMP = 5; // [°C]

//StateTable
const int StateTable[ANZAHL_AUSLAESSE + 1][NUM_STATES] = {
  {1, 0, 0, 0, 0, 0, 1, 0, 1, 0}, //Ventil A
  {0, 1, 0, 0, 0, 1, 0, 0, 1, 0}, //Ventil B
  {0, 0, 1, 0, 1, 0, 0, 0, 1, 0}, //Ventil C
  {5, 5, 5, 3, 5, 5, 5, 2, 3, 2}, //Basetime Ventil-ON [sekunden]
};

//Color for each State
const Color cols[NUM_STATES] = {
  Color{255, 0, 0},
  Color{255, 91, 0},
  Color{255, 183, 0},
  Color{234, 255, 0},
  Color{142, 255, 0},
  Color{51, 255, 0},
  Color{0, 255, 40},
  Color{0, 255, 132},
  Color{0, 255, 224},
  Color{0, 193, 255},
};

///////////////
//Variables///
/////////////

bool AnlageEin;
bool AnlageBisMorgenAus;
bool WartungsModus;
bool ManuellerModus;

int Wiederholungen; // Drehregler [30,120]
float ZeidauerFaktor; // Drehregler [1/3 , 3]

int repeatLastStatesCounter;
int wiederholungsCounter;
int durchlaufCounter;

long tWait;
long tStart;
long accumulatedTime;

int currentState = -1;

int DATE; // TODO

Color currCol = {0, 0, 0};

//Flanken
Flanke F_Start;
Flanke F_Manuell;
Flanke F_Reset;
Flanke F_NotHalt;

//Duesen
Duese Duesen[ANZAHL_AUSLAESSE] = {
  Duese(RGBPinsVentilA, Pin_VentilA),
  Duese(RGBPinsVentilB, Pin_VentilB),
  Duese(RGBPinsVentilC, Pin_VentilC),
};


//Modules
RTC_DS1307 rtc;
File myFile;
const int pinCS = 53;

void setup() {

  Serial.begin(9600);
  SD.begin();
  rtc.begin();

  rtc.adjust(DateTime(F(__DATE__), F(__TIME__)));

  //Pinmodes
  pinMode(S_Start, INPUT);
  pinMode(S_Manuell, INPUT);
  pinMode(S_Reset, INPUT);
  pinMode(S_NotHalt, INPUT);

  pinMode(S_TemperaturOK, INPUT);
  pinMode(S_Wasserstand, INPUT);

  pinMode(Pin_Motor, OUTPUT);

  pinMode(pinCS, OUTPUT);

  String msg = "Anlage wurde eingeschaltet";
  Log(Error{"INFO", msg});

}

void loop() {
  detectButtonPresses();

  if (AnlageEin) {

    //Wiederholen
    if (wiederholungsCounter < Wiederholungen) {

      //Zustand fertig?
      if ((unsigned long)(millis() - tStart) > tWait) {
        currentState++;

        // reached last State
        if (currentState == NUM_STATES) {

          //can repeat last two States?
          if (repeatLastStatesCounter < 4) {
            repeatLastStatesCounter++;
            currentState = NUM_STATES - 2;
          } else {

            //Durchlauf abgeschlossen
            String msg = "Durchlauf: " + String(wiederholungsCounter + 1) + ", finished, took: " + String(accumulatedTime / 1000.0) + "s";
            Log(Error{"INFO", msg});

            repeatLastStatesCounter = 0;
            wiederholungsCounter++;
            currentState = 0;
            accumulatedTime = 0;
          }
        }

        //Start new State
        tStart = millis();
        accumulatedTime += tWait;

        //Maximale Durchläufe erreicht ---> Wartungsmodus
        if (durchlaufCounter >= MAX_DURCHLAEUFE && !WartungsModus) {
          WartungsModus = true;
          String msg = "Maximale Durchläufe erreicht, Anlage wird nach diesem Durchgang für Wartung deaktiviert";
          Log(Error{"WARNING", msg});
        }
      }
      //Live update tWait, (based on Zeitdauer-Input)
      tWait = round(StateTable[ANZAHL_AUSLAESSE][currentState] * 1000 * ZeidauerFaktor);
    }


    //Zyklus Abgeschlossen --> Anlage bis Morgen deaktiviert
    if (wiederholungsCounter >= Wiederholungen) {
      AnlageEin = false;
      wiederholungsCounter = 0;
      currentState = -1;

      if (ManuellerModus) {
        String msg = "Manueller Zyklus abgeschlossen";
        ManuellerModus = false;
        Log(Error{"INFO", msg});
      } else {
        AnlageBisMorgenAus = true;
        DateTime now = rtc.now();
        DATE = now.day(); //REAL TIME CLOCK

        String msg = "Zyklus abgeschlossen, Anlage bis Morgen deaktiviert";
        Log(Error{"INFO", msg});
      }
    }
  }

  //Lerp Color
  if (AnlageEin) {
    float t = (float)(millis() - tStart) / tWait;
    Color A = cols[currentState];
    Color B = cols[(currentState + 1) % NUM_STATES];
    currCol = interpolateColors(A, B, t);
  }

  //////////////////////
  //Check for Events///
  ////////////////////

  //Check Water height
  if (AnlageEin) {
    WaterLevel();
    Temperatur();
  }

  //Check Time
  RTC();

  //Check Zeitdauer Potenziometer
  getZeidauerFaktor();


  ////////////////////////
  //Ausgänge Ansteuern///
  //////////////////////

  //Set Düsen State
  for (int i = 0; i < ANZAHL_AUSLAESSE; i++) {
    Duesen[i].ventilState = AnlageEin ? boolean(StateTable[i][currentState]) : false;
    Duesen[i].RGBCol = AnlageEin ? currCol : Color{0, 0, 0};
    Duesen[i].show();
  }

  //Should Motor be activated?
  bool motorState = false;
  for (int i = 0; i < ANZAHL_AUSLAESSE; i++) {
    if (Duesen[i].ventilState == true) {
      motorState = true;
      break;
    };
  }

  //Activate Motor
  digitalWrite(Pin_Motor, motorState);

  //Set Status-Leds
  digitalWrite(LED_AnlageEin, AnlageEin );
  digitalWrite(LED_AnlageBisMorgenAus, AnlageBisMorgenAus );
  digitalWrite(LED_WartungsModus, WartungsModus );
  digitalWrite(LED_ManuellerModus, ManuellerModus );
}



///////////////////////////////////////////////
////////////Detect Buttons Presses////////////
/////////////////////////////////////////////

void detectButtonPresses() {
  bool fStart = F_Start.fPos(digitalRead(S_Start));
  bool fManuell = F_Manuell.fPos(digitalRead(S_Manuell));
  bool fReset = F_Reset.fPos(digitalRead(S_Reset));
  bool fNotHalt = F_NotHalt.fNeg(digitalRead(S_NotHalt));


  //Automatischer Start Taster
  if (fStart && !AnlageBisMorgenAus && !WartungsModus) {
    AnlageEin = true;
    ManuellerModus = false;
    durchlaufCounter++;

    getWiederholungen(); // Drehregler [30,120]

    String msg = "Start Automatik Modus:  Wiederholungen: " + String(Wiederholungen) + ", ZeitFaktor: " + String(ZeidauerFaktor) + ", Expected Time: " + String(ZeidauerFaktor * 60) + "s";
    Log(Error{"INFO", msg});
  }


  //Manueller Start Taster
  if (fManuell && !WartungsModus) {
    AnlageEin = true;
    ManuellerModus = true;
    durchlaufCounter++;

    Wiederholungen =  1;

    String msg = "Start Manueller Modus:  Wiederholungen: " + String(Wiederholungen) + ", ZeitFaktor: " + String(ZeidauerFaktor) + ", Expected Time: " + String(ZeidauerFaktor * 60) + "s";
    Log(Error{"INFO", msg});
  }


  //Reset Anlage, Wartung abgeschossen
  if (fReset) {
    WartungsModus = false;
    durchlaufCounter = 0;
    AnlageBisMorgenAus = false;

    String msg = "Wartung abgeschlossen, Anlage wieder bereit";
    Log(Error{"INFO", msg});
  }


  //Not Halt
  if (!digitalRead(S_NotHalt) && AnlageEin) {
    resetAnlage();

    if (fNotHalt) {
      String msg = "NOT-HALT betätigt, Anlage wird Ausgeschaltet";
      Log(Error{"INFO", msg});
    }
  }

}
