#include "Duese.h"
#include "Helper.h"
#include "Functions.h"

//Pins
const int S_Start = 2; //Taster, Schließer
const int S_Manuell = 7; //Taster, Schließer
const int S_Reset = 4; //Taster, Schließer
const int S_NotHalt = 8; //Schalter, Öffner

const int S_Wasserstand = 6; //Taster, 1^= genung Wasser vorhanden
const int S_Temperatur = A2; //AnalogWert

const int S_Zeitdauer = A0; //AnalogWert
const int S_Wiederholungen = A1; //Analogwert

//Constants
const int ANZAHL_AUSLAESSE = 3;
const int NUM_STATES = 10;
const int MAX_DURCHLAEUFE = 30;
const int MIN_TEMP = 5; // [°C]

//StateTable
int StateTable[ANZAHL_AUSLAESSE + 1][NUM_STATES] = {
  {1, 0, 0, 0, 0, 0, 1, 0, 1, 0}, //Ventil A
  {0, 1, 0, 0, 0, 1, 0, 0, 1, 0}, //Ventil B
  {0, 0, 1, 0, 1, 0, 0, 0, 1, 0}, //Ventil C
  {5, 5, 5, 3, 5, 5, 5, 2, 3, 2}, //Basetime Ventil-ON [sekunden]
};

//Color for each State
color cols[NUM_STATES] = {
  color{255, 0, 0},
  color{255, 91, 0},
  color{255, 183, 0},
  color{234, 255, 0},
  color{142, 255, 0},
  color{51, 255, 0},
  color{0, 255, 40},
  color{0, 255, 132},
  color{0, 255, 224},
  color{0, 193, 255},
};

color currCol = {0, 0, 0};

//Flanken
Flanke F_Start;
Flanke F_Manuell;
Flanke F_Reset;
Flanke F_NotHalt;

//Variablen
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

int DATE;

//Düsen
int PWMPinsA[] = {6, 9, 10};
int PWMPinsB[] = {3, 11, 12};
int PWMPinsC[] = {13, 13, 13};

const int VentilA = 13;
const int VentilB = 13;
const int VentilC = 13;

Duese Duesen[ANZAHL_AUSLAESSE] = {
  Duese(PWMPinsA, VentilA),
  Duese(PWMPinsB, VentilB),
  Duese(PWMPinsC, VentilC),
};

void setup() {

  Serial.begin(9600);

  //Pinmodes
  pinMode(S_Start, INPUT);
  pinMode(S_Manuell, INPUT);
  pinMode(S_Reset, INPUT);
  pinMode(S_NotHalt, INPUT);

  //RGB Düse 1
  pinMode(6, OUTPUT);
  pinMode(9, OUTPUT);
  pinMode(10, OUTPUT);

  //RGB Düse 2
  pinMode(3, OUTPUT);
  pinMode(11, OUTPUT);
  pinMode(12, OUTPUT);

  String msg = "Anlage wurde eingeschaltet";
  Log(Error{"INFO", msg});

}

void loop() {
  detectButtonPresses();

  if (AnlageEin) {

    //Wiederholen
    if (wiederholungsCounter < Wiederholungen) {

      //Zustand fertig
      if (millis() - tStart > tWait) {
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
        tWait = round(StateTable[ANZAHL_AUSLAESSE][currentState] * 1000 * ZeidauerFaktor);
        accumulatedTime += tWait;

        //Maximale Durchläufe erreicht ---> Wartungsmodus
        if (durchlaufCounter >= MAX_DURCHLAEUFE && !WartungsModus) {
          WartungsModus = true;
          String msg = "Maximale Durchläufe erreicht, Anlage wird nach diesem Durchgang für Wartung deaktiviert";
          Log(Error{"WARNING", msg});
        }
      }
    }


    //Zyklus Abgeschlossen --> Anlage bis Morgen deaktiviert
    if (wiederholungsCounter >= Wiederholungen) {
      AnlageEin = false;
      wiederholungsCounter = 0;
      currentState = -1;

      if (ManuellerModus) {
        String msg = "Manueller Zyklus abgeschlossen";
        Log(Error{"INFO", msg});
      } else {
        AnlageBisMorgenAus = true;
        DATE = 1;//day(); ///REAL TIME CLOCK

        String msg = "Zyklus abgeschlossen, Anlage bis Morgen deaktiviert";
        Log(Error{"INFO", msg});
      }
    }
  }

  //Check Water height
  if (AnlageEin) {
    WaterLevel();
    Temperatur();
  }

  //Check Time
  RTC();

  if (AnlageEin) {
    float t = (float)(millis() - tStart) / tWait;
    color A = cols[currentState];
    color B = cols[(currentState + 1) % NUM_STATES];
    currCol = interpolateColors(A, B, t);
  }

  //Set Düsen State
  for (int i = 0; i < ANZAHL_AUSLAESSE; i++) {
    Duesen[i].ventilState = AnlageEin ? boolean(StateTable[i][currentState]) : false;
    Duesen[i].RGBCol = AnlageEin ? currCol : color{0, 0, 0};
    Duesen[i].show();
  }

}


///////////////////////////////////////////////
////////////Detect Buttons Presses////////////
/////////////////////////////////////////////

void detectButtonPresses() {
  bool fStart = F_Start.fPos(digitalRead(S_Start));
  bool fManuell = F_Manuell.fPos(digitalRead(S_Manuell));
  bool fReset = F_Reset.fPos(digitalRead(S_Reset));
  bool fNotHalt = F_NotHalt.fPos(digitalRead(S_NotHalt));

  //Automatischer Start Taster
  if (fStart && !AnlageBisMorgenAus && !WartungsModus) {
    AnlageEin = true;
    ManuellerModus = false;
    durchlaufCounter++;

    Wiederholungen =  10; // Drehregler [30,120]
    ZeidauerFaktor =  0.5; // Drehregler [1/3 , 3]

    String msg = "Start Automatik Modus:  Wiederholungen: " + String(Wiederholungen) + ", ZeitFaktor: " + String(ZeidauerFaktor) + ", Expected Time: " + String(ZeidauerFaktor * 60) + "s";
    Log(Error{"INFO", msg});
  }

  //Manueller Start Taster
  if (fManuell && !WartungsModus) {
    AnlageEin = true;
    ManuellerModus = true;
    durchlaufCounter++;

    Wiederholungen =  1;
    ZeidauerFaktor =  0.3; // Drehregler [1/3 , 3]

    String msg = "Start Manueller Modus:  Wiederholungen: " + String(Wiederholungen) + ", ZeitFaktor: " + String(ZeidauerFaktor) + ", Expected Time: " + String(ZeidauerFaktor * 60) + "s";
    Log(Error{"INFO", msg});
  }

  //Reset Anlage
  if (fReset) {
    WartungsModus = false;
    durchlaufCounter = 0;
    AnlageBisMorgenAus = false;

    String msg = "Wartung abgeschlossen, Anlage wieder bereit";
    Log(Error{"INFO", msg});
  }


  //Not Halt
  if (digitalRead(S_NotHalt) && AnlageEin) {
    resetAnlage();

    if (fNotHalt) {
      String msg = "NOT-HALT betätigt, Anlage wird Ausgeschaltet";
      Log(Error{"INFO", msg});
    }
  }
  
}
