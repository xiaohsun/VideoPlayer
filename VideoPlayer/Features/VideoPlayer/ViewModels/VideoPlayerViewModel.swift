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
    @Published var playbackSpeed: Float = 1.0
    @Published var errorMessage: String?
    @Published var loadedProgress: Double = 0.0
    @Published var showControls = true
    
    private var player: AVPlayer?
    private var timeObserver: Any?
    private var cancellables = Set<AnyCancellable>()
    private var controlsTimer: Timer?
    
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
        controlsTimer?.invalidate()
        player?.pause()
    }
    
    private func setupPlayer() {
        let playerItem = createPlayerItem()
        player = AVPlayer(playerItem: playerItem)
        player?.automaticallyWaitsToMinimizeStalling = true
        setupObservers(playerItem: playerItem)
        setupTimeObserver()
    }
    
    private func createPlayerItem() -> AVPlayerItem {
        let playerItem = AVPlayerItem(url: video.videoURL)
        playerItem.preferredForwardBufferDuration = 10
        return playerItem
    }
    
    private func setupObservers(playerItem: AVPlayerItem) {
        setupStatusObserver(playerItem: playerItem)
        setupProgressObserver(playerItem: playerItem)
    }
    
    private func setupStatusObserver(playerItem: AVPlayerItem) {
        playerItem.publisher(for: \.status)
            .receive(on: RunLoop.main)
            .sink { [weak self] status in
                guard let self else { return }
                switch status {
                case .readyToPlay:
                    isLoading = false
                    duration = playerItem.duration.seconds
                    player?.rate = playbackSpeed
                    isPlaying = true
                case .failed:
                    isLoading = false
                    errorMessage = "Failed to load video"
                default:
                    break
                }
            }
            .store(in: &cancellables)
    }
    
    private func setupProgressObserver(playerItem: AVPlayerItem) {
        playerItem.publisher(for: \.loadedTimeRanges)
            .receive(on: RunLoop.main)
            .sink { [weak self] timeRanges in
                guard let self, let timeRange = timeRanges.first?.timeRangeValue else { return }
                let loadedDuration = CMTimeGetSeconds(timeRange.start) + CMTimeGetSeconds(timeRange.duration)
                let totalDuration = CMTimeGetSeconds(playerItem.duration)
                if totalDuration > 0 {
                    self.loadedProgress = loadedDuration / totalDuration
                }
            }
            .store(in: &cancellables)
    }
    
    private func setupTimeObserver() {
        let interval = CMTime(seconds: 0.5, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
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
            player?.rate = playbackSpeed
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
        playbackSpeed = 1.0
        loadedProgress = 0.0
    }
    
    func setPlaybackSpeed(_ speed: Float) {
        playbackSpeed = speed
        player?.rate = isPlaying ? speed : 0.0
    }
    
    func skipForward() {
        let newTime = currentTime + 10
        jumpLoadTo(time: min(newTime, duration))
    }
    
    func skipBackward() {
        let newTime = currentTime - 10
        jumpLoadTo(time: max(newTime, 0))
    }
    
    func getPlayer() -> AVPlayer? {
        return player
    }
    
    func toggleControls() {
        showControls.toggle()
        if showControls {
            resetControlsTimer()
        }
    }
    
    func resetControlsTimer() {
        controlsTimer?.invalidate()
        controlsTimer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: false) { [weak self] _ in
            DispatchQueue.main.async {
                self?.showControls = false
            }
        }
    }
}
