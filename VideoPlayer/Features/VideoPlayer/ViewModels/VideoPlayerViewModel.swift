//
//  VideoPlayerViewModel.swift
//  VideoPlayer
//
//  Created by 徐柏勳 on 7/11/25.
//

import Foundation
import AVFoundation
import Combine

@MainActor
class VideoPlayerViewModel: ObservableObject {
    @Published var isPlaying = false
    @Published var currentTime: TimeInterval = 0
    @Published var duration: TimeInterval = 0
    @Published var isLoading = true
    @Published var isJumpingLoading = false
    @Published var errorMessage: String?
    
    private var player: AVPlayer?
    private var timeObserver: Any?
    private var cancellables = Set<AnyCancellable>()
    
    let video: Video
    
    init(video: Video) {
        self.video = video
        resetState()
        setupPlayer()
    }
    
    deinit {
        if let timeObserver = timeObserver {
            player?.removeTimeObserver(timeObserver)
        }
        player?.pause()
    }
    
    private func setupPlayer() {
        let playerItem = AVPlayerItem(url: video.videoURL)
        player = AVPlayer(playerItem: playerItem)
        
        playerItem.publisher(for: \.status)
            .receive(on: RunLoop.main)
            .sink { [weak self] status in
                guard let self else { return }
                switch status {
                case .readyToPlay:
                    isLoading = false
                    duration = playerItem.duration.seconds
                    player?.play()
                    isPlaying = true
                case .failed:
                    isLoading = false
                    errorMessage = "Failed to load video"
                default:
                    break
                }
            }
            .store(in: &cancellables)
        
        setupTimeObserver()
    }
    
    private func setupTimeObserver() {
        let interval = CMTime(seconds: 0.1, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        timeObserver = player?.addPeriodicTimeObserver(forInterval: interval, queue: .main) { [weak self] time in
            guard let self else { return }
            Task { @MainActor in
                if !self.isJumpingLoading {
                    self.currentTime = time.seconds
                }
            }
        }
    }
    
    private func removeTimeObserver() {
        if let timeObserver = timeObserver {
            player?.removeTimeObserver(timeObserver)
            self.timeObserver = nil
        }
    }
    
    func togglePlayPause() {
        if isPlaying {
            player?.pause()
        } else {
            player?.play()
        }
        
        isPlaying.toggle()
    }
    
    func jumpLoadTo(time: TimeInterval) {
        isJumpingLoading = true
        currentTime = time
        
        let cmTime = CMTime(seconds: time, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        player?.seek(to: cmTime) { [weak self] completed in
            guard let self else { return }
            Task { @MainActor in
                self.isJumpingLoading = false
            }
        }
    }
    
    func stop() {
        player?.pause()
        isPlaying = false
    }
    
    func retry() {
        cleanup()
        resetState()
        setupPlayer()
    }
    
    private func cleanup() {
        removeTimeObserver()
        player?.pause()
    }
    
    private func resetState() {
        isLoading = true
        errorMessage = nil
        currentTime = 0
        duration = 0
        isPlaying = false
    }
    
    func getPlayer() -> AVPlayer? {
        return player
    }
}
