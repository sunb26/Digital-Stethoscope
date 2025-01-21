//
//  UserLogin.swift
//  HeartLink
//
//  Created by Ben Sun on 2025-01-15.
//

import Foundation

func getUser() async throws -> User {
    guard let url = URL(string: "https://heartlink.free.beeceptor.com/test") else {
        throw LoginError.invalidURL
    }

    let (data, response) = try await URLSession.shared.data(from: url)

    guard let response = response as? HTTPURLResponse else {
        throw LoginError.serverError
    }

    guard response.statusCode == 200 else {
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
