//
//  Peripheral.swift
//  HeartLink
//
//  Created by Ben Sun on 2024-11-10.
//

import Foundation

struct Peripheral: Identifiable {
    let id: UUID
    let name: String
    let rssi: Int // Bluetooth connection signal strength
}
