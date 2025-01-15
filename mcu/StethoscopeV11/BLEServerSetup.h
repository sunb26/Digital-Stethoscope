#ifndef BLE_SERVER_SETUP_H
#define BLE_SERVER_SETUP_H

#include <NimBLEDevice.h>
#include <BLEServiceCallbacks.h>

// Services
#define WIFI_SERVICE "5c96e1a0-4022-4310-816f-bcb7245bc802"
#define RECORDING_SERVICE "60ec2f71-22f2-4fc4-84f0-f8d3269e10c0"

// Characteristics
#define WIFI_CREDS_CHARACTERISITIC "a48ce354-6a1b-429d-aca5-1077627d5a25"
#define RECORDING_CHARACTERISTIC "d5435c8c-392f-4e89-87be-89f9964db0e0"

void setupBLE();

#endif
