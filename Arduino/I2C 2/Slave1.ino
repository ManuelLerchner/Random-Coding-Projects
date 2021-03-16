// Slave 1
#include <Adafruit_NeoPixel.h>
#include <Wire.h>

#define PIN 6
#define N_LEDS 24

Adafruit_NeoPixel strip = Adafruit_NeoPixel(N_LEDS, PIN, NEO_GRB + NEO_KHZ800);

struct colRGB {
    int R;
    int G;
    int B;
};

colRGB color = {255, 0, 0};

void setup() {
    Wire.begin(1);
    Wire.onReceive(evalI2C);
    pinMode(5, OUTPUT);
    strip.begin();
    Serial.begin(9600);

    int g = 2
}

void loop() {
    chase(strip.Color(color.R, color.G, color.B));  // Red
}

void evalI2C(int len) {
    while (Wire.available()) {
        byte b = Wire.read();
        char chr = char(b);

        switch (chr) {
            case 'R':
                color.R = Wire.read();
                color.G = Wire.read();
                color.B = Wire.read();
                break;
        }
    }
}

static void chase(uint32_t c) {
    for (uint16_t i = 0; i < strip.numPixels() + 8; i++) {
        strip.setPixelColor(i % strip.numPixels(), c);
        strip.setPixelColor((12 + i) % strip.numPixels(), c);

        strip.setPixelColor(i - 8, 0);
        strip.setPixelColor(12 + i - 8, 0);
        strip.show();
        delay(25);
    }
}