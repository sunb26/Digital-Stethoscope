//
//  HomeView.swift
//  HeartLink
//
//  Created by Ben Sun on 2024-10-29.
//

import SwiftUI


// Sample Data
let recordings = [
    Recording(title: "Recording 1", date: "Today", duration: "23 min"),
    Recording(title: "Recording 2", date: "Today", duration: "23 min"),
    Recording(title: "Recording 3", date: "Today", duration: "23 min"),
    Recording(title: "Recording 4", date: "Today", duration: "23 min")
]

// Page actions for navigation
enum PageActions: Hashable {
    case login
}

struct HomeView: View {
    @Binding var path: [PageActions]
    @State var btPopUp: Bool = false
    @ObservedObject var bluetoothManager: BluetoothManager
    @State private var navigateToBTOutput: Bool = false // TEMP
    
    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea(.all)
            VStack {
                HStack {
                    Button(action: {
                        // Navigate to profile sidebar
                        navigateToBTOutput = true // TEMPORARY
                    }) {
                        Image(systemName: "person.circle")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30, height: 30)
                            .foregroundColor(.black)
                        
                            .navigationDestination(isPresented: $navigateToBTOutput) { // TEMP
                                BluetoothOutput()
                            }
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
                    
                    List(recordings) { recording in
                        HStack(spacing: 16) {
                            Image(systemName: "waveform")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 40, height: 40)
                                .foregroundColor(.pink)
                            
                            VStack(alignment: .leading) {
                                Text(recording.title)
                                    .font(.headline)
                                HStack {
                                    Image(systemName: "calendar")
                                    Text("\(recording.date) • \(recording.duration)")
                                        .font(.footnote)
                                        .foregroundColor(.secondary)
                                }
                            }
                            Spacer()
                            Button(action: {
                                // Add playback function here
                            }) {
                                Image(systemName: "play.circle")
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
        .preferredColorScheme(.light)
    }
}


#Preview {
    MainNavView().environment(\.colorScheme, .light)
}
