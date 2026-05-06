//
//  WatchConnectorMock.swift
//  MindPulse
//
//  Created by Adam Hamr on 27.01.2026.
//

import Foundation
import WatchConnectivity
@testable import MindPulse

class WatchConnectorMock: WatchConnecting {
    
    var sendActivityCalled = false
    var sentActivity: ActivityModel?
    
    var deleteActivityCalled = false
    var deletedActivityId: UUID?
    
    func session(_ session: WCSession, didReceiveUserInfo userInfo: [String : Any]) {
        // Not needed for current tests
    }
    
    func sendActivity(activity: ActivityModel) {
        sendActivityCalled = true
        sentActivity = activity
    }
    
    func deleteActivity(activityId: UUID) {
        deleteActivityCalled = true
        deletedActivityId = activityId
    }
}
