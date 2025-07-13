//
//  VideoPlayerUITests.swift
//  VideoPlayerUITests
//
//  Created by 徐柏勳 on 7/11/25.
//

import XCTest

final class VideoPlayerUITests: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    @MainActor
    func testAppLaunches() throws {
        let app = XCUIApplication()
        app.launch()
        
        // Verify the app launches successfully
        XCTAssertTrue(app.exists)
    }

    @MainActor
    func testLaunchPerformance() throws {
        // This measures how long it takes to launch your application.
        measure(metrics: [XCTApplicationLaunchMetric()]) {
            XCUIApplication().launch()
        }
    }
}
