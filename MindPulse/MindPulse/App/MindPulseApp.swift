//
//  MindPulseApp.swift
//  MindPulse
//
//  Created by Adam Hamr on 25.11.2025.
//

import SwiftUI

@available(iOS 26.0, *)
@main
struct MindPulseApp: App {
    @StateObject private var themeManager = ThemeManager()
    private let notifDelegate = NotificationsDelegate()
    private let watchConnector: WatchConnecting

    init() {
        UNUserNotificationCenter.current().delegate = notifDelegate
        self.watchConnector = DIContainer.shared.resolve()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(themeManager)
        }
    }
}
