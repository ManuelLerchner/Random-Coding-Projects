int selectedSlave;
const int button = 5;

bool flankenMerker;

void setup() {
    Serial.begin(9600);

    pinMode(button, INPUT);
}

void loop() {
    bool taster = digitalRead(button);
    bool flanke = taster && !flankenMerker;
    flankenMerker = taster;

    if (flanke) {
        int value = analogRead(A0);
        int selectedSlave = map(value, 0, 1024, 0, 2);

        Serial.println(selectedSlave);
    }
}