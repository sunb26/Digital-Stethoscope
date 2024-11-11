//
//  BluetoothView.swift
//  HeartLink
//
//  Created by Ben Sun on 2024-10-31.
//

import SwiftUI

struct BluetoothView: View {
    @Environment(\.dismiss) var dismiss // For closing the pop-up
    @ObservedObject var bluetoothManager: BluetoothManager
    @State private var bluetoothEnabled: Bool = false

    var body: some View {
        VStack(spacing: 20) {
            Text("Bluetooth Devices")
                .font(.title)
                .fontWeight(.bold)
                .padding()
            
            Text(bluetoothManager.isBluetoothEnabled ? "Select a device to connect" : "Bluetooth is disabled")
                .padding()
                .font(.subheadline)
                .foregroundColor(.gray)
            
            List(bluetoothManager.discoveredPeripherals.filter { $0.name != "Unknown"}) { peripheral in
                HStack {
                    Text(peripheral.name)
                    Spacer()
                    Text(String(peripheral.rssi))
                    Button(action: {
                        if bluetoothManager.isConnected {
                            bluetoothManager.disconnect(peripheral: peripheral)
                        } else {
                            bluetoothManager.connect(to: peripheral)
                        }
                    }) {
                        if bluetoothManager.connectedPeripheralUUID == peripheral.id && bluetoothManager.isConnected {
                            Text("Connected")
                                .foregroundColor(.green)
                        } else if bluetoothManager.connectedPeripheralUUID == peripheral.id && !bluetoothManager.isConnected {
                            Text("Connecting")
                                .foregroundColor(.red)
                        } else {
                            Text ("Connect")
                                .foregroundColor(.blue)
                        }
                    }
                }

            }
                
            Button(action: {
                dismiss()
            }) {
                Text("Close")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(10)
                    .padding(.horizontal)
            }
            .padding()
        }
    }
}
//    
//#Preview {
//    BluetoothView(bluetoothManager: <#T##BluetoothManager#>)
//}
