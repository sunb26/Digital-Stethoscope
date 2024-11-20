//
//  BluetoothManager.swift
//  HeartLink
//
//  Created by Ben Sun on 2024-10-31.
//  Edited by Matt Wilker on 2024-11-19
//

import CoreBluetooth

class BluetoothManager: NSObject, CBCentralManagerDelegate, ObservableObject, CBPeripheralDelegate {
    @Published var isBluetoothEnabled = false
    @Published var discoveredPeripherals = [Peripheral]()
    @Published var connectedPeripheralUUID: UUID?
    @Published var isConnected = false
    var characteristicData: [CBCharacteristic] = [] // make sure correct data type
    var value1 = 0 // change value here if needed
    let CHARACTERISTIC_1 = CBUUID(string: "2B18") // change values here
    
    private var centralManager: CBCentralManager!
    private var connectedPeripheral: CBPeripheral?

    override init() {
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }
    

    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        self.isBluetoothEnabled = central.state == .poweredOn
        if !self.isBluetoothEnabled {
            self.discoveredPeripherals.removeAll()
        } else {
            self.startScanning()
        }
    }
    
    func startScanning() {
        guard centralManager.state == .poweredOn else { return }
        centralManager.scanForPeripherals(withServices: nil, options: [CBCentralManagerScanOptionAllowDuplicatesKey: false])
    }
    
    func stopScanning() {
        centralManager.stopScan()
    }
    
    func connect(to peripheral: Peripheral) {
        guard let cbPeripheral = centralManager.retrievePeripherals(withIdentifiers: [peripheral.id]).first else {
            print("Peripheral not found for connection")
            return
        }
        
        self.connectedPeripheralUUID = peripheral.id
        self.connectedPeripheral = cbPeripheral
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
        self.connectedPeripheralUUID = nil
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        let newPeripheral = Peripheral(id: peripheral.identifier, name: peripheral.name ?? "Unknown", rssi: RSSI.intValue)
        if !self.discoveredPeripherals.contains(where: { $0.id == newPeripheral.id}) {
            self.discoveredPeripherals.append(newPeripheral)
        }
    }
    
    // reading from a characteristic (i.e., the ESP32)
    func readValue(characteristic: CBCharacteristic) {
        // not sure where this value goes once have read it - maybe assign to var?
        self.connectedPeripheral?.readValue(for: characteristic)
    }

    // from HW team:
    // sent one data point at a time (sent as 16-bit integer) so will be 2 byte packages
    //
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        if let services = peripheral.services {
            for service in services {
                peripheral.discoverCharacteristics(nil, for: service)
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        for charac in service.characteristics! {
            characteristicData.append(charac)
            if charac.uuid == CHARACTERISTIC_1 {
                peripheral.setNotifyValue(true, for: charac)
                peripheral.readValue(for: charac)
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        guard let data = characteristic.value else {
            return
        }
        
        if characteristic.uuid == CHARACTERISTIC_1 {
            value1 = Int(data[0]) // This is based on the data we expect/are receiving
        }
    }
}

