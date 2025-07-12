//
//  OffsettableScrollView.swift
//  VideoPlayer
//
//  Created by 徐柏勳 on 7/12/25.
//

import SwiftUI

private struct OffsetPreferenceKey: PreferenceKey {
    static let defaultValue: CGPoint = .zero
    static func reduce(value: inout CGPoint, nextValue: () -> CGPoint) { }
}

struct OffsettableScrollView<T: View>: View {
    let axes: Axis.Set
    let showsIndicator: Bool
    let onOffsetChanged: (CGPoint) -> Void
    let content: T
    
    init(axes: Axis.Set = .vertical,
         showsIndicator: Bool = false,
         onOffsetChanged: @escaping (CGPoint) -> Void = { _ in },
         @ViewBuilder content: () -> T
    ) {
        self.axes = axes
        self.showsIndicator = showsIndicator
        self.onOffsetChanged = onOffsetChanged
        self.content = content()
    }
    
    var body: some View {
        ScrollView(axes, showsIndicators: showsIndicator) {
            content
                .background( GeometryReader { proxy in
                    Color.clear.preference(
                        key: OffsetPreferenceKey.self,
                        value: proxy.frame(
                            in: .named("ScrollViewOrigin")
                        ).origin
                    )
                })
        }
        .coordinateSpace(name: "ScrollViewOrigin")
        .onPreferenceChange(
            OffsetPreferenceKey.self,
            perform: onOffsetChanged
        )
    }
}
