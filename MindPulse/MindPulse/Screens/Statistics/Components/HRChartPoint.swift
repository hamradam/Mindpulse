//
//  HrChartPoint.swift
//  MindPulse
//
//  Created by Petra  Šátková on 27.01.2026.
//

import Foundation

struct HRChartPoint: Identifiable {
    let id: UUID
    let minute: Double
    let bpm: Double
}
