//
//  Untitled.swift
//  MindPulse
//
//  Created by Petra  Šátková on 20.01.2026.
//

import WatchConnectivity

protocol WatchConnecting {
    func session(_ session: WCSession, didReceiveUserInfo userInfo: [String : Any])
    func sendActivity(activity: ActivityModel)
    func deleteActivity(activityId: UUID)
}
