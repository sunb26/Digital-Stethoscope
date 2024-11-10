
// =============================================================================================================================
//--------------------------------------------
// ESP32-C3 /S3 Includes defines and initialisations
//--------------------------------------------

#include <NimBLEDevice.h>      // For BLE communication  https://github.com/h2zero/NimBLE-Arduino
#include <Preferences.h>
#include <driver/i2s.h>
 
// Define I2S pins for ESP32-C3
#define I2S_WS 2      // Word Select (L/R) - GPIO 2
#define I2S_SD 3      // Serial Data In    - GPIO 3
#define I2S_SCK 1     // Serial Clock      - GPIO 1
 
// I2S Processor
#define I2S_PORT I2S_NUM_0
 
// Define input buffer length
#define bufferLen 128
int16_t sBuffer[bufferLen];

Preferences FLASHSTOR;
static  uint32_t msTick;                        // Number of millisecond ticks since we last incremented the second counter
int number = 0;
float mean = 0;
//--------------------------------------------
// BLE   //#include <NimBLEDevice.h>
//--------------------------------------------
BLEServer *pServer = NULL;
BLECharacteristic * pTxCharacteristic;
//NimBLECharacteristic *pCharacteristic;

bool deviceConnected    = false;
bool oldDeviceConnected = false;
std::string ReceivedMessageBLE;

#define SERVICE_UUID           "6E400001-B5A3-F393-E0A9-E50E24DCCA9E"        // UART service UUID
#define CHARACTERISTIC_UUID_RX "6E400002-B5A3-F393-E0A9-E50E24DCCA9E"
#define CHARACTERISTIC_UUID_TX "6E400003-B5A3-F393-E0A9-E50E24DCCA9E"

//----------------------------------------
// Common
//----------------------------------------

char sptext[120];                        // For common print use 
struct EEPROMstorage {                   // Data storage in EEPROM to maintain them after power loss
  char Ssid[30];
  char Password[40];
  char BLEbroadcastName[30];             // Name of the BLE beacon
  byte UseBLELongString = 0;             // Send strings longer than 20 bytes per message. Possible in IOS app BLEserial Pro 
  int  Checksum         = 0;
}  Mem; 

//--------------------------------------------
// Menu
//0        1         2         3         4
//1234567890123456789012345678901234567890----  
 char menu[][40] = 
 {
 "A SSID", 
 "B Password",
 "C BLE beacon name",
 "I Print this menu",
 "R Reset settings"
 };
 
//  -------------------------------------   End Definitions  ---------------------------------------
//                                                                                            //

//--------------------------------------------
// ARDUINO Setup
//--------------------------------------------

void i2s_install() {
  // Set up I2S Processor configuration
  const i2s_config_t i2s_config = {
    .mode = i2s_mode_t(I2S_MODE_MASTER | I2S_MODE_RX),
    .sample_rate = 16000,                            // 44.1 kHz sample rate
    .bits_per_sample = I2S_BITS_PER_SAMPLE_16BIT,    // 16-bit audio
    .channel_format = I2S_CHANNEL_FMT_ONLY_LEFT,     // Mono channel format
    .communication_format = I2S_COMM_FORMAT_I2S,     // I2S communication
    .intr_alloc_flags = ESP_INTR_FLAG_LEVEL1,        // Interrupt level 1
    .dma_buf_count = 8,                              // Number of DMA buffers
    .dma_buf_len = bufferLen,                        // Buffer length
    .use_apll = false                                // Disable APLL
  };
 
  // Install the I2S driver
  i2s_driver_install(I2S_PORT, &i2s_config, 0, NULL);
}
 
void i2s_setpin() {
  // Set I2S pin configuration
  const i2s_pin_config_t pin_config = {
    .bck_io_num = I2S_SCK,     // Bit Clock
    .ws_io_num = I2S_WS,       // Word Select (L/R clock)
    .data_out_num = -1,        // Not using output
    .data_in_num = I2S_SD      // Serial Data In
  };
 
  // Apply the pin configuration to the I2S driver
  i2s_set_pin(I2S_PORT, &pin_config);
}

