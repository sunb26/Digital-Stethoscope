#include "Config.h"
#include "InitializeSD.h"
#include "ServerUpload.h"
#include "i2sMicrophone.h"
#include "BLEServerSetup.h"
#include "BLEServiceCallbacks.h"

bool firstRun = true;

void setup(void) {
  
  if (firstRun == true){
    DBG_OUTPUT_PORT.begin(115200);
    DBG_OUTPUT_PORT.setDebugOutput(true);
    DBG_OUTPUT_PORT.print("\n");
  
    pinMode(GREEN_LED_PIN, OUTPUT);
    pinMode(BLUE_LED_PIN, OUTPUT);
    pinMode(RED_LED_PIN, OUTPUT);
  
    digitalWrite(GREEN_LED_PIN, HIGH);
    digitalWrite(BLUE_LED_PIN, LOW); 
    digitalWrite(RED_LED_PIN, LOW);
    
    setupBLE();
    initializeSD(); //try to put this first before the if statement

    
    while (ssid == NULL){
      delay(10);
    }
    initializeServer();

    firstRun = false;

    Serial.println(startStop);
    while(startStop == "stop"){
      delay (10);
      }

  }
  
  initializeServer(); //try this before if statement
  
  
  // Start I2S ADC task
  i2sInit();
  xTaskCreate(i2s_adc, "i2s_adc", 1024 * 4, NULL, 1, NULL);
}
 
void loop(void) {
  server.handleClient();


  if (isRecordingComplete == true){ 
    if (startStop == "start"){
      isRecordingComplete == false;
      setup();
    }
  }
    
  delay(2);  //allow the cpu to switch to other tasks
}
