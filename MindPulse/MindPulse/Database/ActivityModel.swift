//
//  ActivityModel.swift
//  MindPulse
//
//  Created by Petra  Šátková on 20.01.2026.
//

import SwiftUI
//import ElegantEmojiPicker

struct ActivityModel: Identifiable, Hashable, Codable, Equatable {
    public var id: UUID
    public var name: String
    public var emoji: String
    public var color: PaletteColor
    public var hrRecording: Bool
}

enum PaletteColor: String, CaseIterable, Hashable, Codable {
    case red, orange, yellow, green, mint, teal, cyan, blue, indigo, purple, pink, brown, gray

    var swiftUIColor: Color {
        switch self {
        case .red: Color(hue: 0.0, saturation: 0.6, brightness: 0.95)
        case .orange: Color(hue: 0.08, saturation: 0.5, brightness: 1.0)
        case .yellow: Color(hue: 0.14, saturation: 0.6, brightness: 1.0)
        case .green: Color(hue: 0.35, saturation: 0.5, brightness: 0.9)
        case .mint: Color(hue: 0.40, saturation: 0.4, brightness: 0.98) 
        case .teal: Color(hue: 0.48, saturation: 0.55, brightness: 0.85)
        case .cyan: Color(hue: 0.53, saturation: 0.45, brightness: 0.95)
        case .blue: Color(hue: 0.62, saturation: 0.5, brightness: 1.0)
        case .indigo: Color(hue: 0.68, saturation: 0.5, brightness: 0.9)
        case .purple: Color(hue: 0.78, saturation: 0.45, brightness: 0.95)
        case .pink: Color(hue: 0.9, saturation: 0.4, brightness: 1.0)
        case .brown: Color(hue: 0.08, saturation: 0.4, brightness: 0.7)
        case .gray: Color(white: 0.8)
        }
    }
}

//SampleData for Watch design testing
extension ActivityModel {
    static let sampleData: [ActivityModel] = [
        ActivityModel(
            id: UUID(),
            name: "Meditation",
            emoji: "🧘‍♀️",
            color: .orange,
            hrRecording: true
        ),
        ActivityModel(
            id: UUID(),
            name: "Running",
            emoji: "🏃‍♂️",
            color: .blue,
            hrRecording: true
        ),
        ActivityModel(
            id: UUID(),
            name: "Deep Performance Work",
            emoji: "💻",
            color: .purple,
            hrRecording: false
        ),
        ActivityModel(
            id: UUID(),
            name: "Reading",
            emoji: "📚",
            color: .green,
            hrRecording: false
        ),
        ActivityModel(
            id: UUID(),
            name: "Sleep",
            emoji: "😴",
            color: .gray,
            hrRecording: false
        )
    ]
}
