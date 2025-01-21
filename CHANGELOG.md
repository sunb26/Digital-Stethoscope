# CHANGELOG

## 1.5.0 (2025-01-21)
- add individual recording data view
- TODO (Ben Sun): add audio streaming to this view

## 1.4.0 (2025-01-20)
- remove hardcoded recording history
- replaced with pulling data from endpoint

## 1.3.0 (2025-01-18)
- set up wifi credentials login uses phone app now
- start/stop function uses phone app now
- app login page pulls from an endpoint (still no validation yet)
- recording page auto stops after 15 seconds
- TODO (bentomka): MCU issue with repeat recordings

## v1.2.0 (2025-01-14)
- setup atlasgo for SQL db schema management

## v1.1.0 (2025-01-14)
- add function to send Wifi Credentials to MCU via BLE
- add function to trigger start/stop recording via BLE to MCU

## v1.0.0 (2024-12-02)
- remove BLE audio streaming from MCU
- add file upload to server (localhost) to MCU
- add SD card integration to MCU

## v0.5.0 (2024-11-19)
- added audio sign .wav constructor feature

## v0.4.1 (2024-11-18)
- updated recording page to add countdown feature 

## v0.4.0 (2024-11-10)
- added bluetooth connection and view

## v0.3.0 (2024-10-31)
- added homepage
- added recording page
- refactored login page
- add MainNavView to handle navigation between existing pages
  
## v0.2.0 (2024-10-14)
- added login view (no functionality yet)

## v0.1.0 (2024-10-14)
- Initial iOS setup
