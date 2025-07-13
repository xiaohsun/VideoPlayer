//
//  VideoPlayerView.swift
//  VideoPlayer
//
//  Created by 徐柏勳 on 7/13/25.
//

import SwiftUI
import AVKit

struct VideoPlayerView: View {
    @StateObject private var viewModel: VideoPlayerViewModel
    @State private var isDragging = false
    @State private var dragValue: Double = 0
    @State private var showSpeedPicker = false
    @Environment(\.dismiss) private var dismiss
    
    init(video: Video) {
        self._viewModel = StateObject(wrappedValue: VideoPlayerViewModel(video: video))
    }
    
    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()
            
            playerView
        }
        .navigationBarHidden(true)
        .statusBarHidden()
        .onTapGesture {
            viewModel.toggleControls()
        }
        .overlay {
            if showSpeedPicker {
                speedPickerOverlay
            }
        }
    }
    
    @MainActor
    @ViewBuilder
    private var playerView: some View {
        ZStack {
            if viewModel.isLoading {
                loadingView
            } else if let errorMessage = viewModel.errorMessage {
                errorView(message: errorMessage)
            } else {
                if let player = viewModel.getPlayer() {
                    VideoPlayer(player: player)
                        .disabled(true)
                        .allowsHitTesting(false)
                        .ignoresSafeArea()
                }
            }
            
            if viewModel.showControls {
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
            
            Button {
                showSpeedPicker.toggle()
                viewModel.resetControlsTimer()
            } label: {
                Text("\(viewModel.playbackSpeed, specifier: "%.1f")x")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.white)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(Color.black.opacity(0.6))
                    .clipShape(RoundedRectangle(cornerRadius: 16))
            }
        }
        .overlay {
            Text(viewModel.video.title)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.white)
                .lineLimit(1)
        }
        .padding(.horizontal, 16)
        .padding(.top, 12)
    }
    
    @MainActor
    @ViewBuilder
    private var bottomControls: some View {
        VStack(spacing: 16) {
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
        let totoalWidth = UIScreen.main.bounds.width - 32
        let currentTime = isDragging ? dragValue : viewModel.currentTime
        let duration = max(viewModel.duration, 1)
        
        ZStack(alignment: .leading) {
            // Background Progress
            Rectangle()
                .frame(height: 4)
                .foregroundColor(.white.opacity(0.3))
            
            // Buffering Progress
            Rectangle()
                .frame(width: max(0, CGFloat(viewModel.loadedProgress) * totoalWidth), height: 4)
                .foregroundColor(.white.opacity(0.45))
            
            // Playing Progress
            Rectangle()
                .frame(width: max(0, CGFloat(currentTime / duration) * totoalWidth), height: 4)
                .foregroundColor(.white)
        }
        .clipShape(RoundedRectangle(cornerRadius: 2))
        .gesture(
            DragGesture(minimumDistance: 0)
                .onChanged { value in
                    let progress = max(0, min(1, value.location.x / totoalWidth))
                    dragValue = progress * viewModel.duration
                    isDragging = true
                }
                .onEnded { _ in
                    viewModel.jumpLoadTo(time: max(0, dragValue))
                    isDragging = false
                }
        )
    }
    
    @MainActor
    @ViewBuilder
    private var playerControls: some View {
        HStack(spacing: 24) {
            backwardView
            
            playPauseView
            
            forwardView
        }
    }
    
    @MainActor
    @ViewBuilder
    private var backwardView: some View {
        Button {
            viewModel.skipBackward()
            viewModel.resetControlsTimer()
        } label: {
            Image(systemName: "gobackward.10")
                .font(.system(size: 24, weight: .medium))
                .foregroundColor(.white)
        }
    }
    
    
    @MainActor
    @ViewBuilder
    private var forwardView: some View {
        Button {
            viewModel.skipForward()
            viewModel.resetControlsTimer()
        } label: {
            Image(systemName: "goforward.10")
                .font(.system(size: 24, weight: .medium))
                .foregroundColor(.white)
        }
    }
    
    @MainActor
    @ViewBuilder
    private var playPauseView: some View {
        Button {
            viewModel.togglePlayPause()
            viewModel.resetControlsTimer()
        } label: {
            Image(systemName: viewModel.isPlaying ? "pause.fill" : "play.fill")
                .font(.system(size: 28, weight: .medium))
                .foregroundColor(.white)
        }
        .transaction { transaction in
            transaction.disablesAnimations = true
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
    
    @MainActor
    @ViewBuilder
    private var speedPickerOverlay: some View {
        Color.black.opacity(0.4)
            .ignoresSafeArea()
            .onTapGesture {
                showSpeedPicker = false
            }
            .overlay(speedPickerView)
    }
    
    @MainActor
    @ViewBuilder
    private var speedPickerView: some View {
        VStack(spacing: 0) {
            ForEach(viewModel.speedControlArray, id: \.self) { speed in
                Button {
                    viewModel.setPlaybackSpeed(Float(speed))
                    showSpeedPicker = false
                    viewModel.resetControlsTimer()
                } label: {
                    HStack {
                        Text("\(speed, specifier: "%.1f")x")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.white)
                        
                        Spacer()
                        
                        if viewModel.playbackSpeed == Float(speed) {
                            Image(systemName: "checkmark")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.white)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 16)
                }
                
                if speed != 2.0 {
                    Divider()
                        .background(Color.white.opacity(0.3))
                }
            }
        }
        .background(Color.black.opacity(0.8))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .frame(width: 120)
        .position(x: UIScreen.main.bounds.width - 80, y: 180)
    }
}

#Preview {
    VideoPlayerView(video: MockDataProvider.shared.sampleVideos[0])
}
