//
//  StatisticsState.swift
//  MindPulse
//
//  Created by Petra  Šátková on 24.01.2026.
//

import Foundation

@Observable
final class StatisticsState {
    var activities: [ActivityModel] = []
    var records: [RecordModel] = []
    var totalMinutes: Int = 0
    var totalCount: Int = 0
    var weeklyPoints: [DayMinutes]? = []
    var hrSamples: [HeartRateSampleModel] = []
    
    var minHR: Int? = nil
    var maxHR: Int? = nil
    var avgHR: Int? = nil
    
    var focusScore: Int16? = nil
}
