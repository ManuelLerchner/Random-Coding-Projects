#include <SPI.h>

const short LED1 = 2;
const short LED2 = 3;
const short LED3 = 4;

void setup() {
    SPI.begin();
    SPI.attachInterrupt();

    pinMode(MISO, OUTPUT);
    
    SPI.
}

void loop() {
}

ISR(SPI_STC_vect) {
    bool a = SPDR;
}