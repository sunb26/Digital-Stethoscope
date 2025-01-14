#include <Arduino.h>

#define SCK 6
#define MISO 4
#define MOSI 7
#define CS 10

#define I2S_WS 2
#define I2S_SD 3
#define I2S_SCK 1
#define I2S_PORT I2S_NUM_0
#define I2S_SAMPLE_RATE (16000)
#define I2S_SAMPLE_BITS (16)
#define I2S_READ_LEN (16 * 1024)
#define RECORD_TIME (15) // Seconds
#define I2S_CHANNEL_NUM (1)
#define FLASH_RECORD_SIZE (I2S_CHANNEL_NUM * I2S_SAMPLE_RATE * I2S_SAMPLE_BITS / 8 * RECORD_TIME)

#define DBG_OUTPUT_PORT Serial

#define GREEN_LED_PIN 9
#define BLUE_LED_PIN 8
#define RED_LED_PIN 5

#define BUTTON_PIN 18

extern const char *ssid;
extern const char *password;
extern const char *host;

extern const char filename[];

extern bool firstRun;
