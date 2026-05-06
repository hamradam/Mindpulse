//
//  WatchConnector.swift
//  MindPulse
//
//  Created by Petra  Šátková on 20.01.2026.
//

import Foundation
import WatchConnectivity

@available(iOS 26.0, *)
class WatchConnector : NSObject, WCSessionDelegate, WatchConnecting {
    
    private var session: WCSession
    private var dataManager: DataManaging
    
    init(session: WCSession = .default, dataManager: DataManaging) {
        self.session = session
        self.dataManager = dataManager
        super.init()
        self.session.delegate = self
        self.session.activate()
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: (any Error)?) {
        
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        session.activate()
    }
    
    
    // synchronizuje seznam aktivit
    func session(_ session: WCSession, didReceiveMessage message: [String : Any], replyHandler: @escaping ([String : Any]) -> Void) {
        if let action = message["action"] as? String {
            if action == "syncRequest" {
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    let response = self.createSyncResponse()
                    replyHandler(response)
                }
            }
            
        }
    }

    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        if let action = message["action"] as? String {
             if action == "saveRecord" {
                 if let data = message["payload"] as? Data {
                      do {
                          let record = try JSONDecoder().decode(ActivityRecordDTO.self, from: data)
                          dataManager.saveActivityRecord(record)
                      } catch {
                          print("Error decoding record in didReceiveMessage: \(error.localizedDescription)")
                      }
                 }
             }
         }
    }

    func session(_ session: WCSession, didReceiveUserInfo userInfo: [String : Any]) {
        guard let data = userInfo["payload"] as? Data else { return }

        do {
            let record = try JSONDecoder().decode(ActivityRecordDTO.self, from: data)
            dataManager.saveActivityRecord(record)
        } catch {
            print("Error decoding ActivityRecordDTO: \(error.localizedDescription)")
        }
    }
    
    // odpoved na synchronizaci, obsahuje pole aktivit
    private func createSyncResponse() -> [String: Any] {
        let activities = dataManager.fetchAllActivities()
        let serializedActivities = activities.map { activity -> [String: Any] in
            return [
                "id": activity.id.uuidString,
                "name": activity.name,
                "emoji": activity.emoji,
                "color": activity.color.rawValue,
                "hrRecording": activity.hrRecording
            ]
        }
        
        return [
            "action": "syncResponse",
            "activities": serializedActivities
        ]
    }
    

    private func handleSyncRequest() {
 
    }
    
    func sendActivity(activity: ActivityModel) {
        if session.isReachable {
            let message: [String: Any] = [
                "action": "add",
                "id": activity.id.uuidString,
                "name": activity.name,
                "emoji": activity.emoji,
                "color": activity.color.rawValue,
                "hrRecording": activity.hrRecording
            ]
            
            print("📤 Sending activity to Watch: \(activity.name), HR: \(activity.hrRecording)")
            
            session.sendMessage(message, replyHandler: nil) { error in
                print("Sending error: \(error.localizedDescription)")
            }
            
        } else {
            print("Session is not reachable")
        }
    }
    
    //impulz ke smazani aktivity an hodinkach
    func deleteActivity(activityId: UUID) {
        if session.isReachable {
            let message: [String: Any] = [
                "action": "delete",
                "id": activityId.uuidString
            ]
            
            session.sendMessage(message, replyHandler: nil) { error in
                print("Sending error: \(error.localizedDescription)")
            }
        } else {
            print("Session is not reachable")
        }
    }
}