void setup() 
{
 Serial.begin(115200);  Tekstprintln("Serial started");                                       // Setup the serial port to 115200 baud //  
 InitStorage();         Tekstprintln("Setting loaded");                                       // Load settings from storage and check validity 
 StartBLEService();     Tekstprintln("BLE started");                                           // Start BLE service                                                                                             // Print the tekst time in the display 
 SWversion();
 Serial.println("Starting I2S microphone...");
 
  // Initialize I2S and start it
 i2s_install();
 i2s_setpin();
 i2s_start(I2S_PORT);
 
 delay(500);
}
//                                                                                            //
//--------------------------------------------
// ARDUINO Loop
//--------------------------------------------
void loop() 
{
  // Buffer to hold the audio samples
  size_t bytesIn = 0;
  // Read I2S data and store it in the buffer
  
  
  
    if (deviceConnected) {
      esp_err_t result = i2s_read(I2S_PORT, &sBuffer, sizeof(sBuffer), &bytesIn, portMAX_DELAY);
  // Process if data was read successfully
  if (result == ESP_OK && bytesIn > 0) {
    int16_t samples_read = bytesIn / sizeof(int16_t);
 
    // Calculate the mean of the samples
    
    for (int i = 0; i < samples_read; ++i) {
      mean += sBuffer[i];
    }
    mean /= samples_read;
 
    // Print the mean value to the Serial Monitor
//    Serial.println(mean);
  } else {
    // Print error message if read failed
    Serial.println("I2S read failed!");
  }
    // Convert the number to a string and send it as a BLE notification
    String meanstring;
    meanstring = String(mean);
    pTxCharacteristic->setValue(meanstring);
    pTxCharacteristic->notify();  // Send notification to the client
    Serial.print("Sent: ");
    Serial.println(mean);

 EverySecondCheck();  
 CheckDevices();
}}
//--------------------------------------------
// Common Check connected input devices
//--------------------------------------------
void CheckDevices(void)
{
 CheckBLE();                                                                                  // Something with BLE to do?
 SerialCheck();                                                                               // Check serial port every second 
}
//                                                                                            //
//--------------------------------------------
// CLOCK Update routine to run something every second
//--------------------------------------------
void EverySecondCheck(void)
{
 uint32_t msLeap = millis() - msTick;
 if (msLeap >999)                                                                             // Every second enter the loop
  { 
//   Serial.println(millis());
   msTick = millis();
  }  
 }

//--------------------------------------------
// Common check for serial input
//--------------------------------------------
void SerialCheck(void)
{
 String SerialString; 
 while (Serial.available())
    { 
     char c = Serial.read();                                                               // Serial.write(c);
     if (c>31 && c<128) SerialString += c;                                                    // Allow input from Space - Del
     else c = 0;                                                                              // Delete a CR
    }
 if (SerialString.length()>0) 
    {
     ReworkInputString(SerialString+"\n");                                                    // Rework ReworkInputString();
     SerialString = "";
    }
}

//--------------------------------------------
// Common common print routines
//--------------------------------------------
void Tekstprint(char const *tekst)    { if(Serial) Serial.print(tekst);  SendMessageBLE(tekst);sptext[0]=0;   } 
void Tekstprintln(char const *tekst)  { sprintf(sptext,"%s\n",tekst); Tekstprint(sptext);  }
void TekstSprint(char const *tekst)   { printf(tekst); sptext[0]=0;}                          // printing for Debugging purposes in serial monitor 
void TekstSprintln(char const *tekst) { sprintf(sptext,"%s\n",tekst); TekstSprint(sptext); }

