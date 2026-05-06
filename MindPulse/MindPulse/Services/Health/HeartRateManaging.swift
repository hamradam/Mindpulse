//
//  HeartRateManaging.swift
//  MindPulse
//
//  Created by Petra  Šátková on 22.01.2026.
//

import HealthKit

protocol HeartRateManaging {
    func requestAuthorization() async throws
    func startRecording(collectHeartRate: Bool) throws
    func stopRecording()

    var onSample: ((Double, Date) -> Void)? { get set }
    var onStateChange: ((HKWorkoutSessionState) -> Void)? { get set }
    var onError: ((Error) -> Void)? { get set }
}
