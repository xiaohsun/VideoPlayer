//
//  View+Extensions.swift
//  VideoPlayer
//
//  Created by 徐柏勳 on 7/11/25.
//

import SwiftUI

extension URLSession {
    static let imageSession: URLSession = {
        let config = URLSessionConfiguration.default
        config.urlCache = .imageCache
        return .init(configuration: config)
    }()
}

extension URLCache {
    static let imageCache: URLCache = {
        .init(memoryCapacity: 20 * 1024 * 1024,
              diskCapacity: 50 * 1024 * 1024)
    }()
}
