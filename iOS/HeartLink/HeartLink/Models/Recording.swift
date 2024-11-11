//
//  Recording.swift
//  HeartLink
//
//  Created by Ben Sun on 2024-11-10.
//

import Foundation


// Define the Data Model
struct Recording: Identifiable {
    let id = UUID()
    let title: String
    let date: String
    let duration: String
}
