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
    
    var body: some View {
        NavigationStack (path: $path) {
            TabView {
                // Pass the path binding to HomeView
                Tab("Home", systemImage: "house.fill") {
                    HomeView(path: $path, bluetoothManager: btmanager)
                }
                Tab("Record", systemImage: "record.circle.fill") {
                    RecordingView()
                }
            }
            .tabViewStyle(.sidebarAdaptable)
            .tint(.pink)
            .edgesIgnoringSafeArea(.all)
            .navigationDestination(for: PageActions.self) { action in
                switch action {
                case .login:
                    LoginView(path: $path)
                        .navigationBarBackButtonHidden(true)
                }
            }
        }
    }
}

#Preview {
    MainNavView()
}
