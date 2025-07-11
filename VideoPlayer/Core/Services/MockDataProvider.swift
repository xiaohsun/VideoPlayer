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
            title: "Basic English Conversation",
            description: "Learn essential English phrases for everyday conversations",
            thumbnailURL: URL(string: "https://via.placeholder.com/300x200/4285F4/FFFFFF?text=Basic+English")!,
            videoURL: URL(string: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4")!,
            duration: 596.0,
            difficulty: .beginner
        ),
        Video(
            id: "2",
            title: "Business English Presentation",
            description: "Professional English skills for workplace presentations",
            thumbnailURL: URL(string: "https://via.placeholder.com/300x200/34A853/FFFFFF?text=Business+English")!,
            videoURL: URL(string: "https://devstreaming-cdn.apple.com/videos/streaming/examples/bipbop_4x3/bipbop_4x3_variant.m3u8")!,
            duration: 1024.0,
            difficulty: .intermediate
        ),
        Video(
            id: "3",
            title: "Advanced Grammar Structures",
            description: "Master complex English grammar patterns",
            thumbnailURL: URL(string: "https://via.placeholder.com/300x200/EA4335/FFFFFF?text=Advanced+Grammar")!,
            videoURL: URL(string: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4")!,
            duration: 653.0,
            difficulty: .advanced
        ),
        Video(
            id: "4",
            title: "Travel English Essentials",
            description: "Essential English phrases for traveling abroad",
            thumbnailURL: URL(string: "https://via.placeholder.com/300x200/FBBC04/FFFFFF?text=Travel+English")!,
            videoURL: URL(string: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4")!,
            duration: 15.0,
            difficulty: .beginner
        ),
        Video(
            id: "5",
            title: "Academic English Writing",
            description: "Improve your academic writing skills in English",
            thumbnailURL: URL(string: "https://via.placeholder.com/300x200/9C27B0/FFFFFF?text=Academic+Writing")!,
            videoURL: URL(string: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerEscapes.mp4")!,
            duration: 15.0,
            difficulty: .intermediate
        ),
        Video(
            id: "6",
            title: "Pronunciation Masterclass",
            description: "Perfect your English pronunciation with expert guidance",
            thumbnailURL: URL(string: "https://via.placeholder.com/300x200/FF5722/FFFFFF?text=Pronunciation")!,
            videoURL: URL(string: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerFun.mp4")!,
            duration: 60.0,
            difficulty: .advanced
        )
    ]
}