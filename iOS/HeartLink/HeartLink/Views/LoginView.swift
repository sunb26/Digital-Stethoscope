//
//  ContentView.swift
//  HeartLink
//
//  Created by Ben Sun on 2024-10-14.
//

import SwiftUI

struct LoginView: View {
    @Binding var path: [PageActions]
    @State private var userId: String = ""
    @State private var password: String = ""
    
    var body: some View {
        ZStack {
            Color.white
                .ignoresSafeArea() // Ensure full white background
                     
            VStack {
                HStack {
                    Image(systemName: "stethoscope")
                        .font(.system(size: 40))
                        .foregroundColor(.black)
                    
                    Text("HeartLink")
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(.black)
                }
                .padding(.bottom, 50)
                
                VStack {
                    TextField("Username", text: $userId)
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
                        if userId.isEmpty || password.isEmpty {
                            print("Please enter a username and password")
                        } else {
                            path.removeLast(path.count)
                        }
                    }) {
                        Text("Login")
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                            .shadow(color: .gray, radius: 5, x: 0, y: 2)
                    }
                    .padding(.top, 90)
                }
                .padding(.horizontal, 15)
            }
            .padding()
            .ignoresSafeArea(edges: .all)
        }
    }
}

struct ResetPasswordView: View {
    var body: some View {
        Text("Reset your password here")
    }
}

#Preview {
    @Previewable
    @State var path: [PageActions] = [.login]
    LoginView(path: $path)
}
