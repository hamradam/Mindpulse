//
//  ThemeManager.swift
//  MindPulse
//
//  Created by Adam Hamr on 26.11.2025.
//

import SwiftUI

struct Theme: Identifiable, Hashable {
    var id: String
    var name: String
    var gradientColors: [Color]
    var isDark: Bool
    
    var gradient: LinearGradient {
        LinearGradient(gradient: Gradient(colors: gradientColors), startPoint: .topLeading, endPoint: .bottomTrailing)
    }
}


class ThemeManager: ObservableObject {
    @Published private(set) var currentTheme: Theme
    let availableThemes: [Theme]
    
    @AppStorage("selectedThemeId") private var storedThemeId: String = "calmDawn"
    
    private let defaultThemeId = "calmDawn"
    
    init() {
        availableThemes = [
            Theme(id: "calmDawn", name: String(localized: "Calm Dawn"), gradientColors: [Color("CalmDawnStart"), Color("CalmDawnEnd")], isDark: false),
            Theme(id: "coralReef", name: String(localized: "Coral Reef"), gradientColors: [Color("CoralReefMorningStart"), Color("CoralReefMorningEnd")], isDark: false),
            Theme(id: "warmSunsetGlow", name: String(localized: "Warm Sunset Glow"), gradientColors: [Color("WarmSunsetGlowStart"), Color("WarmSunsetGlowEnd")], isDark: false),
            Theme(id: "twilightBloom", name: String(localized: "Twilight Bloom"), gradientColors: [Color("TwilightBloomStart"), Color("TwilightBloomEnd")], isDark: true),
            Theme(id: "emeraldNightfall", name: String(localized: "Emerald Nightfall"), gradientColors: [Color("EmeraldNightfallStart"), Color("EmeraldNightfallEnd")], isDark: true),
            Theme(id: "roseQuartzHorizon", name: String(localized: "Rose Quartz Horizon"), gradientColors: [Color("RoseQuartzHorizonStart"), Color("RoseQuartzHorizonEnd")], isDark: true),
        ]

        let persistedId = UserDefaults.standard.string(forKey: "selectedThemeId") ?? defaultThemeId
        currentTheme = availableThemes.first { $0.id == persistedId } ?? availableThemes[0]
    }
    
    func select(_ theme: Theme) {
        storedThemeId = theme.id
        currentTheme = theme
        print(theme.name)
    }
}
