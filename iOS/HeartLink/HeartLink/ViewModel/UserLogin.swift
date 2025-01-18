//
//  UserLogin.swift
//  HeartLink
//
//  Created by Ben Sun on 2025-01-15.
//

import Foundation

let endpoint = "https://heartlink.free.beeceptor.com/test"

func getUser() async throws -> User {
    
    guard let url = URL(string: endpoint) else {
        throw LoginError.invalidURL
    }
    
    let (data, response) = try await URLSession.shared.data(from: url)
    
    guard let response = response as? HTTPURLResponse else {
        throw LoginError.serverError
    }
    
    guard response.statusCode == 200  else {
        if response.statusCode == 404 {
            throw LoginError.invalidCredentials
        } else {
            throw LoginError.invalidResponse
        }
    }
    
    do {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return try decoder.decode(User.self, from: data)
    } catch {
        throw LoginError.invalidData
    }
}


struct User: Codable {
    let email: String
    let patientId: UInt64
    let physicianId: UInt64
}

enum LoginError: Error {
    case invalidURL
    case invalidCredentials
    case invalidResponse
    case invalidData
    case serverError
}
