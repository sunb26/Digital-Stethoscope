#include "InitializeSD.h"

bool hasSD = false;

SPIClass spi = SPIClass(SPI);

void initializeSD(){
    spi.begin(SCK, MISO, MOSI, CS);
    if (SD.begin(CS, spi, 80000000)) {
        DBG_OUTPUT_PORT.println("SD Card initialized.");
        hasSD = true;
    }
    else{
      DBG_OUTPUT_PORT.println("Failed to initialize SD Card.");
    }
}
