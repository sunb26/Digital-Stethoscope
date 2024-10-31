//
//  MainNavView.swift
//  HeartLink
//
//  Created by Ben Sun on 2024-10-29.
//

import SwiftUI


struct MainNavView: View {
    @State var path: [PageActions] = [.login]
//    @Binding var path: [PageActions]
    
    var body: some View {
        NavigationStack (path: $path) {
            TabView {
                // Pass the path binding to HomeView
                Tab("Home", systemImage: "house.fill") {
                    HomeView(path: $path)
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
                case .bt:
                    BluetoothView()
                }
            }
        }
    }
}

#Preview {
    MainNavView()
}
