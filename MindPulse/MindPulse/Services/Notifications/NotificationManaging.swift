//
//  NotificationManaging.swift
//  MindPulse
//
//  Created by Petra  Šátková on 24.01.2026.
//

import UserNotifications
import UIKit

protocol NotificationManaging {
    func requestPermission() async -> Bool
    func scheduleDailyNotification(hour: Int, minute: Int, testIn5Seconds: Bool)
    func cancelDaily()
}
