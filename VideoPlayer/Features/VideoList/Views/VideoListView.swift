//
//  VideoListView.swift
//  VideoPlayer
//
//  Created by 徐柏勳 on 7/11/25.
//

import SwiftUI

struct VideoListView: View {
    @StateObject private var viewModel = VideoListViewModel()
    @State private var toast: ToastView.Model?
    @State private var showingFavorites = false
    @State private var offsetY: CGFloat = 0
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
        .sheet(isPresented: $showingFavorites) {
            FavoritesListView()
        }
        .toastView(item: $toast)
    }
    
    @MainActor
    @ViewBuilder
    private var contentView: some View {
        if viewModel.isLoading {
            loadingView
        } else if let errorMessage = viewModel.errorMessage {
            errorView(message: errorMessage)
        } else {
            videoListView
        }
    }
    
    @MainActor
    @ViewBuilder
    private var navigationBar: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                Spacer()

                favoriteNavButton
            }
            .padding(.horizontal, 12)
            .frame(height: 48)
            .background(isNaviTransparent ? .clear : Color(UIColor.systemBackground))
            .overlay(
                Text("Let's Learn!")
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
    private var titleStack: some View {
        HStack(spacing: 16) {
            Text("Let's Learn!")
                .font(.system(size: 32, weight: .bold))
                .foregroundColor(.primary)
                .multilineTextAlignment(.center)
            
            Spacer()
            
            favoriteButton
        }
        .padding(.horizontal, 16)
        .padding(.top, 30)
    }
    
    @MainActor
    @ViewBuilder
    private var videoListView: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(viewModel.videos) { video in
                    VideoCardView(video: video) {
                        toast = ToastView.Model(message: "Added !")
                    }
                    .onTapGesture {
                        // TODO: Navigate to video player
                    }
                    
                    if video.id != viewModel.videos.last?.id {
                        strokeView
                    }
                }
            }
            .padding(.leading, 16)
            .padding(.trailing, 10)
            .padding(.top, 12)
            .padding(.bottom, 50)
        }
        .scrollIndicators(.hidden)
    }
    
    @MainActor
    @ViewBuilder
    private var loadingView: some View {
        VStack(spacing: 16) {
            ProgressView()
                .scaleEffect(1.5)
            
            Text("Loading videos...")
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.top, 100)
    }
    
    @MainActor
    @ViewBuilder
    private var strokeView: some View {
        Color.primary.opacity(0.1).frame(height: 1)
    }
    
    @MainActor
    @ViewBuilder
    private func errorView(message: String) -> some View {
        VStack(spacing: 16) {
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 48))
                .foregroundColor(.orange)
            
            Text("Something went wrong")
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(.primary)
            
            Text(message)
                .font(.system(size: 14, weight: .regular))
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
            
            Button("Retry") {
                viewModel.retry()
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    @MainActor
    @ViewBuilder
    private var favoriteButton: some View {
        Button {
            showingFavorites = true
        } label: {
            Image(systemName: "heart")
                .font(.system(size: 20, weight: .medium))
                .foregroundColor(.primary)
        }
    }
    
    @MainActor
    @ViewBuilder
    private var favoriteNavButton: some View {
        Button {
            showingFavorites = true
        } label: {
            Image(systemName: "heart")
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.primary)
                .opacity(isNaviTransparent ? 0 : 1)
        }
    }
}

#Preview {
    NavigationView {
        VideoListView()
    }
}
