#include "BLEServiceCallbacks.h"

const char *ssid = NULL;
const char *password = NULL;
String startStop = "stop";

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
    
    int delimiterIndex = value.indexOf('&');

    int ssidLength = value.substring(0, delimiterIndex).toInt();
    String combined = value.substring(delimiterIndex + 1);

    static char parsedSSID[32];  // Adjust size to the max expected SSID length
    static char parsedPassword[64];  // Adjust size to the max expected password length

    combined.substring(0, ssidLength).toCharArray(parsedSSID, sizeof(parsedSSID));
    combined.substring(ssidLength).toCharArray(parsedPassword, sizeof(parsedPassword));

    ssid = parsedSSID;
    password = parsedPassword;

    Serial.println(ssid);
    Serial.println(password);

}

void RecordingCallbacks::onWrite(NimBLECharacteristic *pCharacteristic, NimBLEConnInfo& connInfo) {
    startStop = pCharacteristic->getValue();
    Serial.println("Recording");
    Serial.println(startStop);

    // TODO: implement code to trigger recording on the device
}
