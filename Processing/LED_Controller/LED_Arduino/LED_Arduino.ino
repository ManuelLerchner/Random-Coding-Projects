//A Lerchner Industry Production in collab. width Jesacher Industries

//Pins
int r = 9;
int g = 10;
int b = 11;
int resetbutton = 4;

//Brightness
int rvalue = 0;
int gvalue = 0;
int bvalue = 0;

void setup() {

  pinMode(r, OUTPUT);
  pinMode(g, OUTPUT);
  pinMode(b, OUTPUT);
  pinMode(resetbutton, INPUT);

  Serial.begin(9600);

}

void loop() {

  //Reset
  if (digitalRead(resetbutton) == 1) {
    analogWrite(r, 0);
    analogWrite(g, 0);
    analogWrite(b, 0);
  }

  //Empfangener String
  String UniformSyntax = Serial.readStringUntil('\n');

  // Entspricht der Datenblock dem Format "SrrrgggbbbE\n"?
  if (UniformSyntax.length() == 11  && UniformSyntax.charAt(0) == 'S' && UniformSyntax.charAt(10) == 'E') {

    //Extract Brightnesses
    rvalue = (UniformSyntax.substring(1, 4)).toInt();
    gvalue = (UniformSyntax.substring(4, 7)).toInt();
    bvalue = (UniformSyntax.substring(7, 10)).toInt();

    analogWrite(r, rvalue);
    analogWrite(g, gvalue);
    analogWrite(b, bvalue);

  }




}
