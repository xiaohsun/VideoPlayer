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
    
    lazy var sampleVideos: [Video] = [
        Video(
            id: "1",
            title: "Big Buck Bunny",
            description: "A delightful 3D animated short film by the Blender Foundation",
            thumbnailURL: URL(string: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/images/BigBuckBunny.jpg")!,
            videoURL: URL(string: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4")!,
            duration: 596.0,
            difficulty: .beginner
        ),
        
        Video(
            id: "2",
            title: "Elephant Dream",
            description: "World's first open movie made entirely with open source tools",
            thumbnailURL: URL(string: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/images/ElephantsDream.jpg")!,
            videoURL: URL(string: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4")!,
            duration: 653.0,
            difficulty: .intermediate
        ),
        
        Video(
            id: "3",
            title: "For Bigger Blazes",
            description: "Short demo video showcasing visual effects",
            thumbnailURL: URL(string: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/images/ForBiggerBlazes.jpg")!,
            videoURL: URL(string: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4")!,
            duration: 15.0,
            difficulty: .beginner
        ),
        
        Video(
            id: "4",
            title: "For Bigger Escape",
            description: "Adventure themed short demo video",
            thumbnailURL: URL(string: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/images/ForBiggerEscapes.jpg")!,
            videoURL: URL(string: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerEscapes.mp4")!,
            duration: 15.0,
            difficulty: .intermediate
        ),
        
        Video(
            id: "5",
            title: "For Bigger Fun",
            description: "Colorful and energetic demo video",
            thumbnailURL: URL(string: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/images/ForBiggerFun.jpg")!,
            videoURL: URL(string: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerFun.mp4")!,
            duration: 60.0,
            difficulty: .advanced
        ),
        
        Video(
            id: "6",
            title: "Sintel",
            description: "Fantasy adventure short film by Blender Foundation",
            thumbnailURL: URL(string: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/images/Sintel.jpg")!,
            videoURL: URL(string: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/Sintel.mp4")!,
            duration: 888.0,
            difficulty: .advanced
        )
    ]
}
