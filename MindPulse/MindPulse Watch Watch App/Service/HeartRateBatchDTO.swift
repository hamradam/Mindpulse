//
//  HeartRateBatchDTO.swift
//  MindPulse
//
//  Created by Petra  Šátková on 22.01.2026.
//

import Foundation

struct ActivityRecordDTO: Codable {
    let activityId: UUID
    let startDate: Date
    let duration: TimeInterval
    let samples: [HeartRateSampleModel]
}
