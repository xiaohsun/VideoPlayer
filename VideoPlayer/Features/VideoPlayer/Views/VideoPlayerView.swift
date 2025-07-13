//
//  VideoPlayerView.swift
//  VideoPlayer
//
//  Created by 徐柏勳 on 7/11/25.
//

import SwiftUI
import AVKit

struct VideoPlayerView: View {
    @StateObject private var viewModel: VideoPlayerViewModel
    @State private var showControls = true
    @State private var controlsTimer: Timer?
    @State private var isDragging = false
    @State private var dragValue: Double = 0
    @Environment(\.dismiss) private var dismiss
    
    init(video: Video) {
        self._viewModel = StateObject(wrappedValue: VideoPlayerViewModel(video: video))
    }
    
    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()
            
            if viewModel.isLoading {
                loadingView
            } else if let errorMessage = viewModel.errorMessage {
                errorView(message: errorMessage)
            } else {
                playerView
            }
        }
        .navigationBarHidden(true)
        .statusBarHidden()
        .onTapGesture {
            toggleControls()
        }
    }
    
    @MainActor
    @ViewBuilder
    private var playerView: some View {
        ZStack {
            if let player = viewModel.getPlayer() {
                VideoPlayer(player: player)
                    .disabled(true)
                    .allowsHitTesting(false)
                    .ignoresSafeArea()
            }
            
            if showControls {
                controlsOverlay
            }
        }
    }
    
    @MainActor
    @ViewBuilder
    private var controlsOverlay: some View {
        VStack {
            topControls
            
            Spacer()
            
            bottomControls
        }
        .background(
            LinearGradient(
                colors: [
                    Color.black.opacity(0.6),
                    Color.clear,
                    Color.black.opacity(0.6)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
        )
    }
    
    @MainActor
    @ViewBuilder
    private var topControls: some View {
        HStack {
            Button {
                viewModel.stop()
                
                dismiss()
            } label: {
                Image(systemName: "chevron.left")
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(.white)
            }
            
            Spacer()
            
            Text(viewModel.video.title)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.white)
                .lineLimit(1)
            
            Spacer()
        }
        .padding(.horizontal, 16)
        .padding(.top, 12)
    }
    
    @MainActor
    @ViewBuilder
    private var bottomControls: some View {
        VStack(spacing: 12) {
            progressBar
            
            playerControls
        }
        .padding(.horizontal, 16)
        .padding(.bottom, 20)
    }
    
    @MainActor
    @ViewBuilder
    private var progressBar: some View {
        VStack(spacing: 8) {
            progressTime
            
            progressSlider
        }
    }
    
    @MainActor
    @ViewBuilder
    private var progressTime: some View {
        HStack {
            Text((isDragging ? dragValue : viewModel.currentTime).formattedTime)
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(.white)
            
            Spacer()
            
            Text(viewModel.duration.formattedTime)
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(.white)
        }
        .overlay {
            if viewModel.isJumpingLoading {
                HStack(spacing: 4) {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .scaleEffect(0.7)
                    
                    Text("Loading...")
                        .font(.system(size: 10, weight: .medium))
                        .foregroundColor(.white.opacity(0.8))
                }
            }
        }
    }
    
    @MainActor
    @ViewBuilder
    private var progressSlider: some View {
        Slider(
            value: Binding(
                get: { isDragging ? dragValue : viewModel.currentTime },
                set: { value in
                    dragValue = value
                }
            ),
            in: 0...max(viewModel.duration, 1),
            onEditingChanged: { editing in
                isDragging = editing
                if !editing {
                    viewModel.jumpLoadTo(time: dragValue)
                }
            }
        ) {
            Text("Progress")
        }
        .accentColor(.white)
    }
    
    @MainActor
    @ViewBuilder
    private var playerControls: some View {
        HStack(spacing: 32) {
            Spacer()
            
            Button {
                viewModel.togglePlayPause()
                resetControlsTimer()
            } label: {
                Image(systemName: viewModel.isPlaying ? "pause.fill" : "play.fill")
                    .font(.system(size: 32, weight: .medium))
                    .foregroundColor(.white)
            }
            .transaction { transaction in
                transaction.disablesAnimations = true
            }
            
            Spacer()
        }
    }
    
    @MainActor
    @ViewBuilder
    private var loadingView: some View {
        VStack(spacing: 16) {
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                .scaleEffect(1.5)
            
            Text("Loading video...")
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.white)
        }
    }
    
    @MainActor
    @ViewBuilder
    private func errorView(message: String) -> some View {
        VStack(spacing: 16) {
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 48))
                .foregroundColor(.white)
            
            Text("Something went wrong")
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(.white)
            
            Text(message)
                .font(.system(size: 14, weight: .regular))
                .foregroundColor(.white.opacity(0.8))
                .multilineTextAlignment(.center)
            
            Button("Retry") {
                viewModel.retry()
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
    }
    
    private func toggleControls() {
        withAnimation(.easeInOut(duration: 0.3)) {
            showControls.toggle()
        }
        
        if showControls {
            resetControlsTimer()
        }
    }
    
    private func resetControlsTimer() {
        controlsTimer?.invalidate()
        controlsTimer = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: false) { _ in
            withAnimation(.easeInOut(duration: 0.3)) {
                showControls = false
            }
        }
    }
}

#Preview {
    VideoPlayerView(video: MockDataProvider.shared.sampleVideos[0])
}
