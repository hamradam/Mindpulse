//
//  DayMinutes.swift
//  MindPulse
//
//  Created by Petra  Šátková on 27.01.2026.
//

import Foundation

struct DayMinutes: Identifiable {
    let id = UUID()
    let weekdayIndex: Int   // 1..7 (Mon..Sun)
    let label: String       // "Mon"..."Sun"
    let minutes: Int
}
