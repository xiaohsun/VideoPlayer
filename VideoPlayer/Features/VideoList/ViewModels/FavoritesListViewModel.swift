//
//  FavoritesListViewModel.swift
//  VideoPlayer
//
//  Created by 徐柏勳 on 7/11/25.
//

import Foundation

@MainActor
class FavoritesListViewModel: ObservableObject {
    @Published var favoriteVideos: [Video] = []
    
    func loadFavoriteVideos() {
        let favoriteIDs = Set(UserDefaults.standard.stringArray(forKey: UserDefaultsKeys.favoriteVideos) ?? [])
        let allVideos = MockDataProvider.shared.sampleVideos
        favoriteVideos = allVideos.filter { favoriteIDs.contains($0.id) }
    }
}