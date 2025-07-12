//
//  VideoCardView.swift
//  VideoPlayer
//
//  Created by 徐柏勳 on 7/11/25.
//

import SwiftUI

struct VideoCardView: View {
    let video: Video
    let showFavoriteButton: Bool
    @StateObject private var viewModel: VideoCardViewModel
    
    init(video: Video, showFavoriteButton: Bool = true, onFavoriteAdded: @escaping () -> Void = {}) {
        self.video = video
        self.showFavoriteButton = showFavoriteButton
        let vm = VideoCardViewModel(video: video)
        vm.onFavoriteAdded = onFavoriteAdded
        self._viewModel = StateObject(wrappedValue: vm)
    }
    
    var body: some View {
        HStack(spacing: 16) {
            thumbnailView
            
            infoSection
            
            Spacer()
        }
        .padding(.vertical, 6)
    }
    
    @MainActor
    @ViewBuilder
    private var thumbnailView: some View {
        CachedAsyncImage(url: video.thumbnailURL) { image in
            image
                .resizable()
                .aspectRatio(contentMode: .fill)
        } placeholder: {
            placeholderView
        }
        .frame(width: 140, height: 78)
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
    
    @MainActor
    @ViewBuilder
    private var placeholderView: some View {
        Rectangle()
            .fill(difficultyColor.opacity(0.2))
            .overlay(
                VStack(spacing: 4) {
                    Image(systemName: "play.circle.fill")
                        .font(.title2)
                        .foregroundColor(difficultyColor)
                    
                    Text(video.difficulty.rawValue)
                        .font(.system(size: 10, weight: .medium))
                        .foregroundColor(difficultyColor)
                }
            )
    }
    
    @MainActor
    @ViewBuilder
    private var infoSection: some View {
        VStack(alignment: .leading, spacing: 6) {
            titleLabel
            
            descriptionLabel
            
            metadataRow
        }
    }
    
    @MainActor
    @ViewBuilder
    private var titleLabel: some View {
        HStack {
            Text(video.title)
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.primary)
                .lineLimit(2)
                .multilineTextAlignment(.leading)
        }
    }
    
    @MainActor
    @ViewBuilder
    private var descriptionLabel: some View {
        Text(video.description)
            .font(.system(size: 14, weight: .regular))
            .foregroundColor(.secondary)
            .lineLimit(2)
            .multilineTextAlignment(.leading)
    }
    
    @MainActor
    @ViewBuilder
    private var metadataRow: some View {
        HStack(spacing: 8) {
            durationBadge
            
            difficultyBadge
            
            Spacer()
            
            if showFavoriteButton {
                favoriteButton
            }
        }
    }
    
    @MainActor
    @ViewBuilder
    private var durationBadge: some View {
        HStack(spacing: 4) {
            Image(systemName: "clock")
                .font(.system(size: 12))
            
            Text(video.duration.shortFormattedTime)
                .font(.system(size: 12, weight: .medium))
        }
        .foregroundColor(.secondary)
    }
    
    @MainActor
    @ViewBuilder
    private var difficultyBadge: some View {
        Text(video.difficulty.rawValue)
            .font(.system(size: 12, weight: .medium))
            .foregroundColor(difficultyColor)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(
                RoundedRectangle(cornerRadius: 4)
                    .fill(difficultyColor.opacity(0.1))
            )
    }
    
    @MainActor
    @ViewBuilder
    private var favoriteButton: some View {
        Button {
            withAnimation {
                viewModel.toggleFavorite()
            }
        } label: {
            Image(systemName: viewModel.isFavorite ? "heart.fill" : "heart")
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(viewModel.isFavorite ? .red : .gray)
        }
        .buttonStyle(.plain)
    }
    
    private var difficultyColor: Color {
        switch video.difficulty {
        case .beginner:
            return .green
        case .intermediate:
            return .orange
        case .advanced:
            return .red
        }
    }
}

#Preview {
    VStack {
        VideoCardView(video: MockDataProvider.shared.sampleVideos[0])
            .padding()
        
        VideoCardView(video: MockDataProvider.shared.sampleVideos[1])
            .padding()
        
        VideoCardView(video: MockDataProvider.shared.sampleVideos[4])
            .padding()
    }
}
