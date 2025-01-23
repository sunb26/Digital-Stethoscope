//
//  SendWifiCreds.swift
//  HeartLink
//
//  Created by Ben Sun on 2025-01-11.
//

import SwiftUI

struct SendWifiCreds: View {
    @State private var network: String = ""
    @State private var password: String = ""
    @ObservedObject var bluetoothManager: BluetoothManager

    var body: some View {
        VStack {
            TextField("Network Name", text: $network)
                .padding(20)
                .background(Color.white)
                .cornerRadius(10)
                .shadow(color: .gray, radius: 5, x: 0, y: 2)

            SecureField("Password", text: $password)
                .padding(20)
                .background(Color.white)
                .cornerRadius(10)
                .shadow(color: .gray, radius: 5, x: 0, y: 2)
                .padding(.top, 12)

            Button(action: {
                sendWifiCreds(network: network, password: password)
            }) {
                Text("Connect")
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.pink)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                    .shadow(color: .gray, radius: 5, x: 0, y: 2)
            }
            .padding(.top, 90)
        }.padding(20)
    }

    func sendWifiCreds(network: String, password: String) {
        let nameLength = String(network.count)
        let data = (nameLength + "&" + network + password).data(using: .utf8)!
        guard let char = bluetoothManager.wifiCredsCharacteristic else {
            print("Could not find wifiCredsCharacteristic characteristic")
            return
        }
        bluetoothManager.mcuPeripheral?.writeValue(data, for: char, type: .withResponse)
    }
}

#Preview {
    @Previewable @StateObject var btmanager = BluetoothManager()
    SendWifiCreds(bluetoothManager: btmanager)
}
