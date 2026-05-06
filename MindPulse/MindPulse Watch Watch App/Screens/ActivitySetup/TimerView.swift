//
//  TimerView.swift
//  MindPulse Watch Watch App
//
//  Created by Petra  Šátková on 24.01.2026.
//

import SwiftUI

struct TimerView: View {
    @State var viewModel: WatchViewModel = WatchViewModel()
    var activity: ActivityModel
    
    @Binding var path: NavigationPath
    
    @State var hours: Int = 0
    @State var minutes: Int = 0
    @State var seconds: Int = 0
    @State var isTimerRunning: Bool = false
    @State var paused: Bool = false
    @State var finished: Bool = false
    
    var body: some View {
        VStack {
            TimeWheelPickerView(hours: $hours, minutes: $minutes, seconds: $seconds)
            
            Button(action: {
                let totalTime = (hours * 3600) + (minutes * 60) + seconds
                path.append(RunningSession(activity: activity, totalTime: totalTime))
            }) {
                Text("Dive in")
            }
            .buttonStyle(.primary)
            .disabled(hours == 0 && minutes == 0 && seconds == 0)
        }
        .navigationTitle(activity.name)
    }
}

#Preview {
    TimerView(viewModel: WatchViewModel(), activity: .sampleData.first ?? ActivityModel(
        id: UUID(), name: "meditation", emoji: "", color: .green, hrRecording: true), path: .constant(NavigationPath()))
}
