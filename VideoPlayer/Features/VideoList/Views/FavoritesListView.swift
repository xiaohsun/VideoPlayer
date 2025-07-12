//
//  FavoritesListView.swift
//  VideoPlayer
//
//  Created by 徐柏勳 on 7/11/25.
//

import SwiftUI

struct FavoritesListView: View {
    @StateObject private var viewModel = FavoritesListViewModel()
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack(spacing: 0) {
            titleStack
            
            contentView
        }
        .onAppear {
            viewModel.loadFavoriteVideos()
        }
    }
    
    @MainActor
    @ViewBuilder
    private var contentView: some View {
        if viewModel.favoriteVideos.isEmpty {
            emptyStateView
        } else {
            favoriteListView
        }
    }
    
    @MainActor
    @ViewBuilder
    private var titleStack: some View {
        HStack(spacing: 16) {
            Text("My Favorites")
                .font(.system(size: 32, weight: .bold))
                .foregroundColor(.primary)
                .multilineTextAlignment(.center)
            
            Spacer()
            
            closeButton
        }
        .padding(.horizontal, 16)
        .padding(.top, 30)
    }
    
    @MainActor
    @ViewBuilder
    private var favoriteListView: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(viewModel.favoriteVideos) { video in
                    VideoCardView(video: video, showFavoriteButton: false)
                    .onTapGesture {
                        // TODO: Navigate to video player
                    }
                    
                    if video.id != viewModel.favoriteVideos.last?.id {
                        strokeView
                    }
                }
            }
            .padding(.leading, 16)
            .padding(.trailing, 10)
            .padding(.top, 18)
            .padding(.bottom, 50)
        }
        .scrollIndicators(.hidden)
    }
    
    @MainActor
    @ViewBuilder
    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Image(systemName: "heart")
                .font(.system(size: 48))
                .foregroundColor(.gray)
            
            Text("No Favorite Videos Yet :(")
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(.primary)
        }
        .offset(y: -40)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    @MainActor
    @ViewBuilder
    private var strokeView: some View {
        Color.primary.opacity(0.1).frame(height: 1)
    }
    
    @MainActor
    @ViewBuilder
    private var closeButton: some View {
        Button {
            dismiss()
        } label: {
            Image(systemName: "xmark")
                .font(.system(size: 20, weight: .medium))
                .foregroundColor(.primary)
        }
    }
}

#Preview {
    NavigationView {
        FavoritesListView()
    }
}
