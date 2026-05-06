//
//  ActivitiesViewModel.swift
//  MindPulse
//
//  Created by Petra  Šátková on 21.01.2026.
//

import Foundation

@Observable
class ActivitiesViewModel {
    var state: ActivitiesState = ActivitiesState()
    
    private var dataManager: DataManaging
    private var watchConnector: WatchConnecting
    
    init() {
        dataManager = DIContainer.shared.resolve()
        watchConnector = DIContainer.shared.resolve()
    }
}

extension ActivitiesViewModel {
    
    func fetchActivities() {
        let activities: [ActivityModel] = dataManager.fetchAllActivities()
        state.activities = activities
        // Sync all activities to watch when fetching
        activities.forEach { watchConnector.sendActivity(activity: $0) }
    }
    
    func addActivity(newActivity: ActivityModel) {
        dataManager.addActivity(newActivity: newActivity)
        watchConnector.sendActivity(activity: newActivity)
    }
    
    func deleteActivity(activityId: UUID) {
        let isDeleted = dataManager.deleteActivity(activityId: activityId)
        watchConnector.deleteActivity(activityId: activityId)
        self.fetchActivities()
    }
    
    func addRecord(activity: ActivityModel, record: RecordModel) {
        dataManager.addRecord(activityId: activity.id, record: record)
    }
}
