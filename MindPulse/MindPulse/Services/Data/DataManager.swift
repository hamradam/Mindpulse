//
//  DataManager.swift
//  MindPulse
//
//  Created by Petra  Šátková on 20.01.2026.
//

import SwiftUI
import CoreData
import Foundation

class DataManager: DataManaging {
    
    private let container = NSPersistentContainer(name: "Database")
    
    var context: NSManagedObjectContext {
        container.viewContext
    }
    
    init() {
        container.loadPersistentStores { _, error in
            if let error = error {
                print("Cannot create persistent store: \(error.localizedDescription)")
            }
        }
    }
    
    
    // Adds or updates an activity in Core Data
    func addActivity(newActivity: ActivityModel) {
        let request = NSFetchRequest<ActivityEntity>(entityName: "ActivityEntity")
        request.predicate = NSPredicate(format: "id == %@", newActivity.id as CVarArg)
        
        let context = self.context
        var activityEntity: ActivityEntity
        
        do {
            let results = try context.fetch(request)
            if let existing = results.first {
                activityEntity = existing
            } else {
                activityEntity = ActivityEntity(context: context)
                activityEntity.id = newActivity.id
            }
            
            activityEntity.name = newActivity.name
            activityEntity.emoji = newActivity.emoji
            activityEntity.colorKey = newActivity.color.rawValue
            activityEntity.hrRecording = newActivity.hrRecording
            
            save()
        } catch {
            print("Error checking for existing activity: \(error)")
        }
    }
    
    func fetchAllActivities() -> [ActivityModel] {
        let request = NSFetchRequest<ActivityEntity>(entityName: "ActivityEntity")
        var activities: [ActivityEntity] = []
        
        do {
            activities = try context.fetch(request)
        }catch{
            print("Cannot fetch data: \(error.localizedDescription)")
        }
        return activities.map { entity in
            ActivityModel(
                id: entity.id ?? UUID(),
                name: entity.name ?? "no name",
                emoji: entity.emoji ?? "👀",
                color: PaletteColor(rawValue: entity.colorKey ?? "blue") ?? PaletteColor.blue,
                hrRecording: entity.hrRecording
            )
        }
    }
    
    func getActivityNameByRecord(recordId: UUID) -> String {
        let recordRequest = NSFetchRequest<RecordEntity>(entityName: "RecordEntity")
        recordRequest.predicate = NSPredicate(format: "id == %@", recordId as CVarArg)
        recordRequest.fetchLimit = 1

        if let record = try? context.fetch(recordRequest).first,
           let activityName = record.activity?.name {
            return activityName
        }
        return "no name"
    }
    
    // Sends a delete command for the activity to the watch app
    func deleteActivity(activityId: UUID) -> Bool {
        // fetch activity
        let activityRequest = NSFetchRequest<ActivityEntity>(entityName: "ActivityEntity")
        activityRequest.predicate = NSPredicate(format: "id == %@", activityId as CVarArg)
        
        var activities: [ActivityEntity] = []
        
        do {
            activities = try context.fetch(activityRequest)
        } catch {
            print("Cannot fetch data: \(error.localizedDescription)")
            return false
        }
        
        guard !activities.isEmpty else { return false }
        
        // Delete all matching activities
        for activity in activities {
            context.delete(activity)
        }
        
        save()
        return true
    }
    
    // records
    func addRecord(activityId: UUID, record: RecordModel) {
        let request = NSFetchRequest<ActivityEntity>(entityName: "ActivityEntity")
        request.predicate = NSPredicate(format: "id == %@", activityId as CVarArg)
        
        var activities: [ActivityEntity] = []
        
        do {
            activities = try context.fetch(request)
        } catch{
            print("Cannot fetch data: \(error.localizedDescription)")
        }
        
        guard let activity = activities.first else { return }
        
        let newRecord = RecordEntity(context: context)
        newRecord.id = UUID()
        newRecord.date = record.date
        newRecord.durationSeconds = Int16(record.durationSeconds)
        newRecord.activity = activity
        save()
        print("Record added")
    }
    
    func fetchAllRecords() -> [RecordModel] {
        let activities: [ActivityModel] = fetchAllActivities()
        var records: [RecordModel] = []
        
        for activity in activities {
            var activityRecords: [RecordModel] = fetchRecordsByActivityId(activityId: activity.id)
            records.append(contentsOf: activityRecords)
        }
        
        return records.sorted { $0.date > $1.date }
    }
    
