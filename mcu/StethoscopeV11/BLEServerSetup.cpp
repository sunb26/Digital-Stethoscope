#include <BLEServerSetup.h>

NimBLEServer *bServer;

void setupBLE() {
  Serial.println("Setting up bluetooth services");

  NimBLEDevice::init("Heartlink 01");
  bServer = NimBLEDevice::createServer();
  bServer->setCallbacks(new ServerConnectionCallbacks());

  // Configure Advertising services and characteristics
  NimBLEService *wifiService = bServer->createService(WIFI_SERVICE);
  NimBLEService *recordService = bServer->createService(RECORDING_SERVICE);

  NimBLECharacteristic *connectWifiCharacteristic = wifiService->createCharacteristic(
    WIFI_CREDS_CHARACTERISITIC, NIMBLE_PROPERTY::WRITE
  );
  NimBLECharacteristic *recordCharacteristic = recordService->createCharacteristic(
    RECORDING_CHARACTERISTIC, NIMBLE_PROPERTY::WRITE
  );

  connectWifiCharacteristic->setCallbacks(new WifiCallbacks());
  recordCharacteristic->setCallbacks(new RecordingCallbacks());

  wifiService->start();
  recordService->start();

  // Advertising device config
  NimBLEAdvertising *pAdvertising = NimBLEDevice::getAdvertising();
  pAdvertising->addServiceUUID(WIFI_SERVICE);
  pAdvertising->addServiceUUID(RECORDING_SERVICE);
  pAdvertising->start();
}