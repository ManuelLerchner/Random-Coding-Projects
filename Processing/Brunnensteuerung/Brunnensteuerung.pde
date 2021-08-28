ArrayList<Duese> Duesen=new ArrayList();
ArrayList<WaterParticle> Water=new ArrayList();


final int ANZAHL_AUSLAESSE=3;
final int MAX_DURCHLAEUFE=30;
final int MIN_TEMP=5;  // [°C]

int[][] StateTable={
  {1, 0, 0, 0, 0, 0, 1, 0, 1, 0}, //Ventil A
  {0, 1, 0, 0, 0, 1, 0, 0, 1, 0}, //Ventil B
  {0, 0, 1, 0, 1, 0, 0, 0, 1, 0}, //Ventil C
  {5, 5, 5, 3, 5, 5, 5, 2, 3, 2}, //Basetime Ventil-ON [sekunden]
};


//Every State has a unique color
color[] cols={
  color(255, 0, 0), 
  color(255, 91, 0), 
  color(255, 183, 0), 
  color(234, 255, 0), 
  color(142, 255, 0), 
  color(51, 255, 0), 
  color(0, 255, 40), 
  color(0, 255, 132), 
  color(0, 255, 224), 
  color(0, 193, 255), 
};

color currCol=color(0);

int numStates=StateTable[0].length;
int currentState=-1;

long tWait;
long tStart;
long accumulatedTime;

int Wiederholungen; // Drehregler [30,120]
float ZeidauerFaktor; // Drehregler [1/3 , 3]

int repeatLastStatesCounter;
int wiederholungsCounter;
int durchlaufCounter;

boolean AnlageEin;
boolean AnlageBisMorgenAus;
boolean WartungsModus;
boolean ManuellerModus;

int DATE;  // Monatstag [1,31]

String errorLog="";


void setup() {
  size(800, 600);
  rectMode(CENTER);
  textAlign(TOP,LEFT);

  for (int i=1; i <= ANZAHL_AUSLAESSE; i++) {
    PVector pos=new PVector(width/(ANZAHL_AUSLAESSE+1)*i, height-100);
    Duesen.add(new Duese(pos));
  }

  String msg="Anlage wurde eingeschaltet";
  Log(new Error("INFO", msg));
}


void draw() {
  background(51);
  fill(255);
  text(errorLog, 10, 20);
  if (AnlageEin) {

    //Wiederholen
    if (wiederholungsCounter<Wiederholungen) {

      //Zustand fertig
      if (millis()-tStart>tWait) {
        currentState++;

        // reached last State
        if (currentState==numStates) { 

          //can repeat last two States?
          if (repeatLastStatesCounter<4) {
            repeatLastStatesCounter++;
            currentState=numStates-2;
          } else {

            //Durchlauf abgeschlossen
            String msg="Durchlauf: "+ (wiederholungsCounter+1)+ ", finished, took: "+ accumulatedTime/1000.0+"s";
            Log(new Error("INFO", msg));

            repeatLastStatesCounter=0;
            wiederholungsCounter++;
            currentState=0;
            accumulatedTime=0;
          }
        }

        //Start new State
        tStart=millis();
        tWait=round(StateTable[ANZAHL_AUSLAESSE][currentState]*1000*ZeidauerFaktor);
        accumulatedTime+=tWait;

        //Maximale Durchläufe erreicht ---> Wartungsmodus
        if (durchlaufCounter>=MAX_DURCHLAEUFE && !WartungsModus) {
          WartungsModus=true;
          String msg="Maximale Durchläufe erreicht, Anlage wird nach diesem Durchgang für Wartung deaktiviert";
          Log(new Error("WARNING", msg));
        }
      }
    }


    //Zyklus Abgeschlossen --> Anlage bis Morgen deaktiviert
    if (wiederholungsCounter>=Wiederholungen) {
      AnlageEin=false;
      wiederholungsCounter=0;
      currentState=-1;

      if (ManuellerModus) {
        String msg="Manueller Zyklus abgeschlossen";
        Log(new Error("INFO", msg));
      } else {
        AnlageBisMorgenAus=true;
        DATE=day();

        String msg="Zyklus abgeschlossen, Anlage bis Morgen deaktiviert";
        Log(new Error("INFO", msg));
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

  //Interpolate between Colors
  if (AnlageEin) {
    float t=(float)(millis()-tStart)/tWait;

    color A=cols[currentState];
    color B=cols[(currentState+1)%numStates];
    currCol=interpolateColors(A, B, t);
  }


  //Set Düsen State
  for (int i=0; i < ANZAHL_AUSLAESSE; i++) {
    Duesen.get(i).ventilState=AnlageEin?boolean(StateTable[i][currentState]):false;
    Duesen.get(i).RGBCol=AnlageEin?currCol:color(0);
  }


  visualizeGraphics();

 //saveFrame("data/image-######.png");
}
