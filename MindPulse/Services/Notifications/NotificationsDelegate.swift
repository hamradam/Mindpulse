//
//  NotificationsDelegate.swift
//  MindPulse
//
//  Created by Petra  Šátková on 24.01.2026.
//

import UserNotifications

final class NotificationsDelegate: NSObject, UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification) async -> UNNotificationPresentationOptions {
        [.banner, .sound]
    }
}
