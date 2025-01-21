//
//  DisplayRecording.swift
//  HeartLink
//
//  Created by Ben Sun on 2025-01-20.
//

import Foundation

func getRecording(recordingId: UInt64) async throws -> RecordingData {
    guard let url = URL(string: "https://heartlink.free.beeceptor.com/getRecording") else {
        throw GetRecordingError.invalidURL
    }

    let (data, response) = try await URLSession.shared.data(from: url)

    guard let response = response as? HTTPURLResponse else {
        throw GetRecordingError.serverError
    }

    guard response.statusCode == 200 else {
        if response.statusCode == 404 {
            throw GetRecordingError.recordNotFound
        } else {
            throw GetRecordingError.serverError
        }
    }

    do {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return try decoder.decode(RecordingData.self, from: data)
    } catch {
        throw GetRecordingError.invalidData
    }
}