//--------------------------------------------
//  CLOCK Input from Bluetooth or Serial
//--------------------------------------------
void ReworkInputString(String InputString)
{
 char ff[50];  InputString.toCharArray(ff,InputString.length());                              // Convert a String to char array
 sprintf(sptext,"Inputstring: %s  Lengte : %d\n", ff,InputString.length()-1); 
 // Tekstprint(sptext);
 if(InputString.length()> 40){Serial.printf("Input string too long (max40)\n"); return;}                                                         // If garbage return
 sptext[0] = 0;                                                                               // Empty the sptext string
 if(InputString[0] > 31 && InputString[0] <127)                                               // Does the string start with a letter?
  { 
  switch (InputString[0])
   {
    case 'A':
    case 'a': 
            if (InputString.length() >5 )
            {
             InputString.substring(1).toCharArray(Mem.Ssid,InputString.length()-1);
             sprintf(sptext,"SSID set: %s", Mem.Ssid);  
            }
            else sprintf(sptext,"**** Length fault. Use between 4 and 30 characters ****");
            break;
    case 'B':
    case 'b': 
           if (InputString.length() >5 )
            {  
             InputString.substring(1).toCharArray(Mem.Password,InputString.length()-1);
             sprintf(sptext,"Password set: %s\n Enter @ to reset ESP32 and connect to WIFI and NTP", Mem.Password); 
            }
            else sprintf(sptext,"%s,**** Length fault. Use between 4 and 40 characters ****",Mem.Password);
            break;   
    case 'C':
    case 'c': 
           if (InputString.length() >5 )
            {  
             InputString.substring(1).toCharArray(Mem.BLEbroadcastName,InputString.length()-1);
             sprintf(sptext,"BLE broadcast name set: %s", Mem.BLEbroadcastName); 
            }
            else sprintf(sptext,"**** Length fault. Use between 4 and 30 characters ****");
            break;
    case 'I':
    case 'i': 
            SWversion();
            break;
    case 'R':
    case 'r':
             if (InputString.length() == 2)
               {   
                Reset();
                sprintf(sptext,"\nReset to default values: Done");
               }                                
             else sprintf(sptext,"**** Length fault. Enter R ****");
             break;      
 
    default: break;
    }
  }  
 Tekstprintln(sptext);    
 StoreStructInFlashMemory();                         
 InputString = "";
}

//--------------------------------------------
// Print Menu and Version info
//--------------------------------------------
void SWversion(void) 
{ 
 #define FILENAAM (strrchr(__FILE__, '\\') ? strrchr(__FILE__, '\\') + 1 : __FILE__)
 PrintLine(35);
 for (uint8_t i = 0; i < sizeof(menu) / sizeof(menu[0]); Tekstprintln(menu[i++]));
 sprintf(sptext,"SSID: %s", Mem.Ssid);                                           Tekstprintln(sptext);
// sprintf(sptext,"Password: %s", Mem.Password);                                       Tekstprintln(sptext);
 sprintf(sptext,"BLE name: %s", Mem.BLEbroadcastName);                               Tekstprintln(sptext);
 sprintf(sptext,"%s",Mem.UseBLELongString? "FastBLE=On":"FastBLE=Off" );           Tekstprintln(sptext);
 sprintf(sptext,"Software: %s",FILENAAM);                                                    Tekstprintln(sptext);  //VERSION); 
 PrintLine(35);
}
void PrintLine(byte Lengte)
{
 for(int n=0; n<Lengte; n++) sptext[n]='_';
 sptext[Lengte] = 0;
 Tekstprintln(sptext);
}
//-----------------------------
// BLE 
// SendMessage by BLE Slow in packets of 20 chars or fast in one long string.
// Fast can be used in IOS app BLESerial Pro
//------------------------------
void SendMessageBLE(std::string Message)
{
 if(deviceConnected) 
   {
    if (Mem.UseBLELongString)                                                                 // If Fast transmission is possible
     {
//      pTxCharacteristic->setValue(Message); 
//      pTxCharacteristic->notify();
//      delay(10);                                                                              // Bluetooth stack will go into congestion, if too many packets are sent
     } 
   else                                                                                      // Packets of max 20 bytes
     {   
      int parts = (Message.length()/20) + 1;
      for(int n=0;n<parts;n++)
        {   
//         pTxCharacteristic->setValue(Message.substr(n*20, 20)); 
//         pTxCharacteristic->notify();
//         delay(40);                                                                           // Bluetooth stack will go into congestion, if too many packets are sent
        }
     }
   } 
}

//-----------------------------
// BLE Start BLE Classes
//------------------------------
class MyServerCallbacks: public BLEServerCallbacks 
{
 void onConnect(BLEServer* pServer) {deviceConnected = true; };
 void onDisconnect(BLEServer* pServer) {deviceConnected = false;}
};

class MyCallbacks: public BLECharacteristicCallbacks 
{
 void onWrite(BLECharacteristic *pCharacteristic) 
  {
   std::string rxValue = pCharacteristic->getValue();
   ReceivedMessageBLE = rxValue + "\n";
//   if (rxValue.length() > 0) {for (int i = 0; i < rxValue.length(); i++) printf("%c",rxValue[i]); }
//   printf("\n");
  }  
};

