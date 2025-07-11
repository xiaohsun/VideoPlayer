//
//  TimeInterval+Extensions.swift
//  VideoPlayer
//
//  Created by 徐柏勳 on 7/11/25.
//

import Foundation

extension TimeInterval {
    var formattedTime: String {
        let totalSeconds = Int(self)
        let minutes = totalSeconds / 60
        let seconds = totalSeconds % 60
        
        if minutes >= 60 {
            let hours = minutes / 60
            let remainingMinutes = minutes % 60
            return String(format: "%d:%02d:%02d", hours, remainingMinutes, seconds)
        } else {
            return String(format: "%d:%02d", minutes, seconds)
        }
    }
    
    var shortFormattedTime: String {
        let totalSeconds = Int(self)
        let minutes = totalSeconds / 60
        let seconds = totalSeconds % 60
        
        if minutes >= 60 {
            let hours = minutes / 60
            let remainingMinutes = minutes % 60
            return String(format: "%dh %dm", hours, remainingMinutes)
        } else if minutes > 0 {
            return String(format: "%dm", minutes)
        } else {
            return String(format: "%ds", seconds)
        }
    }
}