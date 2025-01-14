//
//  BluetoothManager.swift
//  HeartLink
//
//  Created by Ben Sun on 2024-10-31.
//

import CoreBluetooth

let wifiConnectionServiceUUID: CBUUID = CBUUID(string: "5c96e1a0-4022-4310-816f-bcb7245bc802")
let wifiConnectionCharacteristicUUID: CBUUID = CBUUID(string: "a48ce354-6a1b-429d-aca5-1077627d5a25")
let recordingServiceUUID: CBUUID = CBUUID(string: "60ec2f71-22f2-4fc4-84f0-f8d3269e10c0")
let recordingCharacteristicUUID: CBUUID = CBUUID(string: "d5435c8c-392f-4e89-87be-89f9964db0e0")

class BluetoothManager: NSObject, CBCentralManagerDelegate, ObservableObject {
    @Published var isBluetoothEnabled = false
    @Published var discoveredPeripherals = [Peripheral]()
    @Published var mcuPeripheralUUID: UUID?
    @Published var isConnected = false
    @Published var wifiNetworks = [String]()
    
    var centralManager: CBCentralManager!
    var mcuPeripheral: CBPeripheral?
    var wifiCredsCharacteristic: CBCharacteristic?
    var recordingCharacteristic: CBCharacteristic?

    override init() {
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }
    

    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        self.isBluetoothEnabled = central.state == .poweredOn
        if !self.isBluetoothEnabled {
            print("Bluetooth not enabled")
            self.discoveredPeripherals.removeAll()
        } else {
            print("Bluetooth: Start Scanning...")
            self.startScanning()
        }
    }
    
    func startScanning() {
        guard centralManager.state == .poweredOn else { return }
        centralManager.scanForPeripherals(withServices: [wifiConnectionServiceUUID, recordingServiceUUID], options: [CBCentralManagerScanOptionAllowDuplicatesKey: false])
    }
    
    func stopScanning() {
        centralManager.stopScan()
    }
    
    func connect(to peripheral: Peripheral) {
        guard let cbPeripheral = centralManager.retrievePeripherals(withIdentifiers: [peripheral.id]).first else {
            print("Peripheral not found for connection")
            return
        }
        
        self.mcuPeripheralUUID = peripheral.id
        self.mcuPeripheral = cbPeripheral
        cbPeripheral.delegate = self
        centralManager.connect(cbPeripheral, options: nil)
    }
    
    func disconnect(peripheral: Peripheral) {
        guard let cbPeripheral = centralManager.retrievePeripherals(withIdentifiers: [peripheral.id]).first else {
            print("Peripheral not found for disconnection")
            return
        }
        
        centralManager.cancelPeripheralConnection(cbPeripheral)

    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        self.isConnected = true
        self.stopScanning()
        
        peripheral.delegate = self
        peripheral.discoverServices([wifiConnectionServiceUUID, recordingServiceUUID])
        
    }
    
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        print("Failed to connect to \(peripheral.name ?? "Unknown"): \(error?.localizedDescription ?? "Unknown Error")")
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        if let error = error {
            print("Error in disconnecting \(peripheral.name ?? "Unknown"): \(error.localizedDescription)")
        } else {
            print("Successfully disconnected from \(peripheral.name ?? "Unknown")")
        }
        self.isConnected = false
        self.mcuPeripheralUUID = nil
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        let newPeripheral = Peripheral(id: peripheral.identifier, name: peripheral.name ?? "Unknown", rssi: RSSI.intValue)
        if !self.discoveredPeripherals.contains(where: { $0.id == newPeripheral.id}) {
            self.discoveredPeripherals.append(newPeripheral)
        }
    }
}

extension BluetoothManager: CBPeripheralDelegate {
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        for service in peripheral.services ?? [] {
            if service.uuid == wifiConnectionServiceUUID {
                print("found service for \(wifiConnectionServiceUUID)")
                peripheral.discoverCharacteristics(nil, for: service)
            } else if service.uuid == recordingServiceUUID {
                print("found service for \(recordingServiceUUID)")
                peripheral.discoverCharacteristics(nil, for: service)
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        for characteristic in service.characteristics ?? [] {
            if characteristic.uuid == wifiConnectionCharacteristicUUID {
                print("Found wifi creds characteristic")
                wifiCredsCharacteristic = characteristic
                peripheral.setNotifyValue(true, for: characteristic)
            } else if characteristic.uuid == recordingCharacteristicUUID {
                print("Found recording characteristic")
                recordingCharacteristic = characteristic
                peripheral.setNotifyValue(true, for: characteristic)
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: Error?) {
        if let error {
            print("error writing to peripheral: \(error)")
        } else {
            print("write successful")
        }
    }
    
//    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
//        if characteristic.uuid == wifiConnectionCharacteristicUUID {
//            guard let data = characteristic.value else {
//                print("No data received for \(characteristic.uuid.uuidString)")
//                return
//            }
//            
 
//        }
//    }
}
