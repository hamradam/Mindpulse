//
//  HeartRateSampleModel.swift
//  MindPulse
//
//  Created by Petra  Šátková on 21.01.2026.
//

import SwiftUI

struct HeartRateSampleModel: Identifiable, Codable {
    var id: UUID
    var bpm: Double
    var timestamp: Date
}
