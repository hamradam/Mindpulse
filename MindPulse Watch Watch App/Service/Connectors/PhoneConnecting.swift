//
//  PhoneConnecting.swift
//  MindPulse Watch Watch App
//
//  Created by Petra  Šátková on 21.01.2026.
//
//

import SwiftUI
import WatchConnectivity

protocol PhoneConnecting {
    func session(_ session: WCSession, didReceiveMessage message: [String : Any])
    func transferActivityRecord(payload: ActivityRecordDTO)
    func requestInitialSync()
}
