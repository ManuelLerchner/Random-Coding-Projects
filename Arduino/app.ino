int led = 5;

bool ledStatus;

void setup() {
    Serial.begin(9600);
    pinMode(5, OUTPUT);
}

void loop() {
    if (Serial.available()) {
        int val = Serial.parseInt();

        if (val == 1) {
            ledStatus ^= true;
        }
    }

    digitalWrite(led, ledStatus);

}