//
//  MainTabView.swift
//  HeartLink
//
//  Created by Ben Sun on 2024-10-29.
//

import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            Tab("Home", systemImage: "house.fill"){
                    HomeView()
                }
            Tab("Record", systemImage: "record.circle.fill") {
                    RecordingView()
                }
            }
        .tabViewStyle(.sidebarAdaptable)
        .tint(.pink)
        .edgesIgnoringSafeArea(.all)
    }
}

#Preview {
    MainTabView()
}
