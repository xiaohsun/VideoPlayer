//
//  VideoListView.swift
//  VideoPlayer
//
//  Created by 徐柏勳 on 7/11/25.
//

import SwiftUI

struct VideoListView: View {
    @StateObject private var viewModel = VideoListViewModel()
    
    var body: some View {
        contentView
            .navigationTitle("Let's Learn!")
            .navigationBarTitleDisplayMode(.large)
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
    private var videoListView: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(viewModel.videos) { video in
                    VideoCardView(video: video)
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
            .padding(.top, 18)
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
    }
    
    @MainActor
    @ViewBuilder
    private var strokeView: some View {
        Color.black.opacity(0.05).frame(height: 1)
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
}

#Preview {
    NavigationView {
        VideoListView()
    }
}
