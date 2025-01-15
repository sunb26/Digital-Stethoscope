#include "BLEServiceCallbacks.h"

void ServerConnectionCallbacks::onConnect(NimBLEServer* pServer, NimBLEConnInfo& connInfo) {
    Serial.println("BLUETOOTH CONNECTED");
}

void ServerConnectionCallbacks::onDisconnect(NimBLEServer* pServer, NimBLEConnInfo& connInfo, int reason) {
    Serial.println("BLUETOOTH DISCONNECTED");
    NimBLEDevice::startAdvertising();
}

void WifiCallbacks::onWrite(NimBLECharacteristic *pCharacteristic, NimBLEConnInfo& connInfo) {
    String value = pCharacteristic->getValue();
    Serial.println(value);

    // TODO: implement code to connect to WiFi
}

void RecordingCallbacks::onWrite(NimBLECharacteristic *pCharacteristic, NimBLEConnInfo& connInfo) {
    String value = pCharacteristic->getValue();
    Serial.println("Recording");
    Serial.println(value);

    // TODO: implement code to trigger recording on the device
}
