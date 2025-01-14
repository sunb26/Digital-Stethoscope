//
//  RecordingView.swift
//  HeartLink
//
//  Created by Ben Sun on 2024-10-29.
//  Edited by Matt Wilker on 2024-11-16

import SwiftUI

struct RecordingView: View {
    @State var startRecording: Bool = false
    @State var isRecording: Bool = false
    @State var countdown: Int8 = 0
    @ObservedObject var bluetoothManager: BluetoothManager
    @State var timer = Timer.publish(every: 1.0, on: .main, in: .common).autoconnect()
    
    func toggleRecording() {
        let data = (startRecording ? "start" : "stop").data(using: .utf8)!
        guard let char = bluetoothManager.recordingCharacteristic else {
            print("Could not find recording characteristic")
            return
        }
        bluetoothManager.mcuPeripheral?.writeValue(data, for: char, type: .withResponse)
    }

    var body: some View {
        if bluetoothManager.isConnected {
            ZStack{
                VStack{
                    Text(startRecording ? "Recording..." : "Ready to Record")    .font(.system(size: 42, weight: .bold))
                        .frame(maxWidth: .infinity, alignment: .center)
                        .frame(height: 100)
                    
                    Text(countdown <= 0 ? " " : "Starts in: \(countdown)")
                        .font(.system(size: 34, weight: .bold))
                        .frame(maxWidth: .infinity, alignment: .center)
                        .frame(height: 400, alignment: .top)
                    
                    Button(action: {
                        if startRecording {
                            startRecording = false
                            countdown = -1
                            toggleRecording()
                        } else {
                            startRecording = true
                            countdown = 3
                        }
                    })
                    {
                        if !startRecording { // ready to record page
                            Image(systemName: "record.circle.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 80, height: 80)
                                .foregroundColor(.red)
                        } else { // recording page
                            Image(systemName: "stop.circle")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 80, height: 80)
                                .foregroundColor(.red)
                        }
                    }
                }
                .onReceive(timer) { time in // decrement timer every second
                    guard startRecording else { return }
                    
                    if countdown > 0 {
                        countdown -= 1
                        if countdown == 0 {
                            toggleRecording()
                        }
                    }
                }
            }
        } else {
            Text("Please connect to the Bluetooth Device before recording (found in the main menu)")
                .font(.title3)
                .padding(10)
                .multilineTextAlignment(.center)
        }
    }
}

#Preview {
    @Previewable var bt = BluetoothManager()
    RecordingView(bluetoothManager: bt)
}
