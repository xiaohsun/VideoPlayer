//
//  FavoritesListView.swift
//  VideoPlayer
//
//  Created by 徐柏勳 on 7/11/25.
//

import SwiftUI

struct FavoritesListView: View {
    @StateObject private var viewModel = FavoritesListViewModel()
    @State private var offsetY: CGFloat = 0
    @Environment(\.dismiss) private var dismiss
    
    var isNaviTransparent: Bool {
        offsetY > -40
    }
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .top) {
                VStack(spacing: 0) {
                    OffsettableScrollView(axes: .vertical) { point in
                        offsetY = point.y
                    } content: {
                        titleStack
                        
                        contentView
                    }
                }

                VStack(spacing: 0) {
                    navigationBar

                    Spacer()
                }
            }
        }
        .navigationBarHidden(true)
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
        LazyVStack(spacing: 16) {
            ForEach(viewModel.favoriteVideos) { video in
                NavigationLink(destination: VideoPlayerView(video: video)) {
                    VideoCardView(video: video, showFavoriteButton: false)
                }
                .buttonStyle(.plain)
                .foregroundColor(.primary)
                
                if video.id != viewModel.favoriteVideos.last?.id {
                    strokeView
                }
            }
        }
        .padding(.leading, 16)
        .padding(.trailing, 10)
        .padding(.top, 12)
        .padding(.bottom, 50)
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
        .offset(y: 150)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    @MainActor
    @ViewBuilder
    private var strokeView: some View {
        Color.primary.opacity(0.1).frame(height: 1)
    }
    
    @MainActor
    @ViewBuilder
    private var navigationBar: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                Spacer()

                closeNavButton
            }
            .padding(.horizontal, 12)
            .frame(height: 48)
            .background(isNaviTransparent ? .clear : Color(UIColor.systemBackground))
            .overlay(
                Text("My Favorites")
                    .font(.system(size: 17, weight: .medium))
                    .foregroundColor(isNaviTransparent ? .clear : .primary)
            )

            Color.primary
                .opacity(isNaviTransparent ? 0 : 0.1)
                .frame(height: 1)
        }
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
    
    @MainActor
    @ViewBuilder
    private var closeNavButton: some View {
        Button {
            dismiss()
        } label: {
            Image(systemName: "xmark")
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.primary)
                .opacity(isNaviTransparent ? 0 : 1)
        }
    }
}

#Preview {
    NavigationView {
        FavoritesListView()
    }
}
