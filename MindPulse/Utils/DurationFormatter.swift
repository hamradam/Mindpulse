//
//  DurationFormatter.swift
//  MindPulse
//
//  Created by Petra  Šátková on 20.01.2026.
//

import SwiftUI


class DurationFormatter {
    static func formatSeconds(seconds: Int) -> String {
        guard seconds >= 0 else { return "0" }
        
        let hours = seconds / 3600
        let min = (seconds % 3600) / 60
        
        return hours > 0 ? "\(hours)h \(min)m" : "\(min)m"
    }
}

