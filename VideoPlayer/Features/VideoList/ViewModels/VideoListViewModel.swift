//
//  VideoListViewModel.swift
//  VideoPlayer
//
//  Created by 徐柏勳 on 7/11/25.
//

import Foundation
import Combine

@MainActor
class VideoListViewModel: ObservableObject {
    @Published var videos: [Video] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let mockDataProvider = MockDataProvider.shared
    
    init() {
        loadVideos()
    }
    
    func loadVideos() {
        isLoading = true
        errorMessage = nil
        
        Task {
            try await Task.sleep(nanoseconds: 500_000_000)
            await MainActor.run {
                self.videos = self.mockDataProvider.sampleVideos
                self.isLoading = false
            }
        }
    }
    
    func retry() {
        loadVideos()
    }
}
