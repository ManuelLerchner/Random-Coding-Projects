int AO[3] = {7, 8, 9};
int AU[3] = {2, 3, 4};

int tO = 12;
int tU = 13;
int WarteLampe = 11;

int tasterOState;
int tasterUState;
boolean FlankeOben;
boolean FlankeUnten;

String StateAmpelOben;
String StateAmpelUnten;

long WaitTime = 2000;


void setup() {
  for (int i = 0; i < 3; i++) {
    pinMode(AO[i], OUTPUT);
    pinMode(AU[i], OUTPUT);
  }
  pinMode(tO, INPUT);
  pinMode(tU, INPUT);
  pinMode(WarteLampe, OUTPUT);

  Serial.begin(9600);
  Serial.println("Ampeln Bereit \n");

  AmpelObenGrun();
  AmpelUntenRot();

}

void loop() {
  FlankenErkennungTaster();

  //Algorithmus1
  if (FlankeUnten == true && StateAmpelUnten == "RotU") {
    delay(WaitTime / 2);
    AmpelObenGrunZuRot();

    //WartenUmAutosPassierenZuLassen
    Serial.println("WarteLampe");
    for (int i = 0; i < 6; i++) {
      digitalWrite(WarteLampe, HIGH);
      delay(500);
      digitalWrite(WarteLampe, LOW);
      delay(500);
    }

    AmpelUntenRotZuGrun();
    Serial.println("\n");
  }

  //Algorithmus2
  if (FlankeOben == true && StateAmpelOben == "RotO") {
    delay(WaitTime / 2);
    AmpelUntenGrunZuRot();

    //WartenUmAutosPassierenZuLassen
    Serial.println("WarteLampe");
    for (int i = 0; i < 6; i++) {
      digitalWrite(WarteLampe, HIGH);
      delay(500);
      digitalWrite(WarteLampe, LOW);
      delay(500);
    }

    AmpelObenRotZuGrun();
    Serial.println("\n");
  }
  //////////////////////////////////////////////////////////////////////

  //ResetFlanken
  FlankeUnten = false;
  FlankeOben =  false;
}


//////////////////////////////////////////////////////////////////////
///////////////////////Flankenerkennung///////////////////////////////
//////////////////////////////////////////////////////////////////////

void FlankenErkennungTaster() {
  int tasterOStateVorher = tasterOState;
  int tasterUStateVorher = tasterUState;
  tasterOState = digitalRead(tO);
  tasterUState = digitalRead(tU);

  if (tasterOState == 1 && tasterOStateVorher == 0) {
    FlankeOben = true;
    Serial.println("AutoOben");
  }
  if (tasterUState == 1 && tasterUStateVorher == 0) {
    FlankeUnten = true;
    Serial.println("AutoUnten");
  }
}
//////////////////////////////////////////////////////////////////////
////////////////////////AmpelOben/////////////////////////////////////
//////////////////////////////////////////////////////////////////////

void AmpelObenGrun() {
  StateAmpelOben = "GrunO";
  Serial.println(StateAmpelOben);

  digitalWrite(AO[0], LOW);
  digitalWrite(AO[1], LOW);
  digitalWrite(AO[2], HIGH);
}
void AmpelObenRot() {
  StateAmpelOben = "RotO";
  Serial.println(StateAmpelOben);

  digitalWrite(AO[0], HIGH);
  digitalWrite(AO[1], LOW);
  digitalWrite(AO[2], LOW);
}

void AmpelObenGrunZuRot() {
  StateAmpelOben = "ÜbergangGrunRotO";
  Serial.println(StateAmpelOben);

  digitalWrite(AO[0], LOW);
  digitalWrite(AO[1], HIGH);
  digitalWrite(AO[2], LOW);
  delay(WaitTime);
  AmpelObenRot();
}
void AmpelObenRotZuGrun() {
  StateAmpelOben = "ÜbergangRotGrunO";
  Serial.println(StateAmpelOben);

  for (int i = 0; i < 5; i++) {
    digitalWrite(AO[0], LOW);
    digitalWrite(AO[1], HIGH);
    digitalWrite(AO[2], LOW);
    delay(500);
    digitalWrite(AO[0], LOW);
    digitalWrite(AO[1], LOW);
    digitalWrite(AO[2], LOW);
    delay(500);
  }
  AmpelObenGrun();
  delay(WaitTime);
}

//////////////////////////////////////////////////////////////////////
///////////////////AmpelUnten/////////////////////////////////////////
//////////////////////////////////////////////////////////////////////

void AmpelUntenGrun() {
  StateAmpelUnten = "GrunU";
  Serial.println(StateAmpelUnten);

  digitalWrite(AU[0], LOW);
  digitalWrite(AU[1], LOW);
  digitalWrite(AU[2], HIGH);
}

void AmpelUntenRot() {
  StateAmpelUnten = "RotU";
  Serial.println(StateAmpelUnten);

  digitalWrite(AU[0], HIGH);
  digitalWrite(AU[1], LOW);
  digitalWrite(AU[2], LOW);
}

void AmpelUntenGrunZuRot() {
  StateAmpelUnten = "ÜbergangGrunRotU";
  Serial.println(StateAmpelUnten);

  digitalWrite(AU[0], LOW);
  digitalWrite(AU[1], HIGH);
  digitalWrite(AU[2], LOW);
  delay(WaitTime);
  AmpelUntenRot();
}

void AmpelUntenRotZuGrun() {
  StateAmpelUnten = "ÜbergangRotGrunU";
  Serial.println(StateAmpelUnten);

  for (int i = 0; i < 5; i++) {
    digitalWrite(AU[0], LOW);
    digitalWrite(AU[1], HIGH);
    digitalWrite(AU[2], LOW);
    delay(500);
    digitalWrite(AU[0], LOW);
    digitalWrite(AU[1], LOW);
    digitalWrite(AU[2], LOW);
    delay(500);
  }
  AmpelUntenGrun();
  delay(WaitTime);
}
