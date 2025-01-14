#include "Config.h"
#include <Arduino.h>
#include "InitializeSD.h"

#include <driver/i2s.h>

extern volatile bool isRecordingComplete;


void i2sInit();
void i2s_adc(void *arg);