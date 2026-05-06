//
//  AccessibilityTag.swift
//  MindPulse
//
//  Created by Adam Hamr on 27.01.2026.
//

import Foundation
import SwiftUI

enum AccessibilityTag: String {
    // Navigation
    case activitiesTab
    case statisticsTab
    
    // Content View
    case newActivityButton
    case settingsButton
    
    // SettingView
    case settingThemeButton
    
    // ThemeSelector
    case themeSelectorCloseButton
    case themeOptionTwilightBloom
    case themeOptionCalmDawn
    
    // NewActivityView
    case newActivityCloseButton
    case newActivitySaveButton
    case newActivityNameField
    case newActivityHRToggle
}

extension View {
    func accessibilityIdentifier(_ tag: AccessibilityTag) -> some View {
        self.accessibilityIdentifier(tag.rawValue)
    }
}

extension TabContent {
    func accessibilityIdentifier(_ tag: AccessibilityTag) -> some TabContent<Self.TabValue> {
        self.accessibilityIdentifier(tag.rawValue)
    }
}