//-----------------------------
// BLE Start BLE Service
//------------------------------
void StartBLEService(void)
{
 BLEDevice::init(Mem.BLEbroadcastName);                                                          // Create the BLE Device
 pServer = BLEDevice::createServer();                                                         // Create the BLE Server
 pServer->setCallbacks(new MyServerCallbacks());
 BLEService *pService = pServer->createService(SERVICE_UUID);                                 // Create the BLE Service
 pTxCharacteristic                     =                                                      // Create a BLE Characteristic 
     pService->createCharacteristic(CHARACTERISTIC_UUID_TX, NIMBLE_PROPERTY::NOTIFY);                 
 BLECharacteristic * pRxCharacteristic = 
     pService->createCharacteristic(CHARACTERISTIC_UUID_RX, NIMBLE_PROPERTY::WRITE);
 pRxCharacteristic->setCallbacks(new MyCallbacks());
 pService->start(); 
 BLEAdvertising *pAdvertising = BLEDevice::getAdvertising();
 pAdvertising->addServiceUUID(SERVICE_UUID); 
 pServer->start();                                                                            // Start the server  
 pServer->getAdvertising()->start();                                                          // Start advertising
 TekstSprint("BLE Waiting a client connection to notify ...\n"); 
}
//                                                                                            //
//-----------------------------
// BLE  CheckBLE
//------------------------------
void CheckBLE(void)
{
 if(!deviceConnected && oldDeviceConnected)                                                   // Disconnecting
   {
    delay(300);                                                                               // Give the bluetooth stack the chance to get things ready
    pServer->startAdvertising();                                                              // Restart advertising
    TekstSprint("Start advertising\n");
    oldDeviceConnected = deviceConnected;
   }
 if(deviceConnected && !oldDeviceConnected)                                                   // Connecting
   { 
    oldDeviceConnected = deviceConnected;
    SWversion();
   }
 if(ReceivedMessageBLE.length()>0)
   {
    SendMessageBLE(ReceivedMessageBLE);
    String BLEtext = ReceivedMessageBLE.c_str();
    ReceivedMessageBLE = "";
    ReworkInputString(BLEtext); 
   }
}
//                                                                                            //

//--------------------------------------------
// Common Init and check contents of EEPROM
//--------------------------------------------
void InitStorage(void)
{
 GetStructFromFlashMemory();
 if( Mem.Checksum != 25065)
   {
    sprintf(sptext,"Checksum (25065) invalid: %d\n Resetting to default values",Mem.Checksum); 
    Tekstprintln(sptext); 
    Reset();                                                                                  // If the checksum is NOK the Settings were not set
   }
 StoreStructInFlashMemory();
}
//--------------------------------------------
// COMMON Store mem.struct in FlashStorage or SD
// Preferences.h  
//--------------------------------------------
void StoreStructInFlashMemory(void)
{
 FLASHSTOR.begin("Mem",false);       //  delay(100);
 FLASHSTOR.putBytes("Mem", &Mem , sizeof(Mem) );
 FLASHSTOR.end();          
 }
//--------------------------------------------
// COMMON Get data from FlashStorage
// Preferences.h
//--------------------------------------------
void GetStructFromFlashMemory(void)
{
 FLASHSTOR.begin("Mem", false);
 FLASHSTOR.getBytes("Mem", &Mem, sizeof(Mem) );
 FLASHSTOR.end();         
 sprintf(sptext,"Mem.Checksum = %d",Mem.Checksum);Tekstprintln(sptext); 
}

//------------------------------------------------------------------------------
// Common Reset to default settings
//------------------------------------------------------------------------------
void Reset(void)
{
 Mem.Checksum         = 25065;                                                                 //
 Mem.UseBLELongString = 0;
 strcpy(Mem.Ssid,"MySSID");                                                                         // Default SSID
 strcpy(Mem.Password,"MyPass");                                                                     // Default password
 strcpy(Mem.BLEbroadcastName,"StethoscopeESP");
 Tekstprintln("**** Reset of preferences ****"); 
 StoreStructInFlashMemory();                                                                  // Update Mem struct       
 SWversion();                                                                                 // Display the version number of the software
}