    func fetchRecordsByActivityId(activityId: UUID) -> [RecordModel] {
        let recordRequest = NSFetchRequest<RecordEntity>(entityName: "RecordEntity")
        recordRequest.predicate = NSPredicate(format: "activity.id == %@", activityId as CVarArg)
        
        var records: [RecordEntity] = []
        
        do {
            records = try context.fetch(recordRequest)
        } catch {
            print("Cannot fetch data: \(error.localizedDescription)")
        }
        
        return records.map { record in
            RecordModel(
                id: record.id ?? UUID(),
                date: record.date ?? Date(),
                durationSeconds: record.durationSeconds,
                focusScore: record.focusScore)
        }.sorted { $0.date > $1.date }
    }
    
    
    // zaznam aktivity
    func saveActivityRecord(_ dto: ActivityRecordDTO) {
        let activityRequest = NSFetchRequest<ActivityEntity>(entityName: "ActivityEntity")
        activityRequest.predicate = NSPredicate(format: "id == %@", dto.activityId as CVarArg)
        
        do {
            guard let activity = try context.fetch(activityRequest).first else {
                print("Activity not found for ID: \(dto.activityId)")
                return
            }
            
            let newRecord = RecordEntity(context: context)
            newRecord.id = UUID()
            newRecord.date = dto.startDate
            newRecord.durationSeconds = Int16(dto.duration)
            newRecord.activity = activity
            
            // Calculate and save Focus Score
            if let focusScore = calculateFocusScore(from: dto.samples) {
                newRecord.focusScore = focusScore
            }
            
            for sample in dto.samples {
                let hrEntity = HeartRateSampleEntity(context: context)
                hrEntity.id = UUID()
                hrEntity.bpm = sample.bpm
                hrEntity.timestamp = sample.timestamp
                hrEntity.record = newRecord
            }
            
            save()
            print("Successfully saved activity record with \(dto.samples.count) heart rate samples.")
            NotificationCenter.default.post(name: Notification.Name("RecordsUpdated"), object: nil)
            
        } catch {
            print("Error saving activity record: \(error.localizedDescription)")
        }
    }
    
    func fetchHeartRateSamples(record: RecordModel) -> [HeartRateSampleModel] {
        let recordRequest = NSFetchRequest<HeartRateSampleEntity>(entityName: "HeartRateSampleEntity")
        recordRequest.predicate = NSPredicate(format: "record.id == %@", record.id as CVarArg)
        
        var hrSamples: [HeartRateSampleEntity] = []
        
        do {
            hrSamples = try context.fetch(recordRequest)
        } catch {
            print("Cannot fetch data: \(error.localizedDescription)")
        }
        
        return hrSamples.map { hrSample in
            HeartRateSampleModel(
                id: hrSample.id ?? UUID(),
                bpm: hrSample.bpm,
                timestamp: hrSample.timestamp ?? Date())
        }
    }
    
    private func calculateFocusScore(from samples: [HeartRateSampleModel]) -> Int16? {
        // minimalne 8 vzorku
        guard samples.count >= 8 else { return nil }
        
        let bpms = samples.map { Double($0.bpm) }
        let count = Double(bpms.count)
        let mean = bpms.reduce(0, +) / count
        
        // 1. Macro-Stability: Coefficient of Variation (CV)
        let sumSquaredDiff = bpms.reduce(0) { $0 + pow($1 - mean, 2) }
        let sd = sqrt(sumSquaredDiff / count)
        let cv = (sd / mean) * 100.0
        
        // 2. Micro-Stability: Mean Successive Difference (MSD)
        var successiveDiffSum = 0.0
        for i in 0..<(bpms.count - 1) {
            successiveDiffSum += abs(bpms[i+1] - bpms[i])
        }
        let msd = successiveDiffSum / (count - 1)
        
        // Instead of linear penalties, we use a square root curve (sqrt).
        // This means small natural fluctuations are barely penalized, 
        // but larger, sustained instability starts to drop the score noticeably.
        // We also adjust weights to be more 'human' (2.0 and 1.0).
        let macroPenalty = sqrt(cv) * 8.0 // CV of 4% (stable) approx 16 pts penalty
        let microPenalty = sqrt(msd) * 4.0 // MSD of 2 (stable) approx 5 pts penalty
        
        let finalScore = 100.0 - (macroPenalty + microPenalty)
        
        // Output clamped between 0-100
        return Int16(max(0, min(100, round(finalScore))))
    }
}

private extension DataManager {
    private func save(){
        if context.hasChanges {
         do {
             try context.save()
            }catch {
                print("Cannot save MOC: \(error.localizedDescription)")
         }
        }
    }
}
