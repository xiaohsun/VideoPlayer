//
//  CachedAsyncImage.swift
//  VideoPlayer
//
//  Created by 徐柏勳 on 7/11/25.
//

import SwiftUI

struct CachedAsyncImage<Content: View, Placeholder: View>: View {
    @State private var phase: AsyncImagePhase
    let urlRequest: URLRequest
    let content: (Image) -> Content
    let placeholder: () -> Placeholder
    var session: URLSession = .imageSession
    
    init(
        url: URL,
        session: URLSession = .imageSession,
        @ViewBuilder content: @escaping (Image) -> Content,
        @ViewBuilder placeholder: @escaping () -> Placeholder
    ) {
        self.session = session
        self.urlRequest = URLRequest(url: url)
        self.content = content
        self.placeholder = placeholder
        
        if let data = session.configuration.urlCache?.cachedResponse(for: urlRequest)?.data,
           let uiImage = UIImage(data: data) {
            _phase = .init(wrappedValue: .success(.init(uiImage: uiImage)))
        } else {
            _phase = .init(wrappedValue: .empty)
        }
    }
    
    var body: some View {
        Group {
            switch phase {
            case .empty:
                placeholder()
                    .task { await load() }
            case .success(let image):
                content(image)
            case .failure(_):
                placeholder()
            @unknown default:
                placeholder()
            }
        }
    }
    
    func load() async {
        do {
            let (data, response) = try await session.data(for: urlRequest)
            guard let response = response as? HTTPURLResponse,
                  200...299 ~= response.statusCode,
                  let uiImage = UIImage(data: data)
            else {
                throw URLError(.unknown)
            }
            
            phase = .success(.init(uiImage: uiImage))
        } catch {
            phase = .failure(error)
        }
    }
}
