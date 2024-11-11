//
//  BluetoothManager.swift
//  HeartLink
//
//  Created by Ben Sun on 2024-10-31.
//

import CoreBluetooth

class BluetoothManager: NSObject, CBCentralManagerDelegate, ObservableObject, CBPeripheralDelegate {
    @Published var isBluetoothEnabled = false
    @Published var discoveredPeripherals = [Peripheral]()
    @Published var connectedPeripheralUUID: UUID?
    @Published var isConnected = false
    
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
}
