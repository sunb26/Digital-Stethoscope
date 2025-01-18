#include "Config.h"
#include "InitializeSD.h"
#include <Arduino.h>

#include <WiFi.h>
#include <NetworkClient.h>
#include <WebServer.h>
#include <ESPmDNS.h>

#include <SPI.h>
#include <SD.h>

extern WebServer server;

// extern const char* ssid;
// extern const char* password;

void initializeServer();
