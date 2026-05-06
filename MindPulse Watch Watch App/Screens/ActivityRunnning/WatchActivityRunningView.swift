//
//  WatchActivityRunningView.swift
//  MindPulse Watch Watch App
//
//  Created by Adam Hamr on 27.01.2026.
//

import SwiftUI
import Combine

// Screen managing the active workout session
struct WatchActivityRunningView: View {
    
    var activity: ActivityModel
    var totalTime: Int
    @State var viewModel = WatchViewModel()
    
    @State private var timeRemaining: Int
    @State private var isTimerRunning: Bool = true
    @State private var endTime: Date?
    @Environment(\.dismiss) var dismiss
    @Environment(\.scenePhase) var scenePhase //kontroluje zda je obrazovka zobrazena ci nikoliv
    @State private var isFinished: Bool = false
    @Binding var path: NavigationPath
    
    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    init(activity: ActivityModel, totalTime: Int, path: Binding<NavigationPath>) {
        self.activity = activity
        self.totalTime = totalTime
        self._path = path
        _timeRemaining = State(initialValue: totalTime)
    }
    
    var body: some View {
        Group {
            if isFinished {
                WatchActivityCompletedView(activity: activity, duration: totalTime, path: $path)
            } else {
                VStack(spacing: 4) {
                    //casovac
                    VStack(spacing: -2) {
                        Text("REMAINING")
                            .font(.system(size: 10, weight: .bold, design: .rounded))
                            .foregroundStyle(.secondary)
                            .padding(.top, 2)
                        
                        Text(formatTime(timeRemaining))
                            .font(.system(size: 42, weight: .bold, design: .rounded))
                            .contentTransition(.numericText())
                            .minimumScaleFactor(0.6)
                            .lineLimit(1)
                    }
                    .padding(.horizontal)
                    
                    //linearni progress bar
                    GeometryReader { proxy in
                        ZStack(alignment: .leading) {
                            Capsule()
                                .fill(Color.gray.opacity(0.3))
                                .frame(height: 5)
                            
                            Capsule()
                                .fill(activity.color.swiftUIColor)
                                .frame(width: proxy.size.width * (CGFloat(timeRemaining) / CGFloat(totalTime)), height: 5)
                                .animation(.linear(duration: 1), value: timeRemaining)
                        }
                    }
                    .frame(height: 5)
                    .padding(.horizontal, 16)
                    .padding(.top, 4)
                    
                    Spacer(minLength: 4)
                    
                    //tepova frekvence
                    //tepova frekvence
                    if activity.hrRecording {
                        HStack(spacing: 5) {
                            Image(systemName: "heart.fill")
                                .font(.system(size: 20))
                                .foregroundStyle(viewModel.currentBPM > 0 ? .red : .gray.opacity(0.3))
                                .symbolEffect(.bounce, options: .repeating, isActive: viewModel.currentBPM > 0)
                            
                            Text(viewModel.currentBPM > 0 ? "\(viewModel.currentBPM)" : "--")
                                .font(.system(size: 28, weight: .bold, design: .rounded))
                                .contentTransition(.numericText())
                            
                            Text("BPM")
                                .font(.system(size: 11, weight: .semibold, design: .rounded))
                                .foregroundStyle(.secondary)
                                .offset(y: 4)
                        }
                        .padding(.vertical, 6)
                        .padding(.horizontal, 14)
                        .background(Color.gray.opacity(0.15))
                        .clipShape(Capsule())
                    } else {
                        HStack(spacing: 5) {
                             Image(systemName: "heart.slash")
                                 .font(.system(size: 20))
                                 .foregroundStyle(.gray.opacity(0.5))
                             
                             Text("Off")
                                 .font(.system(size: 24, weight: .bold, design: .rounded))
                                 .foregroundStyle(.gray.opacity(0.7))
                        }
                        .padding(.vertical, 6)
                        .padding(.horizontal, 14)
                    }
                    
                    Spacer(minLength: 4)
                    
                    //pauzovaci tlacitko
                    Button(action: {
                        withAnimation {
                            isTimerRunning.toggle()
                        }
                        if isTimerRunning {
                            // Resume: set new endTime based on current remaining time
                            endTime = Date().addingTimeInterval(Double(timeRemaining))
                            viewModel.startActivity(activity: activity)
                        } else {
                            endTime = nil
                            viewModel.stopActivity(activityId: activity.id)
                        }
                    }) {
                        Image(systemName: isTimerRunning ? "pause.fill" : "play.fill")
                            .font(.title3)
                            .fontWeight(.bold)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(isTimerRunning ? .orange : .green)
                    .clipShape(Circle())
                    .controlSize(.regular)
                    .padding(.bottom, 2)
                }
                .navigationTitle(activity.name)
                .navigationBarTitleDisplayMode(.inline)
                .edgesIgnoringSafeArea(.bottom)
            }
        }
        .onReceive(timer) { _ in //aktualizuje timer
            guard isTimerRunning, let endTime = endTime else { return }
            
            let remaining = Int(endTime.timeIntervalSince(Date()))
            if remaining >= 0 {
                timeRemaining = remaining
            } else {
                timeRemaining = 0
                isTimerRunning = false
                self.endTime = nil
                viewModel.stopActivity(activityId: activity.id)
                withAnimation {
                    isFinished = true
                }
            }
        }
        .onChange(of: scenePhase) { newPhase in //ukazuje spravnou hodnotu i kdyz je app na pozadi
            if newPhase == .active {
                if isTimerRunning, let endTime = endTime {
                    let remaining = Int(endTime.timeIntervalSince(Date()))
                    timeRemaining = max(0, remaining)
                }
            }
        }
        .onAppear {
            Task {
                await viewModel.requestAuthorization()
                if isTimerRunning && endTime == nil {
                    endTime = Date().addingTimeInterval(Double(timeRemaining))
                }
                viewModel.startActivity(activity: activity)
            }
        }
        .onDisappear {
            if isTimerRunning {
                viewModel.stopActivity(activityId: activity.id)
            }
        }
    }
    
    // Formats seconds into MM:SS string
    func formatTime(_ totalSeconds: Int) -> String {
        let minutes = totalSeconds / 60
        let seconds = totalSeconds % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}

#Preview {
    WatchActivityRunningView(activity: .sampleData[0], totalTime: 65, path: .constant(NavigationPath()))
}
