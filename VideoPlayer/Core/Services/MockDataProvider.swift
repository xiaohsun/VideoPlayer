//
//  MockDataProvider.swift
//  VideoPlayer
//
//  Created by 徐柏勳 on 7/11/25.
//

import Foundation

class MockDataProvider {
    static let shared = MockDataProvider()
    
    private init() {}
    
    private func createURL(_ string: String) -> URL {
        guard let url = URL(string: string) else {
            fatalError("Invalid URL string: \(string)")
        }
        return url
    }
    
    lazy var sampleVideos: [Video] = [
        Video(
            id: "1",
            title: "For Bigger Meltdowns",
            description: "Short action-packed demo video",
            thumbnailURL: createURL("https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/images/ForBiggerMeltdowns.jpg"),
            videoURL: createURL("https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerMeltdowns.mp4"),
            duration: 15.0,
            difficulty: .beginner
        ),
        
        Video(
            id: "2",
            title: "For Bigger Joyrides",
            description: "Exciting short adventure demo",
            thumbnailURL: createURL("https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/images/ForBiggerJoyrides.jpg"),
            videoURL: createURL("https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerJoyrides.mp4"),
            duration: 15.0,
            difficulty: .intermediate
        ),
        
        Video(
            id: "3",
            title: "For Bigger Blazes",
            description: "Short demo video showcasing visual effects",
            thumbnailURL: createURL("https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/images/ForBiggerBlazes.jpg"),
            videoURL: createURL("https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4"),
            duration: 15.0,
            difficulty: .beginner
        ),
        
        Video(
            id: "4",
            title: "For Bigger Escape",
            description: "Adventure themed short demo video",
            thumbnailURL: createURL("https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/images/ForBiggerEscapes.jpg"),
            videoURL: createURL("https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerEscapes.mp4"),
            duration: 15.0,
            difficulty: .intermediate
        ),
        
        Video(
            id: "5",
            title: "We Are Going On Bullrun",
            description: "Quick cryptocurrency themed video",
            thumbnailURL: createURL("https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/images/WeAreGoingOnBullrun.jpg"),
            videoURL: createURL("https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/WeAreGoingOnBullrun.mp4"),
            duration: 47.0,
            difficulty: .advanced
        ),
        
        Video(
            id: "6",
            title: "What Car Can You Get For A Grand?",
            description: "Short automotive review demo",
            thumbnailURL: createURL("https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/images/WhatCarCanYouGetForAGrand.jpg"),
            videoURL: createURL("https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/WhatCarCanYouGetForAGrand.mp4"),
            duration: 567.0,
            difficulty: .advanced
        )
    ]
}
