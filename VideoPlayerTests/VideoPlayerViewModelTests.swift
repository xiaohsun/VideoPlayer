//
//  VideoPlayerViewModelTests.swift
//  VideoPlayerTests
//
//  Created by 徐柏勳 on 7/14/25.
//

import XCTest
import Combine
@testable import VideoPlayer

@MainActor
final class VideoPlayerViewModelTests: XCTestCase {
    
    var viewModel: VideoPlayerViewModel!
    var cancellables: Set<AnyCancellable>!
    var mockVideo: Video!
    
    override func setUp() {
        super.setUp()
        cancellables = Set<AnyCancellable>()
        mockVideo = MockDataProvider.shared.sampleVideos[0]
        viewModel = VideoPlayerViewModel(video: mockVideo)
    }
    
    override func tearDown() {
        cancellables = nil
        viewModel = nil
        mockVideo = nil
        super.tearDown()
    }
    
    // MARK: - Play & Pause Control Tests
    func testTogglePlayPause() {
        viewModel.isPlaying = false
        viewModel.togglePlayPause()
        XCTAssertTrue(viewModel.isPlaying)
        
        viewModel.togglePlayPause()
        XCTAssertFalse(viewModel.isPlaying)
    }
    
    func testStop() {
        viewModel.isPlaying = true
        viewModel.stop()
        XCTAssertFalse(viewModel.isPlaying)
    }
    
    // MARK: - Playback Speed Tests
    func testSetPlaybackSpeed() {
        let speed = viewModel.speedControlArray[0]
        viewModel.setPlaybackSpeed(speed)
        XCTAssertEqual(viewModel.playbackSpeed, speed)
    }
    
    // MARK: - Skip Controls Tests
    func testSkipForward() {
        viewModel.currentTime = 5.0
        viewModel.duration = 30.0
        
        viewModel.skipForward()
        
        XCTAssertEqual(viewModel.currentTime, 15.0)
    }
    
    func testSkipForwardAtEnd() {
        viewModel.currentTime = 25.0
        viewModel.duration = 30.0
        
        viewModel.skipForward()
        
        XCTAssertEqual(viewModel.currentTime, 30.0)
    }
    
    func testSkipBackward() {
        viewModel.currentTime = 15.0
        viewModel.duration = 30.0
        
        viewModel.skipBackward()
        
        XCTAssertEqual(viewModel.currentTime, 5.0)
    }
    
    func testSkipBackwardAtBeginning() {
        viewModel.currentTime = 5.0
        viewModel.duration = 30.0
        
        viewModel.skipBackward()
        
        XCTAssertEqual(viewModel.currentTime, 0.0)
    }
    
    // MARK: - Controls Hide Tests
    func testToggleControls() {
        viewModel.showControls = false
        viewModel.toggleControls()
        XCTAssertTrue(viewModel.showControls)
        
        viewModel.toggleControls()
        XCTAssertFalse(viewModel.showControls)
    }
    
    // MARK: - Jump Tests
    func testJumpLoadTo() {
        viewModel.duration = 100.0
        
        viewModel.jumpLoadTo(time: 50.0)
        
        XCTAssertTrue(viewModel.isJumpingLoading)
        XCTAssertEqual(viewModel.currentTime, 50.0)
    }
    
    func testJumpLoadToNegativeTime() {
        viewModel.duration = 100.0
        
        viewModel.jumpLoadTo(time: -10.0)
        
        XCTAssertTrue(viewModel.isJumpingLoading)
        XCTAssertEqual(viewModel.currentTime, 0.0)
    }
    
    func testJumpLoadToBeyondDuration() {
        viewModel.duration = 100.0
        
        viewModel.jumpLoadTo(time: 150.0)
        
        XCTAssertTrue(viewModel.isJumpingLoading)
        XCTAssertEqual(viewModel.currentTime, 100.0)
    }
    
    // MARK: - State Reset Tests
    func testRetry() {
        viewModel.isLoading = false
        viewModel.errorMessage = "Some error"
        viewModel.currentTime = 10.0
        viewModel.isPlaying = true
        viewModel.loadedProgress = 0.5
        viewModel.duration = 100.0
        
        viewModel.retry()
        
        XCTAssertTrue(viewModel.isLoading)
        XCTAssertNil(viewModel.errorMessage)
        XCTAssertEqual(viewModel.currentTime, 0)
        XCTAssertFalse(viewModel.isPlaying)
        XCTAssertEqual(viewModel.playbackSpeed, 1.0)
        XCTAssertEqual(viewModel.loadedProgress, 0.0)
        XCTAssertEqual(viewModel.duration, 0)
    }
}
