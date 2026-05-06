//
//  RecordModel.swift
//  MindPulse
//
//  Created by Petra  Šátková on 20.01.2026.
//

import SwiftUI

struct RecordModel: Identifiable {
    public var id: UUID
    public var date: Date
    public var durationSeconds: Int16
    public var focusScore: Int16?
}
