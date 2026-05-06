//
//  HeartRateManager.swift
//  MindPulse
//
//  Created by Petra  Šátková on 22.01.2026.
//

import HealthKit
import Foundation

@available(iOS 26.0, *)
class HeartRateManager : NSObject, HKWorkoutSessionDelegate, HKLiveWorkoutBuilderDelegate, HeartRateManaging {
    
    let healthStore = HKHealthStore()
    private var session: HKWorkoutSession?
    private var builder: HKLiveWorkoutBuilder?
    
    var onSample: ((Double, Date) -> Void)?
    var onStateChange: ((HKWorkoutSessionState) -> Void)?
    var onError: ((Error) -> Void)?
    
    
    func workoutBuilder(_ workoutBuilder: HKLiveWorkoutBuilder, didCollectDataOf collectedTypes: Set<HKSampleType>) {
        guard let hrType = HKQuantityType.quantityType(forIdentifier: .heartRate),
              collectedTypes.contains(hrType),
              let stats = workoutBuilder.statistics(for: hrType),
              let quantity = stats.mostRecentQuantity() else { return }

        let bpm = quantity.doubleValue(for: HKUnit.count().unitDivided(by: .minute()))
        print("🫀 Received HR sample: \(bpm)")
        onSample?(bpm, Date())
    }
    
    func workoutBuilderDidCollectEvent(_ workoutBuilder: HKLiveWorkoutBuilder) {
        
    }
    
    func workoutSession(_ workoutSession: HKWorkoutSession, didChangeTo toState: HKWorkoutSessionState, from fromState: HKWorkoutSessionState, date: Date)
    {
        onStateChange?(toState)

        // When ended, properly finish builder so HealthKit cleans up
        if toState == .ended {
            builder?.endCollection(withEnd: date) { _, error in
                if let error { self.onError?(error) }
                self.builder?.finishWorkout { _, error in
                    if let error { self.onError?(error) }
                    self.session = nil
                    self.builder = nil
                }
            }
        }
    }
    
    func workoutSession(_ workoutSession: HKWorkoutSession, didFailWithError error: any Error) {
        onError?(error)
    }
}

@available(iOS 26.0, *)
extension HeartRateManager {
    
    func requestAuthorization() async throws {
        guard HKHealthStore.isHealthDataAvailable() else { return }

        let heartRate = HKObjectType.quantityType(forIdentifier: .heartRate)!
        let workout = HKObjectType.workoutType()
        
        let types: Set<HKSampleType> = [heartRate, workout]
        
        try await healthStore.requestAuthorization(
            toShare: types,
            read: types
        )
    }

    func startRecording(collectHeartRate: Bool) throws {
        let config = HKWorkoutConfiguration()
        config.activityType = .mindAndBody
        config.locationType = .unknown

        let session = try HKWorkoutSession(
            healthStore: healthStore,
            configuration: config
        )

        let builder = session.associatedWorkoutBuilder()
        
        if collectHeartRate {
            print("❤️ Enabling HR data source")
            builder.dataSource = HKLiveWorkoutDataSource(
                healthStore: healthStore,
                workoutConfiguration: config
            )
        } else {
            print("🚫 HR collection disabled")
        }

        session.delegate = self
        builder.delegate = self

        self.session = session
        self.builder = builder

        session.startActivity(with: Date())
        builder.beginCollection(withStart: Date()) { success, error in
            print("🏁 Begin collection: \(success), error: \(String(describing: error))")
        }
    }

    func stopRecording() {
        session?.end()
    }
}
