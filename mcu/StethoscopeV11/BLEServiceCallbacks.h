#ifndef BLE_SERVICE_CALLBACKS_H
#define BLE_SERVICE_CALLBACKS_H

#include <NimBLEDevice.h>

// Debugging callbacks for server connection
class ServerConnectionCallbacks: public NimBLEServerCallbacks {
  void onConnect(NimBLEServer* pServer, NimBLEConnInfo& connInfo) override;
  void onDisconnect(NimBLEServer* pServer, NimBLEConnInfo& connInfo, int reason) override;
};

// Callback for handling WiFi credential writes
class WifiCallbacks: public NimBLECharacteristicCallbacks {
  void onWrite(NimBLECharacteristic *pCharacteristic, NimBLEConnInfo& connInfo) override;
};

// Callback for handling recording trigger writes
class RecordingCallbacks: public NimBLECharacteristicCallbacks {
  void onWrite(NimBLECharacteristic *pCharacteristic, NimBLEConnInfo& connInfo) override;
};

#endif



