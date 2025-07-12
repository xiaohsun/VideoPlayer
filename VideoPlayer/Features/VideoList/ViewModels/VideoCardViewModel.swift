//
//  VideoCardViewModel.swift
//  VideoPlayer
//
//  Created by 徐柏勳 on 7/11/25.
//

import Foundation

@MainActor
class VideoCardViewModel: ObservableObject {
    @Published var isFavorite: Bool = false
    
    private let video: Video
    
    var onFavoriteAdded: (() -> Void)?
    
    init(video: Video) {
        self.video = video
        loadFavoriteStatus()
    }
    
    private func loadFavoriteStatus() {
        let favorites = UserDefaults.standard.stringArray(forKey: UserDefaultsKeys.favoriteVideos) ?? []
        isFavorite = favorites.contains(video.id)
    }
    
    func toggleFavorite() {
        var favorites = Set(UserDefaults.standard.stringArray(forKey: UserDefaultsKeys.favoriteVideos) ?? [])
        
        if isFavorite {
            favorites.remove(video.id)
        } else {
            favorites.insert(video.id)
            onFavoriteAdded?()
        }
        
        UserDefaults.standard.set(Array(favorites), forKey: UserDefaultsKeys.favoriteVideos)
        isFavorite.toggle()
    }
}
