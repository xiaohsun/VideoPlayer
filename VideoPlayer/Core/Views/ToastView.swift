//
//  ToastView.swift
//  VideoPlayer
//
//  Created by 徐柏勳 on 7/11/25.
//

import SwiftUI

struct ToastView: View {
    struct Model: Equatable {
        let message: String
        var duration: Double = 1.5
    }
    
    let model: Model
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: "checkmark.circle")
                .font(.system(size: 20))
                .foregroundColor(.white)
            
            Text(model.message)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.white)
        }
        .padding(12)
        .background(.green.opacity(0.75))
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

struct ToastModifier: ViewModifier {
    @Binding var item: ToastView.Model?
    @State private var workItem: DispatchWorkItem?
    
    func body(content: Content) -> some View {
        content
            .overlay(
                VStack {
                    Spacer()
                    
                    if let item = item {
                        ToastView(model: item)
                            .transition(.opacity)
                    }
                }
                .padding(.bottom, 360)
                .animation(.easeInOut(duration: 0.3), value: item)
            )
            .onChange(of: item) {
                showToast()
            }
    }
    
    private func showToast() {
        guard let item = item else { return }
        
        workItem?.cancel()
        
        let task = DispatchWorkItem {
            withAnimation {
                self.item = nil
            }
        }
        
        workItem = task
        DispatchQueue.main.asyncAfter(deadline: .now() + item.duration, execute: task)
    }
}

extension View {
    func toastView(item: Binding<ToastView.Model?>) -> some View {
        self.modifier(ToastModifier(item: item))
    }
}

#Preview {
    ToastView(model: .init(message: "Added !"))
}
