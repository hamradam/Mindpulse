//
//  DataMananing.swift
//  MindPulse
//
//  Created by Petra  Šátková on 20.01.2026.
//

import SwiftUI
import CoreData

protocol DataManaging {
    var context: NSManagedObjectContext { get }
    
    // activities
    func addActivity(newActivity: ActivityModel)
    func fetchAllActivities() -> [ActivityModel]
    func deleteActivity(activityId: UUID) -> Bool
    func getActivityNameByRecord(recordId: UUID) -> String
    
    // records
    func addRecord(activityId: UUID, record: RecordModel)
    func fetchAllRecords() -> [RecordModel]
    func fetchRecordsByActivityId(activityId: UUID) -> [RecordModel]
    
    // heart rate samples
    func saveActivityRecord(_ dto: ActivityRecordDTO)
    func fetchHeartRateSamples(record: RecordModel) -> [HeartRateSampleModel]
}
