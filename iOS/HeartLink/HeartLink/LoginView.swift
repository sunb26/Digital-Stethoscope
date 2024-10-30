//
//  ContentView.swift
//  HeartLink
//
//  Created by Ben Sun on 2024-10-14.
//

import SwiftUI

struct LoginView: View {
    @State private var userId: String = ""
    @State private var password: String = ""
    @State private var isLoggedIn: Bool = false

    var body: some View {
        NavigationStack {
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
                            print("Hello!")
                        }
                    }) {
                        Text("Login")
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.black)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                            .shadow(color: .gray, radius: 5, x: 0, y: 2)
                    }
                    .padding(.top, 90)
                    
                    NavigationLink(destination: ResetPasswordView()) {
                        Text("Forgot Password?")
                            .foregroundColor(.gray)
                    }
                    .padding(.top, 10)
                }
                .padding(.horizontal, 15)
            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}

struct ResetPasswordView: View {
    var body: some View {
        Text("Reset your password here")
    }
}

#Preview {
    LoginView()
}
