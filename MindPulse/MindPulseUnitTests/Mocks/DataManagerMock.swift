//
//  DataManagerMock.swift
//  MindPulse
//
//  Created by Adam Hamr on 27.01.2026.
//

import Foundation
import CoreData
@testable import MindPulse

class DataManagerMock: DataManaging {
    var context: NSManagedObjectContext {
        NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
    }
    
    // Call counters and storage for verification
    var addActivityCalled = false
    var addedActivity: ActivityModel?
    
    var fetchAllActivitiesCalled = false
    var fetchAllActivitiesReturnValue: [ActivityModel] = []
    
    var deleteActivityCalled = false
    var deletedActivityId: UUID?
    var deleteActivityReturnValue = true
    
    func addActivity(newActivity: ActivityModel) {
        addActivityCalled = true
        addedActivity = newActivity
    }
    
    func fetchAllActivities() -> [ActivityModel] {
        fetchAllActivitiesCalled = true
        return fetchAllActivitiesReturnValue
    }
    
    func deleteActivity(activityId: UUID) -> Bool {
        deleteActivityCalled = true
        deletedActivityId = activityId
        return deleteActivityReturnValue
    }
    
    // Unused in current tests but required by protocol
    func getActivityNameByRecord(recordId: UUID) -> String { "" }
    func addRecord(activityId: UUID, record: RecordModel) {}
    func fetchAllRecords() -> [RecordModel] { [] }
    func fetchRecordsByActivityId(activityId: UUID) -> [RecordModel] { [] }
    func saveActivityRecord(_ dto: ActivityRecordDTO) {}
    func fetchHeartRateSamples(record: RecordModel) -> [HeartRateSampleModel] { [] }
}
