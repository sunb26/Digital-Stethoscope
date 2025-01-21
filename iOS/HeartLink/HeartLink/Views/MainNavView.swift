//
//  MainNavView.swift
//  HeartLink
//
//  Created by Ben Sun on 2024-10-29.
//

import SwiftUI

struct MainNavView: View {
    @State var path: [PageActions] = [.login]
    @StateObject var btmanager = BluetoothManager()
    @State var patient: User = User(email: "", patientId: 0, physicianId: 0, widgets: [])

    var body: some View {
        NavigationStack(path: $path) {
            TabView {
                Tab("Home", systemImage: "house.fill") {
                    HomeView(path: $path, patient: $patient, bluetoothManager: btmanager)
                }
                Tab("Record", systemImage: "record.circle.fill") {
                    RecordingView(bluetoothManager: btmanager)
                }
            }
            .tabViewStyle(.sidebarAdaptable)
            .tint(.pink)
            .edgesIgnoringSafeArea(.all)
            .navigationDestination(for: PageActions.self) { action in
                switch action {
                case .login:
                    LoginView(path: $path, patient: $patient)
                        .navigationBarBackButtonHidden(true)
                }
            }
        }
    }
}

#Preview {
    MainNavView()
}
