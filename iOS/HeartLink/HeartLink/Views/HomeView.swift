//
//  HomeView.swift
//  HeartLink
//
//  Created by Ben Sun on 2024-10-29.
//

import SwiftUI

// Page actions for navigation
enum PageActions: Hashable {
    case login
}

struct HomeView: View {
    @Binding var path: [PageActions]
    @Binding var patient: User
    @State var btPopUp: Bool = false
    @State var recordingPopUp: Bool = false
    @ObservedObject var bluetoothManager: BluetoothManager

    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea(.all)
            VStack {
                HStack {
                    Button(action: {
                        // Navigate to profile sidebar
                    }) {
                        Image(systemName: "person.circle")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30, height: 30)
                            .foregroundColor(.black)
                    }
                    .frame(maxWidth: 300, alignment: .leading)

                    Button(action: {
                        self.btPopUp = true
                    }) {
                        Image("bluetooth")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30, height: 30)
                            .foregroundColor(.black)
                    }
                }
                .frame(height: 80)

                Text("Home")
                    .font(.system(size: 34, weight: .bold))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                    .padding(.top, -4)

                VStack(alignment: .leading) {
                    Text("Recordings")
                        .font(.title)
                        .fontWeight(.bold)
                        .padding(.horizontal)

                    List(patient.widgets) { recording in
                        HStack(spacing: 16) {
                            Image(systemName: "waveform")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 40, height: 40)
                                .foregroundColor(.pink)

                            VStack(alignment: .leading) {
                                Text(recording.date)
                                    .font(.headline)
                                    .scaledToFit()
                            }
                            Spacer()
                            Button(action: {
                                // Add playback function here
                            }) {
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.black)
                            }
                            .frame(width: 34)
                        }
                    }
                    .listStyle(PlainListStyle())
                }
            }
        }
        .sheet(isPresented: $btPopUp) {
            BluetoothView(bluetoothManager: bluetoothManager)
        }
        .sheet(isPresented: $recordingPopUp) {
        }
        .preferredColorScheme(.light)
    }
}

#Preview {
    MainNavView().environment(\.colorScheme, .light)
}
