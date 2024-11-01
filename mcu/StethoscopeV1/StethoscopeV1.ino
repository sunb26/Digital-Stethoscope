#include "BluetoothSerial.h"

#if !defined(CONFIG_BT_ENABLED) || !defined(CONFIG_BLUEDROID_ENABLED)
#error Bluetooth is not enabled! Please run `make menuconfig` to and enable it
#endif
BluetoothSerial SerialBT;


void setup() {
  // put your setup code here, to run once:
  Serial.begin(115200);
  SerialBT.begin("ESP32test/Ben");
  delay(2000);
  Serial.println("Hello"); 
  Serial.println("Bluetooth initialized");
  pinMode(A4, INPUT);


}

void loop() {
  // read the input on analog pin 0:
  int sensorValue = analogRead(A4);
  // print out the value you read:
  Serial.println(sensorValue);
  SerialBT.println(sensorValue);
  delay(1);  // delay in between reads for stability
}
