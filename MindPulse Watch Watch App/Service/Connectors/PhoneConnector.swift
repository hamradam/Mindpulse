//
//  PhoneConnector.swift
//  MindPulse Watch Watch App
//
//  Created by Petra  Šátková on 21.01.2026.
//
//

import SwiftUI
import WatchConnectivity
import CoreData

class PhoneConnector: NSObject, WCSessionDelegate, PhoneConnecting {
    
    private var session: WCSession
    private var dataManager: DataManaging
    private var heartRateManager: HeartRateManaging
    
    init(session: WCSession = .default, dataManager: DataManaging, heartRateManager: HeartRateManaging) {
        self.session = session
        self.dataManager = dataManager
        self.heartRateManager = heartRateManager
        super.init()
        self.session.delegate = self
        self.session.activate()
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: (any Error)?) {
        if let error = error {
            print("WCSession activation failed: \(error.localizedDescription)")
            return
        }
        print("WCSession activated with state: \(activationState.rawValue)")
        if activationState == .activated {
            self.requestInitialSync()
        }
    }
    
    // Převede se spustí synchronizaci, jakmile je telefon v dosahu
    func sessionReachabilityDidChange(_ session: WCSession) {
        print("WCSession reachability changed: \(session.isReachable)")
        if session.isReachable {
            requestInitialSync()
        }
    }
    
    // Zpracovává příchozí zprávy pro přidání nebo smazání aktivity
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        print("Watch received message: \(message)")
        guard let action = message["action"] as? String else { return }
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            if action == "add" {
                self.handleAddActivity(message)
            } else if action == "delete" {
                self.handleDeleteActivity(message)
            }
            
            NotificationCenter.default.post(name: Notification.Name("ActivitiesUpdated"), object: nil)
        }
    }
    
    // Uloží novou aktivitu do lokální databáze
    private func handleAddActivity(_ message: [String : Any]) {
        let activity = ActivityModel(
            id: UUID(uuidString: message["id"] as? String ?? "") ?? UUID(),
            name: message["name"] as? String ?? "No name",
            emoji: message["emoji"] as? String ?? "👀",
            color: PaletteColor(rawValue: message["color"] as? String ?? "blue") ?? .blue,
            hrRecording: message["hrRecording"] as? Bool ?? true
        )
        self.dataManager.addActivity(newActivity: activity)
    }
    
    // Smaže aktivitu z lokální databáze
    private func handleDeleteActivity(_ message: [String : Any]) {
        if let idString = message["id"] as? String, let id = UUID(uuidString: idString) {
            _ = self.dataManager.deleteActivity(activityId: id)
        }
    }
    
    // Zpracuje odpověď synchronizace: aktualizuje data a smaže neexistující aktivity
    private func handleSyncResponse(_ message: [String : Any]) {
        guard let activitiesData = message["activities"] as? [[String: Any]] else { return }
        print("Processing sync response with \(activitiesData.count) activities")
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            // 1. Získání aktuálních lokálních ID
            let localActivities = self.dataManager.fetchAllActivities()
            let localIds = Set(localActivities.map { $0.id })
            var syncedIds = Set<UUID>()
            
            // 2. Přidání nebo aktualizace aktivit z odpovědi
            for data in activitiesData {
                 let id = UUID(uuidString: data["id"] as? String ?? "") ?? UUID()
                 syncedIds.insert(id)
                 
                 let activity = ActivityModel(
                    id: id,
                    name: data["name"] as? String ?? "No name",
                    emoji: data["emoji"] as? String ?? "👀",
                    color: PaletteColor(rawValue: data["color"] as? String ?? "blue") ?? .blue,
                    hrRecording: data["hrRecording"] as? Bool ?? true
                )
                self.dataManager.addActivity(newActivity: activity)
            }
            
            // 3. Smazání aktivit, které už na telefonu nejsou
            let idsToDelete = localIds.subtracting(syncedIds)
            for id in idsToDelete {
                print("Deleting obsolete activity: \(id)")
                _ = self.dataManager.deleteActivity(activityId: id)
            }
            
            NotificationCenter.default.post(name: Notification.Name("ActivitiesUpdated"), object: nil)
        }
    }
    
    // Pošle požadavek na telefon pro získání aktuálního seznamu aktivit
    func requestInitialSync() {
        print("Requesting initial sync. Reachable: \(session.isReachable)")
        if session.isReachable {
            session.sendMessage(["action": "syncRequest"], replyHandler: { [weak self] response in
                print("Received sync response via replyHandler: \(response)")
                self?.handleSyncResponse(response)
            }, errorHandler: { error in
                print("Error requesting initial sync: \(error.localizedDescription)")
            })
        } else {
             print("Session not reachable, cannot request sync.")
        }
    }
    
    func transferActivityRecord(payload: ActivityRecordDTO) {
        do {
            let data = try JSONEncoder().encode(payload)
            
            if session.isReachable {
                session.sendMessage(["action": "saveRecord", "payload": data], replyHandler: nil, errorHandler: { error in
                    print("Error sending record via sendMessage, falling back to transferUserInfo: \(error.localizedDescription)")
                    self.session.transferUserInfo(["payload": data])
                })
            } else {
                session.transferUserInfo(["payload": data])
            }
        } catch {
            print("Error encoding ActivityRecordDTO: \(error.localizedDescription)")
        }
    }
}
