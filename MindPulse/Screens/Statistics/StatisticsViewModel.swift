//
//  StatisticsViewModel.swift
//  MindPulse
//
//  Created by Petra  Šátková on 24.01.2026.
//

import Foundation

@Observable
class StatisticsViewModel {
    var state: StatisticsState = StatisticsState()
    
    private var dataManager: DataManaging
    
    init() {
        dataManager = DIContainer.shared.resolve()
        
        NotificationCenter.default.addObserver(forName: Notification.Name("RecordsUpdated"), object: nil, queue: .main) { [weak self] _ in
            self?.fetchRecords()
            self?.calculateTotalTime(activity: nil) // Default calc
            self?.calculateTotalCount(activity: nil)
            if let records = self?.state.records {
                self?.minutesByDayForCurrentWeek(records: records)
            }
        }
    }
}

extension StatisticsViewModel {
    
    func fetchActivities() {
        let activities: [ActivityModel] = dataManager.fetchAllActivities()
        state.activities = activities
    }
    
    func fetchRecords() {
        let records: [RecordModel] = dataManager.fetchAllRecords()
        state.records = records
    }
    
    func fetchRecordsByActivity(activity: ActivityModel) -> [RecordModel] {
        let records: [RecordModel] = dataManager.fetchRecordsByActivityId(activityId: activity.id)
        return records
    }
    
    func getActivityNameByRecord(record: RecordModel) -> String {
        return dataManager.getActivityNameByRecord(recordId: record.id)
    }
    
    func calculateTotalTime(activity: ActivityModel?) {
        var totalSeconds: Int = 0
        let recordsToCalculate: [RecordModel] = activity == nil ?
                state.records : // all records for all activities
                dataManager.fetchRecordsByActivityId(activityId: activity?.id ?? UUID()) // records of filtered activity
 
        for record in recordsToCalculate {
            totalSeconds += Int(record.durationSeconds)
        }
        
        state.totalMinutes = Int(totalSeconds / 60)
    }
    
    func calculateTotalCount(activity: ActivityModel?) {
        if activity == nil {
            state.totalCount = state.records.count
            
        } else {
            let records: [RecordModel] = dataManager.fetchRecordsByActivityId(activityId: activity?.id ?? UUID())
            state.totalCount = records.count
        }
    }

    func minutesByDayForCurrentWeek(records: [RecordModel], calendar: Calendar = .current) {
        // Start of week (Monday)
        let startOfToday = calendar.startOfDay(for: Date())
        let weekday = calendar.component(.weekday, from: startOfToday) // 1=Sun ... 7=Sat (in Gregorian)
        // Convert to Monday-based offset:
        let mondayOffset = (weekday + 5) % 7 // Mon->0, Tue->1, ... Sun->6
        let startOfWeek = calendar.date(byAdding: .day, value: -mondayOffset, to: startOfToday)!

        // Prepare buckets Mon..Sun
        let labels = ["Mon","Tue","Wed","Thu","Fri","Sat","Sun"]
        var totals = Array(repeating: 0, count: 7) // minutes

        // Sum minutes for records inside [startOfWeek, startOfWeek+7days)
        let endOfWeek = calendar.date(byAdding: .day, value: 7, to: startOfWeek)!

        for r in records {
            guard r.date >= startOfWeek && r.date < endOfWeek else { continue }

            // Determine Monday-based day index 0..6
            let startOfRecordDay = calendar.startOfDay(for: r.date)
            let dayDiff = calendar.dateComponents([.day], from: startOfWeek, to: startOfRecordDay).day ?? 0
            guard (0...6).contains(dayDiff) else { continue }

            totals[dayDiff] += Int(round(Double(r.durationSeconds) / 60.0))
        }

        // Build chart points
        state.weeklyPoints = (0..<7).map { i in
            DayMinutes(weekdayIndex: i + 1, label: labels[i], minutes: totals[i])
        }
    }
    
    func fetchHrSamplesByRecord(record: RecordModel) {
        let samples = dataManager.fetchHeartRateSamples(record: record)
        state.hrSamples = samples
        state.focusScore = record.focusScore
        calculateHeartRateStats()
    }

    private func calculateHeartRateStats() {
        let bpms = state.hrSamples.map { Int($0.bpm) }
        
        if bpms.isEmpty {
            state.minHR = nil
            state.maxHR = nil
            state.avgHR = nil
        } else {
            state.minHR = bpms.min()
            state.maxHR = bpms.max()
            let sum = bpms.reduce(0, +)
            state.avgHR = sum / bpms.count
        }
    }
    
}
