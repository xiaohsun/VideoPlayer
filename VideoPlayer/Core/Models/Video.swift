//
//  Video.swift
//  VideoPlayer
//
//  Created by 徐柏勳 on 7/11/25.
//

import Foundation

enum Difficulty: String, CaseIterable, Codable {
    case beginner = "Beginner"
    case intermediate = "Intermediate"
    case advanced = "Advanced"
}

struct Video: Identifiable, Codable {
    let id: String
    let title: String
    let description: String
    let thumbnailURL: URL
    let videoURL: URL
    let duration: TimeInterval
    let difficulty: Difficulty
}