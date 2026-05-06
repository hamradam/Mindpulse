//
//  NotificationsDelegate.swift
//  MindPulse
//
//  Created by Petra  Šátková on 24.01.2026.
//

import UserNotifications
import UIKit

class NotificationManager: NotificationManaging {
    
    func requestPermission() async -> Bool {
            do {
                let granted = try await UNUserNotificationCenter.current()
                    .requestAuthorization(options: [.alert, .sound, .badge])
                return granted
            } catch {
                print("Notification auth error:", error)
                return false
            }
        }
    
    func scheduleDailyNotification(hour: Int, minute: Int, testIn5Seconds: Bool = false) {
        let content = UNMutableNotificationContent()
        content.title = "Reminder"
        content.body = "Don’t forget to log your entry today."
        content.sound = .default

        let trigger: UNNotificationTrigger
        if testIn5Seconds {
            trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        } else {
            var dc = DateComponents()
            dc.hour = hour
            dc.minute = minute
            trigger = UNCalendarNotificationTrigger(dateMatching: dc, repeats: true)
        }

        let request = UNNotificationRequest(
            identifier: "daily_reminder",
            content: content,
            trigger: trigger
        )

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error { print("Schedule error:", error) }
        }
    }

    
    func cancelDaily() {
            UNUserNotificationCenter.current()
                .removePendingNotificationRequests(withIdentifiers: ["daily_reminder"])
        }
}
