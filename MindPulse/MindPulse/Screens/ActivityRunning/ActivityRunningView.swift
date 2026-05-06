//
//  ActivityRunningView.swift
//  MindPulse
//
//  Created by Adam Hamr on 22.01.2026.
//

import SwiftUI

struct ActivityRunningView: View {
    
    var activity: ActivityModel
    var totalTime: Int = 15*60
    
    @Binding var path: NavigationPath
    
    @State private var timeRemaining: Int
    @State private var isTimerRunning: Bool = true
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var viewModel: ActivitiesViewModel = ActivitiesViewModel()
    
    init(activity: ActivityModel, totalTime: Int = 15 * 60, path: Binding<NavigationPath>) {
        self.activity = activity
        self.totalTime = totalTime
        self._path = path
        _timeRemaining = State(initialValue: totalTime)
    }
    
    @Environment(\.dismiss) var dismiss
    @State private var isFinished: Bool = false
    
    @Environment(\.scenePhase) var scenePhase
    @State private var endTime: Date?
    
    //Screen showing the progress of current session
    var body: some View {
        Group {
            if isFinished {
                ActivityCompletedView(activity: activity, duration: totalTime) {
                    // Reset navigation stack to return to root (ActivitiesView)
                    path = NavigationPath()
                    createRecord()
                }
            } else {
                VStack {
                    
                    //activity name
                    VStack(spacing: 40) {
                        Text(activity.name)
                            .font(.system(size: 32, weight: .bold))
                            .padding(.top, 40)
                        
                        //kruhova animace
                        ZStack{
                            Circle().stroke(.gray.opacity(0.3), lineWidth: 20)
                            
                            Circle()
                                .trim(from: 0, to: CGFloat(timeRemaining) / CGFloat(totalTime))
                                .stroke(
                                    LinearGradient(
                                        colors: [Color.blue, Color.cyan],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    ),
                                    style: StrokeStyle(lineWidth: 20, lineCap: .round)
                                )
                                .rotationEffect(.degrees(-90)) // Start nahoře
                                .animation(.linear(duration: 1), value: timeRemaining)
                        }
                        
                        //zbyvajici cas
                        VStack(spacing: 15) {
                            Text(formatTime(timeRemaining))
                                .font(.system(size: 64, weight: .bold, design: .rounded))
                            
                            Text(activity.emoji)
                                .font(.system(size: 50))
                        }
                    }
                    .padding(.horizontal, 50)
                    
                    Spacer()
                    
                    //Play/pause button
                    Button(action:{
                        isTimerRunning.toggle()
                        if isTimerRunning {
                            // Resume: set new endTime based on current remaining time
                            endTime = Date().addingTimeInterval(TimeInterval(timeRemaining))
                        } else {
                            // Pause: clear endTime
                            endTime = nil
                        }
                    }){
                        Image(systemName: isTimerRunning ? "pause.fill" : "play.fill")
                            .font(.system(size: 44))
                    }
                    .buttonStyle(.primary)
                    .padding(.horizontal, 40)
                    .padding(.bottom, 50)
                }
                .onAppear {
                    // Initialize endTime when view appears
                    if isTimerRunning && endTime == nil {
                        endTime = Date().addingTimeInterval(TimeInterval(timeRemaining))
                    }
                }
                .onChange(of: scenePhase) { newPhase in
                    if newPhase == .active, isTimerRunning, let end = endTime {
                        // App came to foreground: recalculate timeRemaining
                        let remaining = Int(end.timeIntervalSince(Date()))
                        
                        if remaining <= 0 {
                            timeRemaining = 0
                            isTimerRunning = false
                            isFinished = true
                        } else {
                            timeRemaining = remaining
                        }
                    } else if newPhase == .background, isTimerRunning {
                         // App goes to background: ensure endTime is correct (already set on start/resume)
                    }
                }
                .onReceive(timer) { _ in
                    guard isTimerRunning else { return }
                    
                    // Always try to sync with endTime if available, to prevent drift
                    if let end = endTime {
                        let remaining = Int(end.timeIntervalSince(Date()))
                        if remaining <= 0 {
                            timeRemaining = 0
                            isTimerRunning = false
                            withAnimation {
                                isFinished = true
                            }
                        } else {
                            timeRemaining = remaining
                        }
                    } else {
                       // Fallback if endTime is somehow missing (shouldn't happen if running)
                       if timeRemaining > 0 {
                            timeRemaining -= 1
                       }
                    }
                }
            }
        }
    }
    
    func formatTime(_ totalSeconds: Int) -> String {
        let minutes = totalSeconds / 60
        let seconds = totalSeconds % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    func createRecord() {
        let newRecord = RecordModel(
            id: UUID(),
            date: Date(),
            durationSeconds: Int16(totalTime)
        )
        viewModel.addRecord(activity: activity, record: newRecord)
    }
}
